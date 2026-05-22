# List of required packages for app to run
library(bslib)
library(fresh)                # Color theme for web app page
library(fs)
library(glue)
library(ggrepel)
library(htmlwidgets)
library(leafem)               # Query map values
library(leaflet)              # Interactive maps
library(leaflegend)           # Extra legend features
library(leaflet.extras)     
library(lubridate)            # Working with dates
library(mapview)              # Open access street maps
library(mblm)
library(modifiedmk)
library(scales)
library(sf)                   # Spatial features
library(shiny)                # Web app 
library(shinyBS)              # Info tabs next to risk map menu items
library(shinycssloaders)      # "Loading" animation for risk maps (waiting)
library(shinydashboard)
library(shinyjs)              # For "delay" function to causes error messages to disappear
library(shinyWidgets)
library(stringr)
library(terra)                # Import model outputs / work with rasters
library(tidyverse)            # Data wrangling/manipulation
library(viridisLite)          # For species comparison maps
library(webshot2)             # For exporting maps