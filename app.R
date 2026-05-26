# ---------- DDRP Pest Trends Shiny App ----------------------------------------

# Information ----

# Purpose:
# This app presents results from a proven modeling system to assess the  
# potential impacts of recent weather trends (1980−2024) on the timing of  
# pest activities such as emergence, number of generations, and establishment 
# for 18 major invasive species for the contiguous United States. 

# Authors: 
# Brittany S. Barker* and Maxine Cruz
# Oregon IPM Center, Oregon State University
# *Corresponding author: brittany.barker@oregonstate.edu

# Funding:
# (1) USDA APHIS PPQ PPA 7721 Program, Project 1A.0036.01
# (2) Oregon State University Agricultural Research Fund (2025-2027)
# (3) USDA NIFA AFRI Agricultural Biosecurity award (#2022-68013-37138) 

# Date: 
# Last modified on X-X-2026

# Setup ----

# Packages
source("packages.R")

# Import custom functions
source("functions.R")

# Set-up
source("setup.R")

# User interface
source("ui.R")

# Server
source("server.R")

# Raster lookup
source("create_raster_lookup.R")

# Run app ----
shinyApp(
  ui = ui, 
  server = server
  )
