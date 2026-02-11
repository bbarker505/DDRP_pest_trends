# ---- ABOUT -------------------------------------------------------------------

# Contains preamble for Shiny that doesn't need to be in the UI or server





# ----- MISCELLANEOUS ----------------------------------------------------------

# Shows full error message (if there is one) on app
options(shiny.sanitize.errors = FALSE)






# ----- SPATIAL FEATURES -------------------------------------------------------

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






# ----- IMPORT AND PROCESS MODEL OUTPUTS----------------------------------------

# File of all raster files
raster_lookup <- read.csv("raster_lookup.csv")

# (For selection later) ---

# Directory holding all rasters to import
rasts_dir <- paste0("./rasters/MK_trends")

# List all tif files in each sub-folder
files <- list.files(
  rasts_dir,
  pattern = "\\.tif$",
  full.names = TRUE,
  recursive = TRUE       
)





# ----- OTHER DISPLAY COMPONENTS -----------------------------------------------

# For how variables are displayed in floating statistics panel
variable_labels <- c(
  Cold_Stress     = "Cold stress",
  Heat_Stress     = "Heat stress",
  First_egg_hatch = "1st egg hatch",
  First_adult_emergence  = "1st adult emergence"
)



