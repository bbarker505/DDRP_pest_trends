# ----- ABOUT -----------------------------------------------------------------

# Create a look-up table containing all the raster files in the directory.

# We have a bunch of files structured as <PREFIX>_MK_<VARIABLE>_<YEAR>.tif
  # and creating a table with each of the selection combos in Shiny listed in
  # a table with the associated file could help ease the file search.





# ----- LIBRARIES --------------------------------------------------------------

library(dplyr)
library(stringr)
library(fs)





# ----- CREATE TABLE -----------------------------------------------------------

# Set raster directory
rasts_dir <- "rasters"

# Find all .tif files in that folder
files <- dir_ls(rasts_dir, 
                recurse = TRUE, 
                glob = "*.tif")

# List of pest names and associated abbreviations
pest_to_species <- list(
  
  "Asian longhorned beetle"     = "ALB",
  "Asiatic rice borer"          = "ARB",
  "Common / Cotton cutworm"     = "SLI",
  "Egyptian cottonworm"         = "ECW",
  "Emerald Ash borer"           = "EAB",
  "False codling moth"          = "FCM",
  "Honeydew moth"               = "CGN",
  "Japanese beetle"             = "JPB",
  "Japanese pinesawyer beetle"  = "JPSB",
  "Light brown apple moth"      = "LBAM",
  "Oak ambrosia beetle"         = "OAB",
  "Old world bollworm"          = "OWBW",
  "Pine-tree lappet moth"       = "PTLM",
  "Silver Y moth"               = "SLYM",
  "Small tomato borer"          = "STB",
  "Spotted lanternfly"          = "SLF",
  "Sunn pest"                   = "SUNP",
  "Tomato leaf miner"           = "TABS"
  
)

# Connect names to prefixes
prefix_mapping <- tibble(
  pest = names(pest_to_species),
  prefix = unlist(pest_to_species)
)

# Make table
table <- 
  
  # Start with columns with file names
  tibble(file_path = files,
         file_name = path_file(files)
         
         ) %>%
  
  # Make modifications
  mutate(
    
    # Remove extension
    base = str_remove(file_name, "\\.tif$"),
    
    # Split parts: PREFIX_MK_VARIABLE_YEAR
    prefix     = str_extract(base, "^[^_]+"),
    variable   = str_extract(base, "(?<=_MK_).+(?=_[0-9]{2}-[0-9]{2}$)"),
    year_range = str_extract(base, "[0-9]{2}-[0-9]{2}$")
    
    ) %>%
  
  # Reorder columns
  dplyr::select(prefix, variable, year_range, file_path) %>%
  
  # Add the associated names to the prefixes
  left_join(prefix_mapping, by = "prefix")

# Check
head(table, 5)



# ----- SAVE TABLE -------------------------------------------------------------

write.csv(table, "raster_lookup.csv", row.names = FALSE)




