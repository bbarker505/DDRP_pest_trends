# ---------- SERVER ------------------------------------------------------------

# NOTE: double-rendering of plot most likely:
#At this point, after debugging dozens of Shiny apps, I actually suspect the duplicate rendering is coming from one of your raster-loading reactives (pest_raster_sen(), selected_trend(), selected_row(), etc.) rather than from the click handling or UI.
# If the isolate() change above doesn't help, the next thing I'd inspect is pest_raster_sen(). That's now the most likely place where a hidden reactive dependency is causing the plot to invalidate twice.

# Server for DDRP Pest Trends app 
# https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png?key=cb1_3ivm_1_588cb42a6b4e590c512ddf8c
# Shiny server requires this is loaded: Set-up
source("setup.R")

# Print all error messages 
options(shiny.sanitize.errors = FALSE)

# Server function
server <- function(input, output, session) {
  
  #### * Table for intro ####
  output$intro_table <- renderTable({
    intro_tab <- read.csv("intro_table.csv", check.names = FALSE)
    intro_tab
  })
  
  # Clicked location
  clicked_loc <- reactiveVal(NULL)
  
  # Selected variable ----
  
  #### * Observe selected variable ####
  observeEvent(input$pest, {
    
    current_value <- isolate(input$var_type)
    
    if (input$pest == "All 18 spp") {
      
      choices <- c(
        "Climate stress" = "climate",
        "Phenology" = "phenology"
      )
      
      # Reset invalid CLM selection
      if (current_value == "clm") {
        current_value <- "phenology"
      }
      
    } else {
      
      choices <- c(
        "Climate stress" = "climate",
        "Phenology" = "phenology",
        "All stress exclusion" = "clm"
      )
    }
    
    updateSelectInput(
      session,
      "var_type",
      choices = choices,
      selected = current_value
    )
    
  }, ignoreInit = TRUE)
  
  #### * Check which variable is selected ####
  selected_variable <- reactive({
   # message("selected_variable()")
    req(input$pest, input$var_type)
  
    # All 18 spp comparisons 
    if (input$pest == "All 18 spp") {
      
      #metric <- input$trend_metric
      metric <- input$comparison_metric
      
      # During updateSelectInput transition,
      # trend_metric is temporarily sens/tau
      if (is.null(metric) || metric == "") {
        return(NULL)
      }
        
      return(
        switch(
          metric,
          "species_num_adult" = "First Adult Emergence",
          "species_num_egg" = "First Egg Hatch",
          "species_num_cold" = "Cold Stress",
          "species_num_heat" = "Heat Stress",
          NULL
        )
      )
    }
    
    # Individual species
    if (input$var_type == "clm") {
      return("All Stress Excl")
    } else if (input$var_type == "climate") {
      return(input$clim_variable)
    } else {
      return(input$phenology)
    }
  })
  
  ### ---------------------------------------------------------------------- ###
  
  # Selected metric ----
  
  #### * Observe selected metric ####
  observeEvent(
    list(input$pest, input$var_type), {
      
      req(input$pest, input$var_type)
      current_value <- isolate(input$comparison_metric)
      
      # --- All-species comparisons ---
        
        if (input$pest != "All 18 spp") {
          return()
        }
        
        current_value <- isolate(input$comparison_metric)
        
        if (input$var_type == "phenology") {
          
          choices <- c(
            "Earlier adult emergence" = "species_num_adult",
            "Earlier egg hatch" = "species_num_egg"
          )
          
          if (!current_value %in% unname(choices)) {
            current_value <- "species_num_adult"
          }
          
        } else {
          
          choices <- c(
            "Decreasing cold stress" = "species_num_cold",
            "Increasing heat stress" = "species_num_heat"
          )
          
          if (!current_value %in% unname(choices)) {
            current_value <- "species_num_cold"
          }
        }

       updateSelectInput(
         session,
         "comparison_metric",
         choices = choices,
         selected = current_value
      )
    },
    ignoreInit = FALSE
  )
  
  
  #### * Reactive for metric ####
  selected_trend <- reactive({
    
    # Force reactivity to significance mask
    sig_only <- input$sig_only
    
    # Variable
    var_type <- if (is.null(input$var_type)) {
      "phenology"
    } else {
      input$var_type
    }
    
    req(selected_row())
    
    # --- Comparisons ---
    if (input$pest == "All 18 spp") {
      
      return(list(
        rast = pest_raster_sum(),  # or correct comparison raster loader
        title = "Num. species with significant trend"
      ))
    }
    
    # --- CLM ---
    if (var_type == "clm") {
      
      return(list(
        rast = pest_raster_clm(),
        title = "Beta coefficient"
      ))
    }
    
    # Change units
    sens_title <- if (var_type == "phenology") {
      "Change (days/year)"
    } else {
      "Change (units/year)"
    }
    
    return(list(
      rast = pest_raster_sen(),
      title = sens_title
    ))
    
  })
  
  ### ---------------------------------------------------------------------- ###
  
  # Get raster ----
  
  #### * Filter row from loookup table ####
  selected_row <- reactive({

    req(input$pest, input$year_range, input$var_type)
    
    # Comparisons
    if (input$pest == "All 18 spp") {
      
      # Wait until comparison metric is fully updated
      req(
        input$comparison_metric %in% c(
          "species_num_adult",
          "species_num_egg",
          "species_num_cold",
          "species_num_heat"
        )
      )
      
      req(selected_variable())
      
      row <- raster_lookup %>%
        dplyr::filter(
          model_type == "Comparisons",
          variable == selected_variable(),
          year == input$year_range
        )
      
      # CLM
    } else if (input$var_type == "clm") {
      
      row <- raster_lookup %>%
        dplyr::filter(
          model_type == "CLM",   
          common_name == input$pest,
          year == input$year_range
        )
      
      # MK 
    } else {
      
      row <- raster_lookup %>%
        dplyr::filter(
          model_type == "MK_trends",
          common_name == input$pest,
          variable == selected_variable(),
          year == input$year_range
        )
      
    }
    
    validate(need(nrow(row) == 1, "No raster found"))
    
    row
  })
  
  #### * Collect raster info ####
  
  # Note: 1 = tau, 2 = sen, and 3 = p-value, as organized in the .tif file
  # P-value
  pest_raster_pval <- reactive({
    
    req(selected_row())
    
    # No p-values for comparisons 
    if (input$pest == "All 18 spp" ) {
      return(NULL)
    }
    
    # P-value for CLM is in layer 2; others is layer 3
    if (input$var_type == "clm") {
      lyr <- 2
    } else {
      lyr <- 3
    }
    
    # Import raster (p-value)
    rast_import(selected_row()$file_path, lyr)
  })
  
  # Mask out non-significant areas if significance mask is selected
  # Only apply to trend layers (tau/sens)
  # Tau
  pest_raster_tau <- reactive({
    
    # Force dependency
    sig_only <- input$sig_only
    
    # Import raster
    r <- rast_import(selected_row()$file_path, 1)
    
    if (input$pest == "All 18 spp" || input$var_type == "clm") {
      return(r)
    }
    
    # Show significant areas only
    apply_sig_mask(r, pest_raster_pval(), sig_only)
    
  })
  
  # Sen
  pest_raster_sen <- reactive({
    
    # Force dependency
    sig_only <- input$sig_only
    
    # Import raster
    r <- rast_import(selected_row()$file_path, 2)
    
    if (input$pest == "All 18 spp" || input$var_type == "clm") {
      return(r)
    }
    
    # Show significant areas only
    apply_sig_mask(r, pest_raster_pval(), sig_only)
    
  })
  
  # CLM - 2 layers instead of 3 like trend rasters
  pest_raster_clm <- reactive({ 
    
    # Force dependency
    sig_only <- input$sig_only
    
    # Import raster
    r <- rast_import(selected_row()$file_path, 1)
    
    # Show significant areas only
    apply_sig_mask(r, pest_raster_pval(), sig_only)
    
    })
  
  # Note: 1 = # of species, 2 = median, 3 = min, 4 = max..., as organized in the .tif file
  
  # Comparisons - sum across 18 species
  pest_raster_sum <- reactive({ rast_import(selected_row()$file_path, 1) })
  pest_raster_slopemed <- reactive({ rast_import(selected_row()$file_path, 6) })
  pest_raster_slopese <- reactive({ rast_import(selected_row()$file_path, 7) })
  pest_raster_slopemin <- reactive({ rast_import(selected_row()$file_path, 8) })
  pest_raster_slopemax <- reactive({ rast_import(selected_row()$file_path, 9) })
  
  ### ---------------------------------------------------------------------- ###
  
  # Respond to significance checkbox ----
  
  # Show check-box "Show significant areas only" only for individual spp
  observeEvent(list(input$pest, input$var_type), {
    
    if (
      isTRUE(input$pest == "All 18 spp") 
    ) {
      updateCheckboxInput(session, "sig_only", value = FALSE)
    }
    
  }, ignoreInit = TRUE)
  
  
  ### ---------------------------------------------------------------------- ###
  
  # Initialize base map  ----
  
  # Calculate initial CONUS bounds using your new function
  conus_extent <- assign_extent("CONUS")
  conus_bounds <- ext_to_bounds(conus_extent)
  
  # Initial Map Render WITH default raster
  # Default is ALB First Adult Emergence sens slope for 1981-2025
  output$map <- renderLeaflet({
    options = leafletOptions(
      doubleClickZoom = FALSE, 
      #minZoom = 4,
      maxBounds = list(
        c(conus_bounds$west, conus_bounds$south), 
        c(conus_bounds$east, conus_bounds$north))
      )
    
    
    # Default startup raster
    startup_row <- raster_lookup %>%
      dplyr::filter(
        common_name == "Asian longhorned beetle",
        model_type == "MK_trends",
        variable == "First Adult Emergence",
        year == "1981-2025"
      )
    
    req(nrow(startup_row) > 0)
    
    # Load raster
    startup_rast <- rast_import(startup_row$file_path[1], 2)
    
    # Palette
    pal_obj <- make_palette(startup_rast, "sens")
    
    pal_func <- pal_obj$pal
    
    # Legend
    legend_html <- create_legend_html(
      "sens",
      "Change (days/year)",
      pal_func,
      pal_obj$limits
    )
    
    # Build initial map
    produce_map_base(conus_bounds) %>%
      
      # Raster data
      addRasterImage(
        startup_rast,
        colors = pal_func,
        opacity = 0.7,
        layerId = "Value",
        project = TRUE,
        options = gridOptions(
          pane = "Value"
        )
      ) %>%
      
      # Legend 
      addControl(
        html = HTML(legend_html),
        position = "bottomright"
      ) %>% 
      
      # Transparent labels only
      # addProviderTiles(
      #   providers$CartoDB.PositronOnlyLabels,
      #   group = "Labels"
      # )
      addTiles(
        urlTemplate = paste0(
          "https://basemaps.cartocdn.com/rastertiles/voyager_only_labels/",
          "{z}/{x}/{y}.png?key=",
          carto_key
        ),
        options = tileOptions(
          subdomains = "abcd",
          pane = "Labels",
          attribution = paste0(
            '&copy; <a href="https://openstreetmap.org">',
            "OpenStreetMap</a> contributors ",
            '&copy; <a href="https://carto.com">',
            "CARTO</a>"
          )
        ),
        group = "Labels"
      )
       
  })
  
  
  ### ---------------------------------------------------------------------- ###
  
  # Update map based on selections ----
  
  #### * Update map when pest changes ####
  observeEvent(
    list(selected_trend()), {
           
           # Required inputs
           req(input$pest, input$region, input$var_type, 
               input$year_range)
      
           # Should prevent flashing to wrong palette and legend for comparison maps
           is_pest_all <- (input$pest == "All 18 spp")

           # Trend and trend metric
           trend <- selected_trend()
           
           #trend_metric <- input$trend_metric %||% "sens"
           req(trend$rast)
           
           # Reactive palette
           pal_obj <- palette_reactive()
           
           if (is.null(pal_obj)) return()
           
           # Explicitly extract the function from the list
           pal_func <- pal_obj$pal
           
           # Generate the legend HTML
           legend_type <-
             if (input$pest == "All 18 spp") {
               "comparison"
             } else if (input$var_type == "clm") {
               "clm"
             } else {
               "sens"
             }
           
           legend_html <- create_legend_html(
             legend_type,
             trend$title,
             pal_func,
             pal_obj$limits
           )
           
           # Immediately clear old legend,raster and polyline for CLM raster (if present)
           leafletProxy(
             "map",
             deferUntilFlush = FALSE
           ) %>%
             clearControls() %>% 
             clearImages() %>% 
             clearGroup("clm_outline")
           
           # Add new raster, controls, and boundaries
           proxy <- leafletProxy("map") %>% 
             
             # Add raster
             addRasterImage(
               trend$rast,
               colors = pal_func,
               opacity = 0.7,
               layerId = "Value",
               project = TRUE,
               options = gridOptions(
                 pane = "Value"
               )
             ) %>%
             
             # Add legend
             addControl(
               html = HTML(legend_html),
               position = "bottomright"
             ) %>% 
             
             # Transparent labels only
             # addProviderTiles(
             #   providers$CartoDB.PositronOnlyLabels,
             #   group = "Labels"
             # )
           addTiles(
             urlTemplate = paste0(
               "https://basemaps.cartocdn.com/rastertiles/voyager_only_labels/",
               "{z}/{x}/{y}.png?key=",
               carto_key
             ),
             options = tileOptions(
               subdomains = "abcd",
               pane = "Labels",
               attribution = paste0(
                 '&copy; <a href="https://openstreetmap.org">',
                 "OpenStreetMap</a> contributors ",
                 '&copy; <a href="https://carto.com">',
                 "CARTO</a>"
               )
             ),
             group = "Labels"
           )
             
           # Add outline only for CLM rasters
           if (input$var_type == "clm") {
             
             clm_outline <- create_clm_outline(trend$rast)
             
             proxy <- proxy %>%
               
               addPolylines(
                 data = clm_outline,
                 color = "purple",
                 weight = 1,
                 opacity = 1,
                 smoothFactor = 0,
                 group = "clm_outline",
                 options = pathOptions(
                   pane = "Value"
                 )
               )
             
           }    
         }, ignoreInit = FALSE)
  
  
  #### * Reactive palette ####
  
  # For legend
  palette_reactive <- reactive({
    
    # Default metric during startup / UI re-render
    #trend_metric <- input$trend_metric %||% "sens"
    
    trend <- req(selected_trend())
    
    req(trend$rast)
    
    if (input$pest == "All 18 spp") {
      
      make_palette(
        trend$rast,
        "comparison"
      )
      
    } else if (input$var_type == "clm") {
      
      make_palette(
        trend$rast,
        "clm"
      )
      
    } else {
      
      make_palette(
        trend$rast,
        "sens"
      )
      
    }
    
  })
  
  #### * Show counties when zoomed in ####
  
  # Observer to toggle County Lines based on zoom level
  observe({
    req(input$map_zoom)
    
    leafletProxy("map") %>%
      apply_boundary_visibility(input$map_zoom)
  })
  
  #### * Adjust to another region when selected ####
  observeEvent(input$region, {
    
    # Check
    req(input$region)
    
    # Get extent from your helper
    ext <- assign_extent(input$region)
    
    # Fix bounds
    bounds <- ext_to_bounds(ext)
    
    # Clear clicked location immediately
    clicked_loc(NULL)
    
    # Adjust map
    leafletProxy("map") %>%
      fitBounds(
        lng1 = xmin(ext),
        lat1 = ymin(ext),
        lng2 = xmax(ext),
        lat2 = ymax(ext)
      ) %>%
      clearGroup("click_marker")
    
  })
  
  # Re-fit map when browser window changes size
  observeEvent(
    list(
      session$clientData$output_map_width,
      session$clientData$output_map_height
    ),
    {
      
      req(input$region == "CONUS")
      
      ext <- assign_extent("CONUS")
      
      leafletProxy("map") %>%
        fitBounds(
          lng1 = xmin(ext),
          lat1 = ymin(ext),
          lng2 = xmax(ext),
          lat2 = ymax(ext)
        )
      
    },
    ignoreInit = TRUE
  )
  
  ### ---------------------------------------------------------------------- ###
  
  # Download map as PNG ----
  
  # Different file names used for comparison vs. individual spp
  output$download_map <- downloadHandler(
    
    filename = function() {
      
      # Use different file names for comparison vs. individual spp maps
      if (input$pest == "All 18 spp") {
        
        paste0("Trend_map_18spp_", input$year_range, ".png")
        
      } else {
        
        abbrev <- species_abbrev[[input$pest]]
        
        # Fallback if something is missing
        if (is.null(abbrev)) {
          abbrev <- gsub(" ", "_", input$pest)
        }
        
        # Get the selected variable/event
        variable_name <- switch(
          input$var_type,
          phenology = input$phenology,
          climate = input$clim_variable,
          clm = "Climate_Stress_Excl"
        )
        
        # Clean variable name for filename
        variable_name <- gsub("[^A-Za-z0-9]+", "_", variable_name)
        
        paste0("Trend_Map_", abbrev, "_", variable_name, "_", 
               input$year_range, ".png")
      }
    },
    
    content = function(file) {
      
      trend <- selected_trend()
      pal_obj <- palette_reactive()
      
      req(
        trend,
        pal_obj,
        input$map_bounds,
        input$map_center,
        input$map_zoom
      )
      
      # Current map position
      bounds <- input$map_bounds
      center <- input$map_center
      zoom <- input$map_zoom
      
      # Detect comparison mode
      is_comparison <- input$pest == "All 18 spp"

      # START CLEAN
      m <- leaflet(
        options = leafletOptions(
          doubleClickZoom = FALSE,
          minZoom = 4
        )
      ) %>%
        
        # Map panes
        addMapPane("Basemap", zIndex = 400) %>%
        addMapPane("Value", zIndex = 410) %>%
        addMapPane("Labels", zIndex = 420) %>%
        addMapPane("Borders", zIndex = 430) %>%
        
        # Basemap
        addTiles(
          urlTemplate = paste0("https://{s}.basemaps.cartocdn.com/rastertiles/light_all/",
                               "{z}/{x}/{y}.png?key=", carto_key),
          options = tileOptions(
            subdomains = "abcd",
            pane = "Basemap"
          )
        ) %>%
        
        # CARTO labels only
        addTiles(
          urlTemplate = paste0("https://{s}.basemaps.cartocdn.com/rastertiles/voyager_only_labels/",
                               "{z}/{x}/{y}.png?key=", carto_key),
          options = tileOptions(
            subdomains = "abcd",
            pane = "Labels"
          )
        ) %>%
      
        # Use the current map center and zoom
        setView(
          lng = center$lng,
          lat = center$lat,
          zoom = zoom
        )
      
      # State boundaries
      m <- m %>%
        addPolylines(
          data = us_states,
          opacity = 0.6,
          color = "#444444",
          weight = 1.2,
          group = "States",
          options = pathOptions(
            pane = "Borders"
          )
        )
      
      # County boundaries
      if (zoom >= 6.5) {
        
        m <- m %>%
          addPolylines(
            data = us_counties,
            opacity = 0.4,
            color = "#777777",
            weight = 0.5,
            group = "Counties",
            options = pathOptions(
              pane = "Borders"
            )
          )
      }
      
       # Raster
       m <- m %>%
        addRasterImage(
          trend$rast,
          colors = pal_obj$pal,
          opacity = 0.9,
          layerId = "Value",
          project = TRUE,
          options = gridOptions(
            pane = "Value"
          )
        )
      
      # Legend title
      title_text <- if (is_comparison) {
        "Num. species with significant trend"
      } else {
        trend$title
      }
      
      # Legend type
      legend_type <- if (is_comparison) {
        "comparison"
      } else if (input$var_type == "clm") {
        "clm"
      } else {
        "sens"
      }
      
      # Legend
      legend_html <- create_legend_html(
        legend_type,
        title_text,
        pal_obj$pal,
        pal_obj$limits
      )
      
      # Add legend to exported map
      m <- htmlwidgets::prependContent(
        m,
        htmltools::tagList(
          
          # Load font + scoped CSS
          htmltools::tags$head(
            
            htmltools::tags$link(
              rel = "stylesheet",
              href = paste0("https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap")
            ),
            
            htmltools::tags$style(
              htmltools::HTML(
                "
              .custom-legend {
                font-family: 'Roboto', sans-serif;
              }
              "
              )
            )
          ),
          
          # Legend container
          htmltools::tags$div(
            class = "custom-legend",
            style = paste(
              "position:absolute;",
              "bottom:20px;",
              "right:20px;",
              "z-index:9999;"
            ),
            htmltools::HTML(
              legend_html
            )
          )
        )
      )
      
      # Export map as PNG

      # Explicitly create a PNG file for mapshot2
      png_file <- tempfile(fileext = ".png")
      
      mapview::mapshot2(
        m,
        file = png_file,
        vwidth = 1400,
        vheight = 800
      )
      
      # Copy PNG to the file supplied by Shiny
      file.copy(
        png_file,
        file,
        overwrite = TRUE
      )
      
      # Remove temporary PNG
      unlink(png_file)
    }
  )  
  ### ---------------------------------------------------------------------- ###
  
  # Map click ----
  
  # Add marker only
  observeEvent(location_data(), {

    loc <- location_data()

    # Create icon
    click_icon <- makeIcon(
      iconUrl = "www/bug_icon.svg",
      iconWidth = 32,
      iconHeight = 48,
      iconAnchorX = 16,
      iconAnchorY = 44
    )
    
    leafletProxy("map") %>%
      clearGroup("click_marker") %>%
      # Add marker
      addMarkers(
        lng = loc$click$lng,
        lat = loc$click$lat,
        icon = click_icon,
        group = "click_marker"
      )

  }, ignoreInit = TRUE)

  # Deal with map clicks
  
  # Store map clicks manually
  observeEvent(input$map_click, {
    clicked_loc(input$map_click)
  })
  
  # Clicked value
  click_val <-  reactive(clicked_loc())

  # Get location data when a location is clicked
  location_data <- reactive({
    
    click <- click_val()
    req(click)
    
    # XY coordinates
    xy <- data.frame(x = click$lng, y = click$lat)
    
    list(click = click, xy = xy
    )
    
  })
  
  #  Button to download plot appears if clicked
  output$has_click <- renderText({
    if (!is.null(clicked_loc())) "TRUE" else "FALSE"
  })
  
  outputOptions(output, "has_click", suspendWhenHidden = FALSE)
  
  #### * Summary statistics ####
  output$location_summary <- renderUI({
    
    req(location_data())
    
    loc <- location_data()
    click <- loc$click
    xy <- loc$xy
    
    # Variable text
    #variable_text <- names(input$trend_metric)
    variable_text <- NULL
    
    if (input$pest == "All 18 spp") {
      variable_text <- assign_comparison(input$comparison_metric)
    } else if (input$var_type == "clm") {
      variable_text <- "All stress exclusion"
    } else if (input$var_type == "climate") {
      variable_text <- input$clim_variable
    } else {
      variable_text <- input$phenology
    }
    
    # Raster value
    value_ui <- NULL
    
    if (isTRUE(input$pest == "All 18 spp")) {
      
      rast <- pest_raster_sum()
      req(rast)
      
      val <- terra::extract(rast, xy)[1,2]
      
      value_ui <- tags$div(
        tags$b("Num. species with significant trend: "),
        round(val, 3)
      )
      
    } else if (isTRUE(input$var_type == "clm")) {
      
      rast <- pest_raster_clm()
      req(rast)
      
      val <- terra::extract(rast, xy)[1,2]
      
      value_ui <- tags$div(
        tags$b("Beta coefficient: "),
        round(val, 3)
      )
      
    } else {

      # Extract sen slope and tau
      sens <- terra::extract(pest_raster_sen(), xy)[1,2]
      tau <- terra::extract(pest_raster_tau(), xy)[1,2]
      
      # Label for value
      value_label <- if (isTRUE(input$var_type == "phenology")) {
           "Change (days/year)"
         } else {
           "Change (units/year)"
         }
      
      # UI 
      value_ui <- tagList(
        
        tags$div(
          tags$b(value_label),
          ": ",
          round(sens, 3)
        ),
        
        tags$div(
          tags$b("Kendall's tau: "),
          round(tau, 3)
        )
        
      )
      
    }
    
    # P-value
    pval_ui <- NULL
    
    if (input$pest != "All 18 spp") {
      
      pval_rast <- pest_raster_pval()
      req(pval_rast)
      
      # Extract p-value and validate
      pval <- terra::extract(pval_rast, xy)[1, 2]
      validate(need(length(pval) > 0, ""))
      req(!is.null(pval))
      
      # Handle NA values
      if (isTRUE(is.na(pval))) {
        
        pval_ui <- tags$div(
          tags$b("P-value: "),
          "NA"
        )
        
      } else if (isTRUE(pval < 0.1)) {
        
        pval_ui <- tags$div(
          tags$b("P-value: "),
          round(pval, 3),
          tags$span(
            " (Significant)",
            style = "color: green;"
          )
        )
        
      } else {
        
        pval_ui <- tags$div(
          tags$b("P-value: "),
          round(pval, 3),
          tags$span(
            " (Not significant)",
            style = "color: red;"
          )
        )
        
      }
      
    }
    
    tagList(
      
      # Add to UI
      tags$div(
        tags$b("Year range: "),
        input$year_range
      ),
      
      tags$div(
        tags$b("Coordinates: "),
        round(click$lat, 4),
        ", ",
        round(click$lng, 4)
      ),
      
      tags$div(
        tags$b("Pest: "),
        input$pest
      ),
      
      tags$div(
        tags$b("Variable: "),
        variable_text
      ),
      
      value_ui,
      
      pval_ui
      
    )
    
  })
  
  # Comparison slope statistics
  # Slope median across species
  output$clicked_slopemed <- renderUI({
    
    req(location_data())
    
    if (!isTRUE(input$pest == "All 18 spp")) {
      return(NULL)
    }
    
    # Location coords
    loc <- location_data()
    xy <- loc$xy
    
    # Return NULL if location outside of US states
    if (!inside_us_states(xy)) {
      return(NULL)
    }
    
    # Slope median raster and extract value
    rast <- pest_raster_slopemed()
    
    req(rast)
    
    val <- terra::extract(rast,xy)[1, 2]
    
    validate(
      need(length(val) > 0, "")
    )
    
    req(!is.null(val))
    
    # Add to UI
    tags$div(
      tags$b("Median slope across species: "),
      round(val, 3)
    )
    
  })
  
  output$comparison_summary <- renderUI({
    
    req(location_data())
    
    if (!isTRUE(input$pest == "All 18 spp")) {
      return(NULL)
    }
    
    # Location info
    loc <- location_data()
    click <- loc$click
    xy <- loc$xy
    
    # Variable text
    variable_text <- assign_comparison(
      input$comparison_metric
    )
    
    # Sum raster
    sum_rast <- pest_raster_sum()
    
    req(sum_rast)
    
    sum_val <- terra::extract(
      sum_rast,
      xy
    )[1, 2]
    
    validate(
      need(length(sum_val) > 0, "")
    )
    
    req(!is.null(sum_val))
    
    # Median slope
    med_rast <- pest_raster_slopemed()
    
    req(med_rast)
    
    med_val <- terra::extract(
      med_rast,
      xy
    )[1, 2]
    
    validate(
      need(length(med_val) > 0, "")
    )
    
    req(!is.null(med_val))
    
    # Slope range
    min_rast <- pest_raster_slopemin()
    max_rast <- pest_raster_slopemax()
    
    req(min_rast, max_rast)
    
    min_val <- terra::extract(
      min_rast,
      xy
    )[1, 2]
    
    max_val <- terra::extract(
      max_rast,
      xy
    )[1, 2]
    
    validate(
      need(length(min_val) > 0, ""),
      need(length(max_val) > 0, "")
    )
    
    req(!is.null(min_val))
    req(!is.null(max_val))
    
    # Add to UI
    tagList(
      
      tags$div(
        tags$b("Year range: "),
        input$year_range
      ),
      
      tags$div(
        tags$b("Coordinates: "),
        round(click$lat, 4),
        ", ",
        round(click$lng, 4)
      ),
      
      tags$div(
        tags$b("Variable: "),
        variable_text
      ),
      
      tags$div(
        tags$b("Num. species with significant trend: "),
        round(sum_val, 2)
      ),
      
      tags$div(
        tags$b("Median slope: "),
        round(med_val, 2)
      ),
      
      tags$div(
        tags$b("Slope range: "),
        round(min_val, 2),
        " to ",
        round(max_val, 2)
      )
      
    )
    
  })
  
  #### * Individual species plot ####
  
  # 1. INDIVIDUAL SPECIES PLOT DATA GENERATOR
  loc_plot_obj_indiv <- reactive({
    
    #input$var_type
    
    req(input$pest)
    
    # 1. Clear guards that do not require any input values to evaluate
    if (input$pest == "All 18 spp") { 
      return(NULL) 
    }
  
    # Active dependencies
    # Plot updates when the user clicks the map or changes
    # the selected layer/year range    loc <- req(location_data())
    loc <- req(location_data())
    selected_var <- req(selected_variable())
    
    # Location does not need to trigger anything beyond a map click
    xy <- isolate(loc$xy)
    
    # These should update the plot when changed
    pest <- isolate(input$pest)
    input_var_type <- input$var_type
    input_clim_var <- input$clim_variable
    year_range <- input$year_range
    
    # Is it a PEM or 18 spp comparison?
    is_pem             <- grepl("First", selected_var)
    is_comparison      <- (pest == "All 18 spp")
    
    # Return no plot if species comparison
    if (is_comparison) { 
      return(NULL) 
    }
    
    # For checking on Console
    message("Rendering plot...")
    #message("loc_plot_obj_indiv()")
    
    # Convert years from character to index (to pull in files)
    range_vals <- strsplit(year_range, "-")[[1]]
    yrs <- as.numeric(range_vals[1]):as.numeric(range_vals[2])
    
    # Species abbreviation for plot title
    abbrev <- species_abbrev[[pest]]
    
    # Y-axis labels
    ylab_text <- if (input_var_type == "clm") {
      "Climate Stress Exclusion"
    } else if (is_pem) {
      "Date"
    } else {
      if (grepl("Cold", input_clim_var, ignore.case = TRUE)) {
        "Accumulated cold stress units"
      } else {
        "Accumulated heat stress units"
      }
    } 
    
    # File lookup
    files <- raster_lookup %>%
      dplyr::filter(
        model_type == "DDRP",
        common_name == pest,
        variable == selected_var,
        year %in% yrs
      ) %>%
      dplyr::arrange(year)
    
    if (nrow(files) == 0) return(NULL)
    
    # Load rasters
    rasts <- lapply(files$file_path, rast_import)
    rasts <- isolate(terra::rast(rasts))
    names(rasts) <- files$year
    
    # Spatial point
    site <- terra::vect(
      data.frame(x = xy$x, y = xy$y),
      geom = c("x", "y"),
      crs = "EPSG:4326"
    )
    
    # Needs to be in same projection
    site <- terra::project(site, rasts)
    
    # Extract data
    site_data <- terra::extract(rasts, site) %>%
      dplyr::select(-ID) %>%
      tidyr::pivot_longer(
        cols = everything(),
        names_to = "year",
        values_to = "value") %>%
      dplyr::mutate(
        year = as.numeric(year),
        value = as.numeric(value))
    
    # Check that click occurs in the US states or has missing PEM values
    check_NA(xy, site_data, FALSE)
    
    # Axis setup
    x_brks <- if (length(yrs) == 20) 2 else 5
    yr_first <- if (min(yrs) == 1981) 1980 else min(yrs)
    yr_last  <- if (max(yrs) >= 2024) 2025 else max(yrs)
    breaks_func <- scales::breaks_pretty(n = 6)
    y_brks <- breaks_func(site_data$value)
    ymax_pt <- max(site_data$value, na.rm = TRUE)
    ymax_df <- dplyr::slice(dplyr::filter(site_data, value == ymax_pt), 1) %>%
      dplyr::mutate(year = max(site_data$year), value = NA)
    
    # PEM date conversion
    if (is_pem) {
      
      doys <- c(
        min(terra::values(rasts), na.rm = TRUE),
        max(terra::values(rasts), na.rm = TRUE)
      )
      
      range_date <- as.Date(doys - 1, origin = "2025-01-01")
      all_dates <- format(seq(range_date[1], range_date[2], by = 1), "%b-%d")
      dates_df <- data.frame(
        value = seq(doys[1], doys[2], by = 1),
        dates = all_dates
      )
      
      site_data <- dplyr::left_join(site_data, dates_df, by = "value")
      
    }
    
    if (input_var_type == "clm") {
      
      # Reverse order of numbers so shows up with "none" at bottom
      site_data$value <- abs(site_data$value)
      
      # Plot
      p <- ggplot(site_data, aes(x = year, y = value)) +
        geom_point() +
        geom_line(color = "steelblue") +
        scale_x_continuous(
          limits = c(yr_first, yr_last),
          breaks = seq(yr_first, yr_last, x_brks)) +
        #scale_y_continuous(breaks = y_brks) +
        labs(title = paste("Predicted climate stress exclusion for", abbrev),
             x = "Year",
             y = str_to_sentence(ylab_text)) +
        scale_y_continuous(
          breaks = c(0, 1, 2),
          labels = c("None", "Moderate", "Severe" )
        ) +
        theme_bw() +
        custom_theme_indiv +
        theme(legend.position = "none")
      
    } else {
      
      # Define y-scale and titles based on PEM or not
      
      # y-scale 
      y_scale <- if (is_pem) {
        
        valid_idx <- match(y_brks, dates_df$value)
        scale_y_continuous(
          breaks = y_brks[!is.na(valid_idx)],
          labels = dates_df$dates[valid_idx[!is.na(valid_idx)]]
        )
      } else {
        scale_y_continuous(
          breaks = y_brks
        )
      }
      
      # Title
      plot_title <- if (is_pem) {
        paste("Predicted", tolower(gsub("_", " ", selected_var)), "for", abbrev)
      } else {
        paste("Predicted", tolower(ylab_text), "for", abbrev)
      }
      
      # y label
      ylab <- if (is_pem) {
        "Date"
      } else {
        str_to_sentence(ylab_text)
      }
      
      # Plot when there's no variation
      if (all(site_data$value == 0 | is.na(site_data$value))) {
        
        p <- ggplot(site_data, aes(x = year, y = value)) +
          geom_point() +
          geom_line(color = "steelblue") +
          scale_x_continuous(
            limits = c(yr_first, yr_last),
            breaks = seq(yr_first, yr_last, x_brks)) +
          y_scale +
          labs(title = plot_title,
               x = "Year",
               y = ylab) +
          geom_text_repel(
            data = ymax_df,
            aes(x = max(site_data$year) + 1,
                y = ymax_pt + 1.5,
                label = "No trend"), size = 4.5) +
          theme_bw() +
          custom_theme_indiv +
          theme(legend.position = "none")
        
        # Plot if there is variation
      } else {
        
        # Use same slope and p-value as raster
        slope <- round(terra::extract(pest_raster_sen(), xy)[1,2], 3)
        pval <- round(terra::extract(pest_raster_pval(), xy)[1, 2], 3)
        median_x <- median(site_data$year, na.rm = TRUE)
        median_y <- median(site_data$value, na.rm = TRUE)
        intercept <- median_y - slope * median_x
        
        # Plot
        p <- ggplot(site_data, aes(x = year, y = value)) +
          geom_point() +
          geom_line(color = "steelblue") +
          geom_abline(intercept = intercept,
                      slope = slope,
                      color = "red") +
          scale_x_continuous(
            limits = c(yr_first, yr_last),
            breaks = seq(yr_first, yr_last, x_brks)) +
          y_scale +
          labs(title = plot_title,
               x = "Year",
               y = ylab) +
          geom_text_repel(data = ymax_df, 
                          aes(x = max(site_data$year) + 1, 
                              y = ymax_pt + 1.5,
                              label = paste0("Slope: ", slope, ", P-value: ", pval)),
                          size = 4.5) +
          theme_bw() +
          custom_theme_indiv
      }
      
      return(p)
      
    }
  })
  
  # Render individual plot
  output$loc_plot_indiv <- renderPlot({
    # Ensure input$pest isn't switching over to comparison mode
    #message("rendPlot()")
    req(input$pest != "All 18 spp")
    p <- loc_plot_obj_indiv()
    req(p)
    p
  })
  
  # Individual plot download handler
  output$download_plot_indiv <- downloadHandler(
    
    # Image file name
    filename = function() {
      
      # Species abbreviation
      abbrev <- species_abbrev[[input$pest]]
      if (is.null(abbrev)) {
        abbrev <- gsub(" ", "_", input$pest)
      } 
      
      # Get the selected variable/event
      variable_name <- switch(
        input$var_type,
        phenology = input$phenology,
        climate = input$clim_variable,
        clm = "Climate_Stress_Excl"
      )
      
      # Clean variable name for filename
      variable_name <- gsub("[^A-Za-z0-9]+", "_", variable_name)
      
      # File name
      paste0("Trend_Plot_", abbrev, "_", variable_name, 
             "_Change_", input$year_range, ".png")
    },
    content = function(file) {
      p <- isolate(loc_plot_obj_indiv())
      req(p) 
      ggsave(file, plot = p, width = 9, height = 6, dpi = 300)
    }
  )
  
  #### * Comparison plot ####
  
  # 2. SPECIES COMPARISON PLOT DATA GENERATOR
  loc_plot_obj_comp <- reactive({
    
    input$var_type
    
    req(input$pest, input$comparison_metric)
    
    # Only run for comparisons
    if (input$pest != "All 18 spp") {
      return(NULL)
    }
    
    # Wait until comparison metric stabilizes
    req(
      input$comparison_metric %in% c(
        "species_num_adult",
        "species_num_egg",
        "species_num_cold",
        "species_num_heat"
      )
    )
    
    # Require location
    loc <- req(location_data())
    
    # Require map click
    click <- click_val()
    
    # Coordinates for location
    xy <- loc$xy
    
    # Spatial point
    site <- terra::vect(
      data.frame(x = xy$x, y = xy$y),
      geom = c("x", "y"),
      crs = "EPSG:4326"
    ) 
    
    # Needs to be in same projection
    site <- terra::project(site, pest_raster_slopemed())
    
    req(click_val(), cancelOutput = TRUE)
    
    # For checking on Console
    message("Rendering comparison plot...")
    
    # Isolate rasters to prevent double-rendering
    sum_rast <- isolate(pest_raster_sum())
    slopemed_rast <- isolate(pest_raster_slopemed())
    slopese_rast  <- isolate(pest_raster_slopese())
    slopemin_rast <- isolate(pest_raster_slopemin())
    slopemax_rast <- isolate(pest_raster_slopemax())
    
    # Extract values
    sum_val <- round(terra::extract(sum_rast, site)[1,2], 2)
    slopemed_val <- round(terra::extract(slopemed_rast, site)[1,2], 2)
    slopese_val  <- round(terra::extract(slopese_rast, site)[1,2], 2)
    slopemin_val <- round(terra::extract(slopemin_rast, site)[1,2], 2)
    slopemax_val <- round(terra::extract(slopemax_rast, site)[1,2], 2)
    
    # Check that click occurs in the US states or has missing values
    # Areas w/ no sig trends across spp are ignored (sum = 0)
    site_data <- data.frame("value" = sum_val)
    check_NA(xy, site_data, TRUE)
    
    #variable_text <- assign_comparison(input_trend_metric)
    variable_text <- assign_comparison(
      input$comparison_metric
    )
    
    if (grepl("cold|heat", variable_text, ignore.case = TRUE)) {
      ylab <- "Change (units/year)"
      plot_title <- if (grepl("cold", variable_text, ignore.case = TRUE)) {
        "Change (units/year) in cold stress across 18 spp."
      } else {
        "Change (units/year) in heat stress across 18 spp."
      }
    } else {
      ylab <- "Change (days/year)"
      plot_title <- if (grepl("adult", variable_text, ignore.case = TRUE)) {
        "Change in adult emergence date across 18 spp."
      } else {
        "Change in egg hatch date across 18 spp."
      }
    }
    
    df <- data.frame(
      group = "Selected location",
      med = slopemed_val,
      se = slopese_val,
      min_val = slopemin_val,
      max_val = slopemax_val
    )
    
    # Final plot
    p <- ggplot(df, aes(x = group, y = med)) +
      geom_errorbar(aes(ymin = min_val, ymax = max_val), 
                    width = 0.1, color = "grey") +
      geom_crossbar(aes(ymin = med - se, ymax = med + se), 
                    width = 0.2, fill = "skyblue") +
      geom_point(size = 3) +
      theme_bw() +
      labs(title = plot_title, y = ylab, x = "") +
      custom_theme_comp 
    
    return(p)
  })
  
  # Render comparison plot
  output$loc_plot_comp <- renderPlot({
    p <- loc_plot_obj_comp()
    req(p)
    p
  })
  
  # Comparison plot download handler
  output$download_plot_comp <- downloadHandler(
    filename = function() {
      variable_text <- assign_comparison(input$comparison_metric)
      paste0("Plot_", tolower(gsub(" ", "_", variable_text)), 
             "_18spp_", input$year_range, ".png")
    },
    content = function(file) {
      p <- isolate(loc_plot_obj_comp())
      req(p) 
      ggsave(file, plot = p, width = 8, height = 6, dpi = 300)
    }
  )
  ### ---------------------------------------------------------------------- ###
  
  
} # END OF SERVER