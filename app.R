# ---------- NOTES ----------

# Edits:

# Created a separate .R file for functions -- see functions.R

# In progress:

# Checking is removing map improves raster speed

# To do:

# See checklist but also there's some notes in the original code
# E.g. move legend outside of map






# ---------- DDRP PEST TRENDS SHINY APP ----------

# Purpose: 

# Insert code description




# Figure out what this line does
options(shiny.sanitize.errors = FALSE)






# ---------- LOAD PACKAGES ----------

# Packages
library(tidyverse)          # Data wrangling/manipulation
library(terra)              # Import model outputs / work with rasters
library(raster)             # TO DO: hopefully can remove this
library(sf)                 # Spatial features
library(mapview)            # Open access street maps
library(tigris)             # County and state boundaries
library(leafem)             # Query map values
library(leaflet)            # Interactive maps
library(leaflegend)         # Extra legend features
library(leaflet.extras) 
library(lubridate)          # Working with dates
library(tidygeocoder)       # Obtain coordinates from address
library(shiny)              # Web app 
library(shinyWidgets)
library(shinydashboard)
library(shinyBS)            # Info tabs next to risk map menu items
library(shinycssloaders)    # "Loading" animation for risk maps (waiting)
library(shinyjs)            # For "delay" function to causes error messages to disappear
library(bslib)
library(fresh)              # Color theme for web app page
library(htmlwidgets)

# Import custom functions
source("functions.R")






# ---------- SET-UP ----------

# Figure out what this does... allows access to map tiles?
Sys.setenv(MAPQUEST_API_KEY = "5vjLXIpEjMHpANFr4Ok2BNxpuQPrsGQP")



#### * DATES ####

# Used in map titles

# Current dates and year
current_date <- Sys.Date()
current_year <- as.numeric(format(current_date, format = "%Y"))



#### * SPATIAL FEATURES ####

# All have CRS = WGS 84

# State boundaries
state_sf <- st_read("./features/states_OR_WA.shp")

# County boundaries
county_sf <- st_read("./features/counties_OR_WA.shp")

# Get new boundaries




#### * IMPORT AND PROCESS MODEL OUTPUTS ####

# File names
fls <- c("SLF_MK_Cold_Stress_11-20.tif")

outdir <- paste0("./rasters/MK_trends/SLF")

# Import model outputs
rasts <- map(
  fls, function(file_name) {
    RastImport(paste0(outdir, "/", file_name))
  }
)



#### * CUSTOM MAP TITLE CSS SPECS ####

# Can probably also move these to another files 
# (styles.scss to define all visual preferences)

# border-radius makes rounded edges
tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
    width: 130px;
    padding-left: 3px; 
    padding-right: 3px; 
    padding-top: 2px; 
    padding-bottom: 2px;
    border-radius: 2px;
    background: rgba(255,255,255,.75);
    font-size: 16px;
    font-weight: bold;
    text-align: left;
    color: rgb(51, 51, 51);
  }
"))

# TO DO: Figure out way to control leaflet legend background opacity

# border-radius makes rounded edges
# tag.map.legend <- tags$style(HTML("
#   .leaflet-control.legend { 
#     background: rgba(255,255,255,.75);
#   }
# "))


# Color themes
mytheme <- create_theme(
  adminlte_color(
    light_blue = "#434C5E"
  ),
  adminlte_global(
    content_bg = "#FAFCFF",
    box_bg = "#D8DEE9", 
    info_box_bg = "#D8DEE9"
  )
)





# ---------- DEFINE USER INTERFACE (UI) ----------

