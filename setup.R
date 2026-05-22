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
us_counties <- st_read("./features/cb_2018_us_county_5m.shp") %>% 
  dplyr::filter(!STATEFP %in% c("02", "15", "66", "72", "78", "69", "60")) %>% 
  st_transform(crs = 4326)

# Reproject to WGS84
#us_counties <- st_transform(us_counties, crs = 4326)

# US state borders
us_states <- st_read("./features/cb_2018_us_state_20m.shp") %>% 
  dplyr::filter(!STATEFP %in% c("AK", "HI", "GU", "PR", "VI", "MP", "AS"))  %>% 
  st_transform(crs = 4326)

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

# -- Species abbr. for PNG file exports --
species_abbrev <- c(
  "Asian longhorned beetle"	= "ALB",
  "Asiatic rice borer" = "ASRB",
  "Honeydew moth" =	"CGN",
  "Emerald ash borer"	= "EAB",
  "Egyptian cottonworm" =	"ECW",
  "False codling moth" = "FCM",
  "Japanese beetle" =	"JPB",
  "Japanese pine sawyer beetle", "JPSB",
  "Light brown apple moth" = "LBAM",
  "Oak ambrosia beetle" = "OAB",
  "Old world bollworm" = "OWBW",
  "Pine-tree lappet moth" =	"PTLM",
  "Spotted lanternfly" = "SLF",
  "Common or Cotton cutworm" = "SLI",
  "Silver Y moth" = "SLYM",
  "Small tomato borer" = "STB",
  "Sunn pest" = "SUNP",
  "Tomato leaf miner" = "TABS"
)
