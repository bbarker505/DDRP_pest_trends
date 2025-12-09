# ---------- NOTES -------------------------------------------------------------

# Edits:

# Created a separate .R file for functions -- see functions.R

# In progress:

# Checking is removing map improves raster speed

# To do:

# See checklist but also there's some notes in the original code
# E.g. move legend outside of map






# ---------- DDRP PEST TRENDS SHINY APP ----------------------------------------

# Purpose: 

# This app presents results from a proven modeling system to assess the  
  # potential impacts of recent weather trends (1980−2024) on the timing of  
  # pest activities such as emergence, number of generations, and establishment 
  # for 18 major invasive species for the contiguous United States. 






# ---------- PREAMBLE THINGS ---------------------------------------------------

# Packages
source("packages.R")

# Import custom functions
source("functions.R")

# Set-up
source("setup.R")





# ---------- DEFINE USER INTERFACE (UI) ----------------------------------------

ui <- page_navbar(
  
  # Title
  title = HTML("<b>DDRP Pest Trends in the United States</b>"),
  
  # Theme
  theme = bs_theme(
    bootswatch = "sandstone",
    bg = "#FAFCFF",
    fg = "#434C5E",
    base_font = font_google("Golos Text"),
    heading_font = font_google("Crimson Text")
  ),
  
  # Custom CSS
  tags$head(
    includeCSS("styles.css")
  ),
  
  # Footer
  footer = tags$footer(
    
    style = "
      background-color:#FAFCFF; 
      padding:15px; 
      text-align:center; 
      border-top: 1px solid #ddd;",
    
    # OSU IPM logo
    div(style="display:inline-block; margin: 0 15px;",
        tags$img(src="OIPMC.png", height="50px")),
    
    # Oregon Dept. of Ag. logo
    div(style="display:inline-block; margin: 0 15px;",
        tags$img(src="Oregon-Department-of-Agriculture-logo.png", height="50px")),
    
    # PRISM logo
    div(style="display:inline-block; margin: 0 15px;",
        tags$img(src="PRISM.png", height="50px")),
    
    # USDA logo
    div(style="display:inline-block; margin: 0 15px;",
        tags$img(src="usda-logo_original.png", height="50px"))
  ),
  
  ##### * Tab 1 #####
  
  nav_panel(
    
    title = "About this site",
    
    # Overview
    div(
      class = "p-4 my-3",
      h3(HTML("<b>Overview</b>")),
      
      # Text
      p("We use the Degree-Day, establishment Risk, and Phenological event 
      mapping system (known as DDRP) to assess the potential impacts of weather 
      between 1980 and 2024 on the timing of pest activity such as emergence 
      (phenology) and potential for establishment of 18 invasive pest species in 
      the contiguous United States (Table 1). The system is part of a suite of 
      decision-support tools at ",
        a("USPest.org", href = "https://uspest.org/wea/",
          target="_blank", style="text-decoration:underline;"),
        " that are developed and maintained by the Oregon Integrated Pest 
        Management Center at Oregon State University. These tools provide 
        thousands of end users nationwide with information to support timely 
        and effective management activities for agricultural pests and diseases. 
        This project will use the Degree-Day, establishment Risk, and 
        Phenological event mapping system to predict where pests exhibit earlier 
        activities, increases in the number of generations, and increases in 
        habitat suitability. This information helps Plant Protection and 
        Quarantine allocate survey resources more strategically, thereby 
        reducing the likelihood of pest establishment and spread."
      ),
      
      # Another paragraph
      p("Of the 18 species with models, 12 are presently on Plant Protection and 
      Quarantine’s National Priority Pest List, six were formerly included on 
      the List, and two are Federal Program Pests. Most of the species do not 
      occur in the contiguous United States (N = 13); however, five are 
      established and may spread to additional regions. Real-time forecasts for 
      these pests are available at ",
        a("USPest.org", href = "https://uspest.org/CAPS",
          target="_blank", style="text-decoration:underline;"),
          ".")
    ),
    
    # About
    card(
      
      full_screen = FALSE,
      class = "p-4 my-3",
      card_header("About"),
      
      # Text
      p(strong("Introduction: "),
        "Boxwood blight caused by the fungus ",
        em("Calonectria pseudonaviculata"),
        " can result in defoliation, decline, and death..."
      ),
      
      p("Generally, it should be very humid or raining..."),
      
      p(strong("Tool description: "), 
        "The risk mapping tool is similar to the ",
        a("boxwood blight model app", href="...", target="_blank"),
        " available at USPest.org..."
      ),
      
      p(strong("Suggested citation: "),
        "Barker & Coop (2023) ..."
      ),
      
      p(strong("Source code and feedback: "),
        "To view the source code, visit the GitHub repo. ",
        a("brittany.barker@oregonstate.edu",
          href="mailto:brittany.barker@oregonstate.edu")
      ),
      
      p(strong("Disclaimer: "),
        "The risk index is intended to inform your decisions..."
      )
    )
  ),
  
  ##### * Tab 2 #####
  
  nav_panel(
    
    title = "DDRP Map",
    
    layout_sidebar(
      
      # ----- Controls (left side) --------------------------------------------
      
      sidebar = sidebar(
        
        h3(HTML("<b>DDRP Pest Map</b>")),
        
        p("Please select the desired variable, pest, and time frame of interest."),
        
        # Divider line
        hr(),
        
        # Buttons for variable
        radioButtons(
          "variable",
          label = tags$span(h4(HTML("<b>Select variable</b>"))),
          choices = c(
            "Cold Stress"                = "Cold_Stress",
            "Heat Stress"                = "Heat_Stress",
            "Earliest Date of (e = 0)"   = "Earliest_PEMe0",
            "Earliest Date of (e = 1)"   = "Earliest_PEMe1",
            "Earliest Date of (p = 0)"   = "Earliest_PEMp0"
          ),
          selected = "Cold_Stress"
        ),
        
        selectInput(
          "pest",
          label = tags$span(h4(HTML("<b>Select pest</b>"))),
          choices = c(
            "Asian longhorned beetle",
            "Asiatic rice borer",
            "Honeydew moth",
            "Emerald Ash borer",
            "Egyptian cottonworm",
            "False codling moth",
            "Japanese beetle",
            "Japanese pinesawyer beetle",
            "Light brown apple moth",
            "Oak ambrosia beetle",
            "Old world bollworm",
            "Pine-tree lappet moth",
            "Spotted lanternfly",
            "Common / Cotton cutworm",
            "Silver Y moth",
            "Small tomato borer",
            "Sunn pest",
            "Tomato leaf miner"
          ),
          selected = "Spotted lanternfly"
        ),
        
        selectInput(
          "year_range",
          label = tags$span(h4(HTML("<b>Select time range</b>"))),
          choices = c(
            "2001–2010" = "01-10",
            "2011–2020" = "11-20",
            "1981–2024" = "81-24",
            "1981–1990" = "81-90",
            "1991–2020" = "91-20"
          ),
          selected = "81-24"
        )
      ),
      
      # ------ Visuals (Right side) -------------------------------------------
      
      div(
        
        style = "height: 100%; position: relative;",
        
        # Ensure map fills the viewport minus header space
        tags$style("#map {height: calc(100vh - 80px) !important;}"),
        leafletOutput("map") %>% 
          withSpinner(color = 'cornflowerblue'),
        
        # Floating Info Panel (right)
        absolutePanel(
          id = "info_panel",
          top = 100, right = 20, width = 300,
          draggable = TRUE,
          style = "z-index:999;
          background:white;
          padding:15px;
          border-radius:10px;
          box-shadow:0 0 10px rgba(0,0,0,0.2);
        ",
          
          # Text
          h4(HTML("<b>Location statistics</b>")),
          tags$hr(),
          
          textOutput("clicked_latlon"),
          br(),
          textOutput("clicked_pest"),
          textOutput("clicked_variable"),
          textOutput("clicked_year"),
          br(),
          textOutput("clicked_value"),
          textOutput("clicked_pval")
        )
      ) # end main
    )
  ),
  
  ##### * Tab 3 #####
  
  nav_panel(
    
    title = "Pest Information",
    
    accordion(
      
      open = "Asian longhorned beetle",
      
      accordion_panel(
        HTML("<b>Asian longhorned beetle</b>"),
        p("words")
      ),
    
      accordion_panel(
      HTML("<b>Asiatic rice borer</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Common / Cotton cutworm</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Egyptian cottonworm</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Emerald Ash borer</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>False codling moth</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Honeydew moth</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Japanese beetle</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Japanese pinesawyer beetle</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Light brown apple moth</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Oak ambrosia beetle</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Old world bollworm</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Pine-tree lappet moth</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Silver Y moth</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Small tomato borer</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Spotted lanternfly</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Sunn pest</b>"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Tomato leaf miner</b>"),
      p("words")
    )
    )
  )
)






# ---------- DEFINE SERVER -----------------------------------------------------

server <- function(input, output, session) {
  
  # Collect raster of interest
  pest_raster <- reactive({
    
    # Require inputs
    req(input$pest, input$variable, input$year_range)
    
    # Look up the correct row in files table
    row <- raster_lookup %>%
      dplyr::filter(
        pest == input$pest,
        variable == input$variable,
        year_range == input$year_range
      )
    
    # Check
    validate(
      need(nrow(row) == 1,
           "No raster found.")
    )
    
    # Full file path
    full_path <- row$file_path
    
    # Check
    validate(
      need(file.exists(full_path),
           paste("Raster file not found:", full_path))
    )
    
    # Load raster
    rast_import_tau(full_path)
  })
  
  #### * INITIAL MAP ####
  
  output$map <- renderLeaflet({
    
    # Get raster
    r <- pest_raster()
    
    # Custom function that defines all map features
    produce_map(input, r, 
                north = north, south = south,
                east = east, west = west)
    
  })
  
  
  #### * UPDATE MAP WHEN PEST CHANGES ####
  
  observeEvent(input$pest, {
    
    req(pest_raster)  # Ensure raster exists
    
    # Render new map
    output$map <- renderLeaflet({
      
      # Get raster
      r <- pest_raster()
      
      # Custom function that defines all map features
      produce_map(input, r, 
                  north = north, south = south,
                  east = east, west = west)
    })
    
  })
    
    #### * BOUNDS OF MAP ####
    
    # Observe bounds of current map in order to
    # keep the bounds from resetting when map selected changes
    
    observeEvent(input$map_bounds, {
      
      # Map zoom can't be entire area (level 6) or get weird behavior
      # (non-stop loop of zooming) when select risk maps multiple times
      bounds <- input$map_bounds
      mapzoom <- input$map_zoom
      
      # Keep bounds from resetting
      if (mapzoom > 6) {
        
        leafletProxy("map") %>%
          fitBounds(bounds$west, bounds$south, bounds$east, bounds$north)
        
      }
    })
    
    #### * MAP WHEN LOCATION IS INPUT ####
    
    # Below updates maps each time a new address (location) is submitted
    
    observeEvent(input$address_submit, {
      
      # Search message
      # Does not appear if coordinates are valid because maps load so quickly 
      
      # Maybe fix this later
      
      # output$search_message <- renderText({
      #   "Zooming to location"
      # })
      # delay(2000, output$search_message <- renderText(""))
      
      # Submitted location
      location <- input$address
      
      # Geocode the location
      coords <- tribble(~addr, location) %>%
        geocode(addr, method = 'mapquest')
      
      # Address submit errors
      output$error_message <- renderText({
        
        # Error: empty location submission ("")
        if (coords$addr == "") {
          
          "Please enter a location."
          
          # Error: a location was entered but could not be geocoded
        } else if (is.na(coords$lat & coords$addr != "")) {
          
          "Sorry, this location could not be geocoded."
          
          # Error: a location was valid but falls outside of risk forecast bounds
        } else if (!is.na(coords$lat)) {
          
          # Determine whether there are predictions for the location
          xy <- data.frame(x = coords$long, y = coords$lat)
          rast_val <- terra::extract(pest_raster, xy)[1,2]
          
          # Error message if rast value is NA
          if (is.na(rast_val)) {
            
            "No risk forecast for this location."
            
          }
        }
        
      })
      
      # Make message disappear (requires "shinyjs")
      delay(4000, output$error_message <- renderText(""))
      
      # If input address doesn't return NULL coordinates
      # Add circle markers and zoom to location
      if (!is.na(coords$lat)) {
        
        if (coords$lat > south & coords$lat < north & 
            coords$long > west & coords$long < east) {
          
          output$search_message <- renderText({
            
            "Zooming to location"
            
          })
          
          delay(2000, output$search_message <- renderText(""))
          
          # Current map - can modify rendered map using "leafletProxy"
          
          leafletProxy("map") %>%
            removeMarker(layerId = "Value") %>% 
            #clearMarkers() %>% # Remove circle markers from last submission
            addRasterImage(raster(pest_raster), opacity = 0.65,
                           group = "Value", layerId = "Value") %>%
            addImageQuery(raster(pest_raster), project = TRUE, prefix = "", digits = 0,
                          layerId = "Value", position = "topleft", type = "mousemove") %>%
            addCircleMarkers(lat = coords$lat, lng = coords$long,
                             opacity = 0.75, color = "blue", 
                             weight = 3, layerId = "Value", fill = FALSE) %>%
            setView(lng = coords$long, lat = coords$lat, zoom = 11) # Zooms to area
          
        } 
      }
    })
    
    #### * MAPS WHEN NO LOCATION IS INPUT ####
    
    # Clears out any error messages and entries from previous submission,
    # and zooms back out to western OR and WA if box is unchecked
    
    observeEvent(input$address_checkbox, {
      
      # Clear out previous submission text
      
      if (input$address_checkbox == 0) {
        
        updateTextInput(session = session, inputId = "address", value = "")
        
      }
      
      if (input$address_checkbox == 0) {
        
        # Zoom back out and clear location markers
        
        leafletProxy("map") %>%
          removeMarker(layerId = "Value")  %>% 
          addImageQuery(raster(pest_raster), project = TRUE, prefix = "", digits = 0,
                        layerId = "Value", position = "topleft", type = "mousemove") 
      }
    })
  
  #### * RIGHT SIDE INFO PANEL OUTPUTS ####
  
  observeEvent(input$map_click, {
    
    click <- input$map_click
    req(click)
    
    xy <- data.frame(x = click$lng, y = click$lat)
    
    # Find the correct row based on user inputs
    row <- raster_lookup %>%
      filter(
        pest       == input$pest,
        variable   == input$variable,
        year_range == input$year_range
      )
    
    req(nrow(row) == 1)
    
    # Extract tau and p-value
    tau_val <- tryCatch(terra::extract(row$rast_tau[[1]], xy)[1,2], 
                        error = function(e) NA)
    pval_val <- tryCatch(terra::extract(row$rast_pval[[1]], xy)[1,2], 
                         error = function(e) NA)
    
    # Display tau
    output$clicked_value <- renderText({
      if (is.na(tau_val)) "Value: NA" else paste("Value:", round(tau_val, 3))
    })
    
    # Display p-value
    output$clicked_pval <- renderText({
      if (is.na(pval_val)) "P-value: NA" else paste("P-value:", signif(pval_val, 3))
    })
    
    # Display coordinates
    output$clicked_latlon <- renderText({
      paste0("Coordinates: ", round(click$lat, 4), ", ", round(click$lng, 4))
    })
    
    # Display selected inputs
    output$clicked_pest <- renderText({ paste("Pest:", input$pest) })
    output$clicked_variable <- renderText({ paste("Variable:", input$variable) })
    output$clicked_year <- renderText({ paste("Years:", input$year_range) })
    
  })
  
} # END OF SERVER




# ---------- RUN APP -----------------------------------------------------------

shinyApp(ui = ui, server = server)