ui <- navbarPage(
  
  # Title of site
  "DDRP Pest Trends in the United States",
  
  # Can adjust theme later for aesthetic preferences
  theme = bs_theme(bootswatch = "sandstone",
                   bg = "#FFF5EE",
                   fg = "#8B4500",
                   base_font = font_google("Prompt"),
                   heading_font = font_google("Hubballi")),
  
  # Disable sidebar content
  dashboardSidebar(disable = TRUE),
  
  # Tab 1
  tabPanel(
    
    # Title of sub-page
    "About",
    
    #### * OVERVIEW ####
    
    fluidRow(
      
      style = "font-size:19px;",
      
      box(title = strong("Overview", style = "font-size:22px"),
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          width = 12,
          color = "light-blue",
          
          fluidRow(
            
            style = "font-size:19px;",
            
            column(width = 12, 
                   offset = 0, 
                   p("The boxwood blight infection risk mapping tool produces forecasts of the risk of boxwood being infected by boxwood blight in western Oregon and Washington. This information may help with planning scouting activities and with efforts to prevent or mitigate infections (e.g., with fungicide treatments). Forecasts are available for each day between tomorrow and four days from today. Climate data are derived from the", 
                     a(href = "https://www.prism.oregonstate.edu", "PRISM", 
                       target = "_blank", 
                       style="text-decoration-line: underline;"), 
                     "database at a 800 m", 
                     tags$sup(2, .noWS = "before"), 
                     " resolution and from the", 
                     a(href = "https://vlab.noaa.gov/web/mdl/ndfd", 
                       "NDFD", 
                       target = "_blank", 
                       style = "text-decoration-line: underline;"), 
                     "database (downscaled from a 2.5 km", 
                     tags$sup(2, .noWS = "before"), 
                     "to an 800 m", tags$sup(2, .noWS = "before"), "resolution). Presently models are run only for areas west of the Cascades (approximately west of \u2013120.5\u00B0W). Please see a", 
                     a(href = "BOXB_webapp_tutorial.pdf", "tutorial", 
                       target = "_blank", 
                       style="text-decoration-line: underline;"), 
                     "for details on tool use and map interpretation. Expand the Introduction below to learn more about boxwood blight and risk models for this disease."))))),
    
    
    
    #### * ABOUT ####
    
    fluidRow(
      
      style = "font-size:19px;",
      
      box(title = strong("About", style = "font-size:22px"),
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          width = 12,
          color = "light-blue",
          
          fluidRow(
            
            style = "font-size:19px;",
            
            column(width = 2, align = "center", style='padding:0px;font-size:14px;',
                   img(src = "boxb-infected-shrubs2.png", 
                       width = "155px", 
                       style = "max-height: 240px;"),
                   img(src = "boxb-infected-leaves2.png", 
                       width = "155px", 
                       style = "max-height: 240px;"),
                   img(src = "boxb-infected-stems2.png", 
                       width = "160px", 
                       style = "max-height: 240px;")),
            
            column(width = 10, offset = 0, 
                   p(strong("Introduction: "), "Boxwood blight caused by the fungus ", em("Calonectria pseudonaviculata"), " can result in defoliation, decline, and death of susceptible varieties of boxwood, including most varieties of ", em("Buxus sempervirens"), " such as \u0022Suffruticosa\u0022  (English boxwood) and \u0022Justin Brouwers\u0022. Images show diagnostic symptoms of boxwood blight including", strong("(A)"),  "defoliation,", strong("(B)"), "leaf spots, and", strong("(C)"), "black streaks on stems (courtesy of Chuan Hong). The fungus has been detected at several locations (mostly in nurseries) in at least six different counties in Oregon and is thought to be established in some areas. Previous", a(href = "https://doi.org/10.3390/biology11060849", "research", target = "_blank", style="text-decoration-line: underline;"), "indicates that western Oregon and Washington have highly suitable climates for establishment of", em("C. pseudonaviculata"),  ". Tools are therefore needed to inform growers and gardeners about when environmental conditions are conducive to boxwood blight infection and establishment."),
                   p("Generally, it should be very humid or raining and at moderately warm temperatures (60\u201385\u00B0F) for a couple days for boxwood blight infection risk to be high. An inoculum source must be present nearby for infection to occur. Overhead irrigation facilitates outbreaks because it creates higher relative humidity and exposes leaf surfaces to longer periods of leaf wetness. For more information on preventing and managing boxwood blight, see the ", a(href = " https://pnwhandbooks.org/plantdisease/host-disease/boxwood-buxus-spp-boxwood-blight", "Pacific Northwest Pest Management Handbook", target = "_blank", style="text-decoration-line: underline;"), " and a ", a(href = " https://www.pubs.ext.vt.edu/content/dam/pubs_ext_vt_edu/PPWS/PPWS-29/PPWS-29-pdf.pdf", "publication", target = "_blank", style="text-decoration-line: underline;"),"by Virginia Cooperative Extension."),
                   p(strong("Tool description: "), "The risk mapping tool is similar to the ", a(href = "https://uspest.org/risk/boxwood_app", "boxwood blight model app", target = "_blank", style="text-decoration-line: underline;"), "and the", a(href = "https://uspest.org/risk/boxwood_map", "synoptic map-view of risk", target = "_blank", style="text-decoration-line: underline;"), "available at", a(href = "https://uspest.org", "USPest.org", target = "_blank", style="text-decoration-line: underline;"), "except that it uses daily gridded climate data instead of hourly climate data from single weather stations.  The spatial model is run using a modified version of a platform known as", a(href = "https://uspest.org/CAPS/", "DDRP", target = "_blank", .noWS = "after", style="text-decoration-line: underline;"), ", which provides real-time forecasts of phenology and establishment risk of 16 species of invasive insects in the contiguous US. It will likely need to be fine-tuned as more infection incidence data become available. Technical information on the station-based (hourly) model can be found at", a(href = "https://uspest.org/wea/Boxwood_blight_risk_model_summaryV3.pdf", "USPest.org", target = "_blank", .noWS = "after", style="text-decoration-line: underline;"),"."),
                   p(strong("Suggested citation: "), "Barker, B. S., and L. Coop. 2023. Boxwood blight risk mapping app for western Oregon and Washington. Oregon IPM Center, Oregon State University.", a(href = "https://riskmaps.oregonstate.edu/boxb/", "https://riskmaps.oregonstate.edu/boxb/", .noWS = c("after"), style="text-decoration-line: underline;"), "."),
                   p(strong("Source code and feedback: "), "To view the source code, visit the", a(href = "https://github.com/bbarker505/boxb-webapp", "GitHub repository", target = "_blank", .noWS = c("after"), style="text-decoration-line: underline;"), ". To report bugs or provide feedback, please e-mail Brittany Barker at", a(href = "mailto:brittany.barker@oregonstate.edu", "brittany.barker@oregonstate.edu", .noWS = c("after"), style="text-decoration-line: underline;"), "."),
                   p(strong("Disclaimer: "), "The risk index is intended to inform your decisions about management actions, such as choice and timing of control measures and intensity of scouting. It should supplement, not replace, the other factors you consider in making these decisions. Use at your own risk."))))),
    
    ),
  
  # Tab 2
  tabPanel(
    
    # Title of sub-page
    "Map",
    
    fluidRow(
      
      # Box for widgets
      box(width = 4,
          
          # Add title
          h3(HTML("<b>insert map controls here</b>")),
          
          # Controls to plot map for insect
          radioButtons("pest",
                       label = tags$span(h4(HTML("<b>Select insect:</b>")), 
                                         bsButton("info_maptype", 
                                                  label = "", 
                                                  icon = icon("info"), 
                                                  style = "info", 
                                                  size = "extra-small")),
                       choices = list("Asian longhorned beetle (ALB)",
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
                                      "Tomato leaf miner"),
                       selected = "Spotted lanternfly"))
          ),
      
      # Box for map
      tabBox(
        title = NULL,
        width = 8,
        
        # Tab for map
        tabPanel(
          title = "Visual",
          icon = icon("map-location-dot"),
          tags$style(type = "text/css",
                     "#map {height: calc(100vh - 80px) !important;}"),
          leafletOutput("map")
        ),
        
        # Tab for statistics
        tabPanel(
          title = "Stats",
          icon = icon("chart-column"),
          fluidRow(
            h3(HTML("<b>insert summary statistics here?</b>")),
            plotOutput("plot", width = "98%"),
            dataTableOutput("table")
          )
        )
      )
      
    ),
  
  # Tab 3
  tabPanel(
    
    # Title of sub-page
    "Pest information",
    
    # ALB
    fluidRow(
      style = "font-size:19px;",
      box(title = strong("Asian longhorned beetle", style = "font-size:22px"),
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          width = 12,
          color = "light-blue",
          fluidRow(
            style = "font-size:19px;",
            column(width = 12, 
                   offset = 0, 
                   p("words"))))),
    
    # ASRB
    fluidRow(
      style = "font-size:19px;",
      box(title = strong("Asian rice borer", style = "font-size:22px"),
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          width = 12,
          color = "light-blue",
          fluidRow(
            style = "font-size:19px;",
            column(width = 12, 
                   offset = 0, 
                   p("words"))))),
  
    # CGN
    fluidRow(
      style = "font-size:19px;",
      box(title = strong("Honeydew moth", style = "font-size:22px"),
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          width = 12,
          color = "light-blue",
          fluidRow(
            style = "font-size:19px;",
            column(width = 12, 
                   offset = 0, 
                   p("words"))))),
    
    # EAB
    fluidRow(
      style = "font-size:19px;",
      box(title = strong("Emerald ash borer", style = "font-size:22px"),
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          width = 12,
          color = "light-blue",
          fluidRow(
            style = "font-size:19px;",
            column(width = 12, 
                   offset = 0, 
                   p("words"))))),
    
    # ECW
    fluidRow(
      style = "font-size:19px;",
      box(title = strong("Egyptian cotton worm", style = "font-size:22px"),
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          width = 12,
          color = "light-blue",
          fluidRow(
            style = "font-size:19px;",
            column(width = 12, 
                   offset = 0, 
                   p("words")))))
    
    )
    
)





