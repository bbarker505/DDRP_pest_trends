# Contains preamble for Shiny that doesn't need to be in the UI or server

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

# All have CRS = WGS 84

# County boundaries
county_sf <- st_read("./features/counties_CONUS.shp")

# Define bounds
north <- 50
south <- 24.5
east <- -65.1
west <- -126.2

# Compile
bounds <- list(
  c(south, west),
  c(north, east)
)

# ----- IMPORT AND PROCESS MODEL OUTPUTS----------------------------------------

# Directory holding all rasters to import
raster_lookup <- read.csv("raster_lookup.csv")

# Directory holding all rasters to import
rasts_dir <- paste0("./rasters/MK_trends")

# List all tif files in each sub-folder
files <- list.files(
  rasts_dir,
  pattern = "\\.tif$",
  full.names = TRUE,
  recursive = TRUE       
)

# Import model outputs
rasts <- map(
  files,
  ~ RastImport(.x)  
)

# For selection later ---

# Extract species prefixes
species <- unique(sub("_.*", "", basename(files)))

# Extract years
years <- unique(sub(".*_", "", tools::file_path_sans_ext(basename(files))))

# Extract variable names
variable <- basename(files)
variable <- sub(".*MK_", "", variable)                # Remove before MK_
variable <- sub("_\\d{2}-\\d{2}.*", "", variable)     # Remove _YY-YY
variable <- unique(tools::file_path_sans_ext(variable))