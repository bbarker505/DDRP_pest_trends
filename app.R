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
    card(
      
      full_screen = FALSE,
      class = "p-4 my-3",
      card_header("Overview"),
      
      # Text
      p(
        "The boxwood blight infection risk mapping tool produces forecasts ",
        "based on gridded daily climate data from the ",
        a("PRISM", href="https://www.prism.oregonstate.edu",
          target="_blank", style="text-decoration:underline;"),
        " database at 800 m ",
        tags$sup("2"),
        " resolution and from the ",
        a("NDFD",
          href="https://vlab.noaa.gov/web/mdl/ndfd",
          target="_blank", style="text-decoration:underline;"),
        " database (downscaled...)"
      )
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
        
        h3(HTML("<b>Title</b>")),
        
        p("Perhaps short instructions"),
        
        # Divider line
        hr(),
        
        # Buttons for variable
        radioButtons(
          "variable",
          label = tags$span(h4(HTML("<b>Select a variable</b>"))),
          choices = variable,
          selected = variable[1]
        ),
        
        selectInput(
          "pest",
          label = tags$span(h4(HTML("<b>Select insect</b>"))),
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
          label = tags$span(h4(HTML("<b>Select range</b>"))),
          choices = years,
          selected = years[3]
        )
      ),
      
      # ------ Visuals (Right side) -------------------------------------------
      
      accordion(
        open = "Visual",
        
        accordion_panel(
          HTML("<b>Visual</b>"),
          icon = icon("map-location-dot"),
          tags$style("#map {height: calc(100vh - 80px) !important;}"),
          leafletOutput("map") %>% withSpinner(color="cornflowerblue")
        ),
        
        accordion_panel(
          HTML("<b>Summary Statistics</b>"),
          icon = icon("chart-column"),
          p("Summary statistics will appear here.")
        )
      )
    )
  ),
  
  ##### * Tab 3 #####
  
  nav_panel(
    
    title = "Pest Information",
    
    card(
      class = "p-3 my-3",
      card_header("Asian longhorned beetle (ALB)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Asiatic rice borer (ARB)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Common / Cotton cutworm (SLI)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Egyptian cottonworm (ECW)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Emerald Ash borer (EAB)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("False codling moth (FCM)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Honeydew moth (CGN)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Japanese beetle (JPB)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Japanese pinesawyer beetle (JPSB)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Light brown apple moth (LBAM)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Oak ambrosia beetle (OAB)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Old world bollworm (OWBW)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Pine-tree lappet moth (PTLM)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Silver Y moth (SLYM)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Small tomato borer (STB)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Spotted lanternfly (SLF)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Sunn pest (SUNP)"),
      p("words")
    ),
    
    card(
      class = "p-3 my-3",
      card_header("Tomato leaf miner (TABS)"),
      p("words")
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
    RastImport(full_path)
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
  
} # END OF SERVER




# ---------- RUN APP -----------------------------------------------------------

shinyApp(ui = ui, server = server)