# ---------- DEFINE SERVER ----------

server <- function(input, output, session) {
  
  
  
  #### * IMPORT RASTERS ####
  
  # Different maps are rendered depending on radioButton inputs
  observeEvent(input$pest, {
    
    # Raster selection for each species
    pest_raster <- switch(input$pest,
                             "Spotted lanternfly" = rasts[[1]])
    
    
    
    #### * RENDER LEAFLET MAPS ####
    
    # Current year map
    output$map <- renderLeaflet({ 
      RiskMap(input, pest_raster) %>%
        fitBounds(lng1 = -127.856833, 
                  lat1 = 23.717389, 
                  lng2 = -64.790557, 
                  lat2 = 50.864485)
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
        
        if (coords$lat > 23.717389 & coords$lat < 50.864485 & 
            coords$long > -127.856833 & coords$long < -64.790557) {
          
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
        
        # Zoom back out to western OR and WA and clear location markers
        
        leafletProxy("map")  %>%
          fitBounds(lng1 = -127.856833, 
                    lat1 = 23.717389, 
                    lng2 = -64.790557, 
                    lat2 = 50.864485) %>%
          removeMarker(layerId = "Value")  %>% 
          addImageQuery(raster(pest_raster), project = TRUE, prefix = "", digits = 0,
                        layerId = "Value", position = "topleft", type = "mousemove") 
      }
    })
    
  })
  
} # END OF SERVER




# ---------- RUN APP ----------
shinyApp(ui = ui, server = server)
