# ----- ABOUT -----------------------------------------------------------------

# Create a look-up table containing all the raster files in the directory.

# We have a bunch of files structured as <PREFIX>_<MODEL>_<VARIABLE>_<YEAR>.tif
  # and creating a table with each of the selection combos in Shiny listed in
  # a table with the associated file could help ease the file search.





# ----- LIBRARIES --------------------------------------------------------------

# Load packages (we need dplyr, stringr, and fs)
source("packages.R")

# ----- CREATE TABLE -----------------------------------------------------------

# Set raster directory
rasts_dir <- "rasters"

# Find all .tif files in that folder
all_files <- dir_ls(rasts_dir, 
                    recurse = TRUE, 
                    glob = "*.tif")

# Separate Comparisons rasters (later step) vs others
comp_files <- all_files[str_detect(all_files, "/Comparisons/")]
files <- setdiff(all_files, comp_files)

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
raster_lookup <- tibble(file_path = files) %>%
  
  dplyr::mutate(
    
    # File names
    file_name  = fs::path_file(file_path),
    
    # Split up file name
    path_parts = fs::path_split(file_path),
    
    # Model type
    model_type = purrr::map_chr(path_parts, ~ .x[2]),
    
    # Species abbreviation
    abbr = purrr::map_chr(path_parts, ~ .x[3]),
    
    # Year of rasters
    folder_year = purrr::map_chr(path_parts, ~ .x[4]),
    
    # Variable name
    var_name = stringr::str_remove(file_name, "\\.tif$")
    
  ) %>%
  
  # What to do with year in file name (need to turn it into full year name)
  dplyr::mutate(
    
    # IF DDRP:
    year = ifelse(model_type == "DDRP", folder_year, NA_character_),
    
    # IF MK_TRENDS and CRM:
    year = ifelse(
      
      model_type %in% c("MK_trends", "CLM"),
      
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
      
      # Remove year suffix (MK + CLM)
      stringr::str_remove("_[0-9]{2}-[0-9]{2}$") %>%
      
      # Remove prefix for MK_trends + CLM
      {\(x)
        
        dplyr::if_else(
          
          model_type %in% c("MK_trends", "CLM"),
          stringr::str_replace(x, "^[^_]+_[^_]+_", ""),
          x
          
        )
        
      }() %>%
      
      # Replace underscores with spaces
      stringr::str_replace_all("_", " ") %>%
      
      # Trim whitespace
      stringr::str_trim()
    
  ) %>%
  
  # Map PEM variables to First_adult_emergence or First_egg_hatch
  dplyr::mutate(
    
    variable = ifelse(
      
      stringr::str_detect(variable, "^Earliest PEM"),
      dplyr::case_when(
        stringr::str_detect(variable, "p0|a0") ~ "First Adult Emergence",
        stringr::str_detect(variable, "e0|e1") ~ "First Egg Hatch",
        TRUE ~ variable
        
      ),
      
      variable
      
    )
    
  ) %>%
  
  # Make sure Cold and Heat Stress labels are uniform across variables
  dplyr::mutate(
    
    variable = dplyr::case_when(
      
      stringr::str_detect(variable, "^Cold Stress") ~ "Cold Stress",
      stringr::str_detect(variable, "^Heat Stress") ~ "Heat Stress",
      
      TRUE ~ variable
      
    )
    
  ) %>%
  
  # Merge data frames by species abbreviation
  dplyr::left_join(species_table, by = "abbr") %>%
  
  # Only keep certain columns
  dplyr::select(abbr, species, common_name, model_type, variable, year, file_path)

# ----- Add Comparisons rasters ------------------------------------------------

# Decided to do these rasters separately and then merge them, rather than try
# adding to / modifying the previous code. Mostly because file path is 
# slightly different, and there is no specific species per file.

# Lookup for those files
comparisons_lookup <- tibble(file_path = comp_files) %>%
  dplyr::mutate(
    file_name = fs::path_file(file_path),
    model_type = "Comparisons",
    abbr = NA_character_,
    species = NA_character_,
    common_name = "All 18 spp",
    
    # Extract variable: only Cold Stress, Heat Stress, First Adults, First Egg Hatch
    variable = case_when(
      str_detect(file_name, "Cold_Stress")  ~ "Cold Stress",
      str_detect(file_name, "Heat_Stress")  ~ "Heat Stress",
      str_detect(file_name, "First_Adults") ~ "First Adult Emergence",
      str_detect(file_name, "First_Egg_Hatch")   ~ "First Egg Hatch",
      TRUE                                  ~ NA_character_
    ),
    
    # Extract year range from file name (e.g., 81-25 -> 1981-2025)
    year = str_extract(file_name, "[0-9]{2}-[0-9]{2}") %>%
      {paste0(
        ifelse(as.integer(substr(.,1,2)) <= 30, 2000 + as.integer(substr(.,1,2)), 1900 + as.integer(substr(.,1,2))),
        "-",
        ifelse(as.integer(substr(.,4,5)) <= 30, 2000 + as.integer(substr(.,4,5)), 1900 + as.integer(substr(.,4,5)))
      )}
  ) %>%
  dplyr::select(abbr, species, common_name, model_type, variable, year, file_path)

# Combine with original raster_lookup
full_raster_lookup <- rbind(comparisons_lookup, raster_lookup)

# Check
head(raster_lookup, 5)



# ----- SAVE TABLE -------------------------------------------------------------

write.csv(full_raster_lookup, "raster_lookup.csv", row.names = FALSE)




