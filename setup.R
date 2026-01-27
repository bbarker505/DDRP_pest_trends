# ---- ABOUT -------------------------------------------------------------------

# Contains preamble for Shiny that doesn't need to be in the UI or server





# ----- MISCELLANEOUS ----------------------------------------------------------

# Shows full error message (if there is one) on app
options(shiny.sanitize.errors = FALSE)

# Figure out what this does... allows access to map tiles?
Sys.setenv(MAPQUEST_API_KEY = "5vjLXIpEjMHpANFr4Ok2BNxpuQPrsGQP")





# ----- DATES ------------------------------------------------------------------

# Used in map titles

# Current dates and year
current_date <- Sys.Date()
current_year <- as.numeric(format(current_date, format = "%Y"))





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
north <- 50
south <- 24.5
east <- -65.1
west <- -126.2

# Compile bounds
bounds <- list(
  c(south, west),
  c(north, east)
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
  Earliest_PEMe0  = "Egg hatch (overwintering)",
  Earliest_PEMe1  = "Egg hatch (1st adults)",
  Earliest_PEMp0  = "First adult emergence"
)



