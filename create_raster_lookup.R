# ----- ABOUT -----------------------------------------------------------------

# Create a look-up table containing all the raster files in the directory.

# We have a bunch of files structured as <PREFIX>_MK_<VARIABLE>_<YEAR>.tif
  # and creating a table with each of the selection combos in Shiny listed in
  # a table with the associated file could help ease the file search.

# We also now have DDRP files for each year





# ----- LIBRARIES --------------------------------------------------------------

# Load packages (we need dplyr, stringr, and fs)
source("packages.R")





# ----- CREATE TABLE -----------------------------------------------------------

# Set raster directory
rasts_dir <- "rasters"

# Find all .tif files in that folder
files <- dir_ls(rasts_dir, 
                recurse = TRUE, 
                glob = "*.tif")

# Get file with PEM codes (that Brittany created)
pem_codes <- read.csv("pem_codes.csv")

# Table of species names
species_table <- pem_codes %>%
  dplyr::select(Abbr, Species, Common_name) %>%
  dplyr::distinct() %>%
  dplyr::rename(
    abbr = Abbr,
    species = Species,
    common_name = Common_name
  )

# Make lookup table
lookup_table <- tibble(file_path = files) %>%
  
  dplyr::mutate(
    
    # File names
    file_name  = fs::path_file(file_path),
    
    # Split up file name
    path_parts = fs::path_split(file_path),
    
    # DDRP or MK_trends
    model_type = purrr::map_chr(path_parts, ~ .x[2]),
    
    # Species abbreviation
    abbr = purrr::map_chr(path_parts, ~ .x[3]),
    
    # Year of rasters
    folder_year = purrr::map_chr(path_parts, ~ .x[4]),
    
    # Variable name
    var_name = stringr::str_remove(file_name, "\\.tif$")
    
  ) %>%
  
  # What to do with year in file name
  dplyr::mutate(
    
    # IF DDRP:
    year = ifelse(model_type == "DDRP", folder_year, NA_character_),
    
    # IF MK_TRENDS:
    year = ifelse(
      
      model_type == "MK_trends",
      
      {
        yr <- stringr::str_extract(var_name, "[0-9]{2}-[0-9]{2}$")
        start <- as.integer(substr(yr, 1, 2))
        end   <- as.integer(substr(yr, 4, 5))
        start_full <- ifelse(start <= 30, 2000 + start, 1900 + start)
        end_full   <- ifelse(end <= 30, 2000 + end, 1900 + end)
        paste0(start_full, "-", end_full)
      },
      
      year
      
    ),
    
    # Clean variable names
    variable = var_name %>%
      
      # Remove DDRP PEM dates
      stringr::str_remove("_[0-9]{8}$") %>%
      
      # Remove MK_trends year suffix
      stringr::str_remove("_[0-9]{2}-[0-9]{2}$") %>%
      
      # Remove MK prefix from MK_trends files
      stringr::str_remove(paste0("^", abbr, "_MK_"))
    
  ) %>%
  
  # Map PEM variables to First_adult_emergence or First_egg_hatch
  dplyr::mutate(
    
    variable = ifelse(
      
      stringr::str_detect(variable, "^Earliest_PEM"),
      dplyr::case_when(
        stringr::str_detect(variable, "p0|a0") ~ "First_Adult_Emergence",
        stringr::str_detect(variable, "e0|e1") ~ "First_Egg_Hatch",
        TRUE ~ variable
        
      ),
      
      variable
      
    )
    
  ) %>%
  
  # Merge data frames by species abbreviation
  dplyr::left_join(species_table, by = "abbr") %>%
  
  # Only keep certain columns
  dplyr::select(abbr, species, common_name, model_type, variable, year, file_path)

# Check
head(lookup_table, 5)



# ----- SAVE TABLE -------------------------------------------------------------

write.csv(lookup_table, "raster_lookup.csv", row.names = FALSE)




