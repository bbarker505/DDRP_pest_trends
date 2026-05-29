# ---------- REQUIRED R PACKAGES -----------------------------------------------

# List of required packages for app to run the DDRP Pest Trends app

library(bslib)                # Modern UI toolkit for Shiny
library(bsicons)              # Plus sign for accordion panels
library(fresh)                # Color theme for web app page
library(fs)                   # Handles path structures in Shiny, etc.
library(glue)                 # String interpolation
library(ggrepel)              # Slope equation and R2 on location plots
library(htmlwidgets)          # R binding for JavaScript libraries
library(leafem)               # Query map values
library(leaflet)              # Interactive maps
library(leaflegend)           # Extra legend features
library(leaflet.extras)       # Extra functions for leaflet
library(lubridate)            # Working with dates
library(mapview)              # Open access street maps
library(mblm)                 # Theil-Sen slope estimates
library(memoise)              # Wrap raster loading in a cache
library(modifiedmk)           # Mann-Kendall test for location plots
library(scales)               # Custom scales for plots
library(sf)                   # Spatial features
library(shiny)                # Web app 
library(shinyBS)              # Info tabs next to risk map menu items
library(shinycssloaders)      # "Loading" animation for risk maps (waiting)
library(shinydashboard)       # Custom dashboards
library(shinyjs)              # For "delay" function to causes error messages to disappear
library(shinyWidgets)         # Custom widgets
library(stringr)              # Working with strings
library(terra)                # Import model outputs / work with rasters
library(tidyverse)            # Data wrangling/manipulation
library(viridisLite)          # For species comparison maps
library(webshot2)             # For exporting maps