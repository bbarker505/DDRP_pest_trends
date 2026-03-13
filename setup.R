# ----- ABOUT ------------------------------------------------------------------

# Contains preparatory code for the map





# ----- SET-UP -----------------------------------------------------------------

# -- RUN NECESSARY STUFF I HAVE IN OTHER FILES --

# Packages
source("packages.R")

# Import custom functions
source("functions.R")


# -- RANDOM STUFF --

# Shows full error message (if there is one) on app
options(shiny.sanitize.errors = FALSE)

# Raster cache (so they're only loaded once)
.raster_cache <- new.env(parent = emptyenv())


# -- sHAPEFILE STUFF --

# Shapefile of county boundaries (to overlay map)
county_sf <- st_read("./features/counties_CONUS.shp")

# Reproject to WGS84
county_sf <- st_transform(county_sf, crs = 4326)

# US state borders
us_states <- states(cb = TRUE, year = 2022) %>%
  st_transform(4326) %>%
  dplyr::select(STUSPS, geometry)

# Define bounds (United States bounds)
bounds <- list(
  north = 50,
  south = 24.5,
  east  = -65.1,
  west  = -126.2
)


# -- RASTER STUFF --

# File of all raster files
raster_lookup <- read.csv("raster_lookup.csv")



