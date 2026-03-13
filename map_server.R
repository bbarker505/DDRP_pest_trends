#### * About ####

# Stores "server" information for maps.qmd page.


map_server <- function(input, output, session) {

### ------------------------------------------------------------------------ ###

#### * Check which variable is selected ####
selected_variable <- reactive({
  
  # Input a pest
  req(input$pest)
  
  # If climate is selected, return climate
  if (input$var_type == "climate") return(input$clim_variable)
  
  # If phenology is selected, return phenology
  if (input$var_type == "phenology") return(input$phenology)
  NULL
  
})


### ------------------------------------------------------------------------ ###

#### * Get row with raster of interest ####
selected_row <- reactive({
  
  req(input$pest, selected_variable(), input$year_range)
  
  # Get row with information
  row <- raster_lookup %>%
    dplyr::filter(
      common_name == input$pest,
      variable == selected_variable(),
      year == input$year_range
    )
  
  # Make sure there's a row
  validate(need(nrow(row) == 1, "No raster found"))
  
  # Return the row
  row
  
})


### ------------------------------------------------------------------------ ###

#### * Collect raster info ####

# Tau
pest_raster_tau <- reactive({
  rast_import(selected_row()$file_path, 1)
})

# Sen
pest_raster_sen <- reactive({
  rast_import(selected_row()$file_path, 2)
})

# P-value
pest_raster_pval <- reactive({
  rast_import(selected_row()$file_path, 3)
})


### ------------------------------------------------------------------------ ###

#### * Reactive for metric ####
selected_trend <- reactive({
  
  req(input$trend_metric)
  
  # If they select Sen (default)
  if (input$trend_metric == "sens") {
    
    list(
      rast = pest_raster_sen(),
      title = "Change in days per year"
    )
    
  # Else is if they select tau
  } else {
    
    list(
      rast = pest_raster_tau(),
      title = "Direction of trend"
    )
    
  }
  
})


### ------------------------------------------------------------------------ ###

#### * Initial map plotted ####
output$map <- renderLeaflet({
  
  trend <- selected_trend()
  
  # Plot map
  produce_map(
    rast = trend$rast,
    bounds = bounds,
    metric = input$trend_metric,
    legend_title = trend$title
  )
  
})


### ------------------------------------------------------------------------ ###

#### * Reactive palette ####
palette_reactive <- reactive({
  make_palette(selected_trend()$rast, input$trend_metric)
})


### ------------------------------------------------------------------------ ###

#### * Update map when pest changes ####
observeEvent(list(selected_row(), input$trend_metric), {
                    
                    trend <- selected_trend()
                    
                    # Build palette + limits
                    pal_obj <- palette_reactive()
                    pal <- pal_obj$pal
                    limits <- pal_obj$limits
                    
                    # Build horizontal legend
                    legend_html <- paste0(
                      "<div style='background:white;padding:8px 10px;border-radius:6px;'>",
                      
                      "<div style='text-align:center;font-weight:bold;margin-bottom:4px;'>",
                      trend$title,
                      "</div>",
                      
                      "<div style='display:flex;flex-direction:column;align-items:center;'>",
                      
                      "<div style='width:160px;height:14px;border:1px solid #ccc;",
                      "background:linear-gradient(to right,",
                      paste(pal(seq(limits[1], limits[2], length.out = 50)), 
                            collapse = ","),
                      ");'></div>",
                      
                      "<div style='display:flex;justify-content:space-between;",
                      "width:160px;font-size:11px;margin-top:2px;'>",
                      "<span>", round(limits[1],2), "</span>",
                      "<span>0</span>",
                      "<span>", round(limits[2],2), "</span>",
                      "</div>",
                      
                      "</div></div>"
                    )
                    
                    # Plot updated map
                    leafletProxy("map") %>%
                      clearImages() %>%
                      clearControls() %>%
                      clearGroup("click_marker") %>%
                      addRasterImage(
                        trend$rast,
                        colors  = pal,
                        opacity = 0.65,
                        layerId = "Value",
                        project = FALSE
                      ) %>%
                      addControl(
                        html = HTML(legend_html),
                        position = "bottomright"
                      )
                  }, 
             ignoreInit = TRUE)


### ------------------------------------------------------------------------ ###

#### * Settings on map bounds (prevent over-zooming) ####

# Observe bounds of current map in order to
# keep the bounds from resetting when map selected changes

observeEvent(input$map_bounds, {
  
  # Map zoom can't be entire area (level 6) or get weird behavior
  # (non-stop loop of zooming) when select risk maps multiple times
  bounds <- input$map_bounds
  mapzoom <- input$map_zoom
  
  # Keep bounds from resetting
  if (mapzoom > 6) {
    
    # Update map
    leafletProxy("map") %>%
      fitBounds(bounds$west, bounds$south, bounds$east, bounds$north) %>%
      clearGroup("click_marker")
    
    
  }
})


### ------------------------------------------------------------------------ ###

#### * Adjust to another region when selected ####
observeEvent(input$region, {
  
  req(input$region)
  
  # Get extent from your helper
  ext <- assign_extent(input$region)
  
  # Fix bounds
  bounds <- ext_to_bounds(ext)
  
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


### ------------------------------------------------------------------------ ###

#### * Panel that holds location click outputs ####
observeEvent(input$map_click, {
  
  trend <- selected_trend()
  
  req(input$map_click, trend$rast, pest_raster_pval())
  
  # Store click info
  click <- input$map_click
  
  # Add marker where user clicked
  leafletProxy("map") %>%
    clearGroup("click_marker") %>%   # removes old marker
    addMarkers(
      lng = click$lng,
      lat = click$lat,
      group = "click_marker"
    )
  
  
  # Store coordinates
  xy <- data.frame(x = click$lng, y = click$lat)
  
  # Extract selected metric value
  value <- terra::extract(trend$rast, xy)[1,2]
  
  # Extract p-value
  pval_val <- terra::extract(pest_raster_pval(), xy)[1,2]
  
  # Year range (MK_trends)
  output$clicked_years <- renderUI({
    tags$div(tags$b("Prediction compiled for the years:"), input$year_range)
  })
  
  # Coordinates
  output$clicked_latlon <- renderUI({
    tags$div(tags$b("Location at coordinates:"), 
             round(click$lat, 4), ", ", round(click$lng, 4))
  })
  
  # Pest
  output$clicked_pest <- renderUI({
    tags$div(tags$b("Pest selected:"), input$pest)
  })
  
  # Variable
  output$clicked_variable <- renderUI({
    var <- selected_variable()
    display_name <- variable_labels[var] %||% var %||% "Not available"
    tags$div(tags$b("Variable of interest:"), display_name)
  })
  
  # Selected metric value
  output$clicked_value <- renderUI({
    
    info_text <- if (input$trend_metric == "tau") {
      "Kendall’s τ indicates the direction and consistency of a trend over
        time. Positive values suggest the variable is generally increasing / 
        occurring progressively later over time, while negative values suggest 
        decreasing / earlier timing."
    } else {
      "Sen’s slope estimates the annual rate of change in timing. Positive 
        values suggest increasing x units per year; negative values suggest a
        decrease of x units per year."
    }
    
    tags$div(
      tags$b(paste0(trend$title, ": ")),
      round(value, 3), " ",
      tags$span(
        tags$i(class = "bi bi-info-circle"),
        style = "cursor:pointer;",
        `data-bs-toggle` = "popover",
        `data-bs-trigger` = "click",
        `data-bs-placement` = "right",
        `data-bs-html` = "true",
        title = "About the statistic",
        `data-bs-content` = info_text
      )
    )
  })
  
  # P-value
  output$clicked_pval <- renderUI({
    tags$div(
      tags$b("P-value:"), signif(pval_val, 3),
      tags$span(
        tags$i(class = "bi bi-info-circle"),
        style = "cursor:pointer;",
        `data-bs-toggle` = "popover",
        `data-bs-trigger` = "click",
        `data-bs-placement` = "right",
        `data-bs-html` = "true",
        title = "About the p-value",
        `data-bs-content` = HTML(
          "The p-value describes the strength of evidence for a trend.
          Values less than 0.05 are typically considered statistically 
            significant."
        )
      )
    )
  })
  
})


### ------------------------------------------------------------------------ ###

#### * Clear absolutePanel() when pest / variable changes ####
observeEvent(list(input$var_type, input$clim_variable, input$phenology), {
  
  output$clicked_years    <- renderUI(NULL)
  output$clicked_latlon   <- renderUI(NULL)
  output$clicked_pest     <- renderUI(NULL)
  output$clicked_variable <- renderUI(NULL)
  output$clicked_value    <- renderUI(NULL)
  output$clicked_pval     <- renderUI(NULL)
  
})


### ------------------------------------------------------------------------ ###

}