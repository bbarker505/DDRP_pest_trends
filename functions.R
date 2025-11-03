# Last modified: 11 October 2025

# --- ABOUT ---

# Contains custom functions to be loaded into the app.R file



# ---






# ----- Function that removes leading 0s in map title dates -----

DateFormat <- function(dat) {
  
  str_glue("{month(dat)}/{day(dat)}/{year(dat)}")
  
}






#  ----- Function to import outputs (rasters) -----

# Raster with total cumulative DDs has multiple layers so need only last layer, 
# which corresponds to cumulative DDs on last sampling day (= 4 days from current date)

# Rasters with 3- and 4-day risk have only 1 layer

RastImport <- function(file_name) {
  
  rast_stack <- rast(file_name)
  
  # Round up to nearest 0.5 
  rast <- ceiling(rast_stack[[nlyr(rast_stack)]] / 0.5) * 0.5 
  
  crs(rast) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=GRS80 +towgs84=0,0,0"
  
  return(rast)
  
}






#  ----- Function to factorize a raster (translate numbers to a category) -----

FactorizeRast <- function(r, type) {
  
  # Must recode raster because raster factorization doesn't work when 
  # there are "duplicate" values (e.g., if 1.5 and 2 are both "High Risk"),
  # and apparently it won't accept decimal values? This is strange.
  
  r[r >= 2] <- 4          # Values >2 are 5-8 lesions
  r[r == 1.5] <- 3        # Values of 1.5 are 1-6 lesions
  r[r == 1] <- 2          # Values of 1 are 1st infection susc. varieties
  r[r == 0.5] <- 1        # Values of 0.5 are low risk 
  
  # Unique values up to 4 ("High risk" is always >= 4)
  vals <- unique(values(r))
  vals <- vals[!is.na(vals)]
  
  # Levels
  lvls <- data.frame(ID = vals) %>%
    mutate(
      risk = case_when(ID == 0 ~ "0: Very Low Risk",
                       ID == 1 ~ "1: Low Risk",
                       ID == 2 ~ "2: 1st Infec. Susc. Vars.",
                       ID == 3 ~ "3: Up to 1-6 Lesions",
                       ID == 4 ~ "4: Up to 5-18 Lesions")) %>%
    arrange(ID)
  
  # Factorize raster
  levels(r) <- lvls
  
  return(r)
  
}






# ----- Produce a leaflet map showing risk of infection -----

RiskMap <- function(input, rast) {
  
  # Need different layer IDs (for "addImageQuery") and zoom/drag options 
    
    layerID <- "Value"
    
    map <- leaflet(#height = 500, 
      
      options = leafletOptions(
        
        attributionControl = FALSE, 
        zoomControl = FALSE, 
        minZoom = 6)) %>% 
      
      # Change position of zoom control buttons
      
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
      }")
  
  # Add additional map features
  map <- map %>%
    
    # Add OpenStreetMap layer
    addProviderTiles(providers$CartoDB.Voyager)  %>%
    #addProviderTiles(providers$Stamen.TonerLite)  %>%
    
    # Risk layer output
    addRasterImage(raster(rast), 
                   # color = pal, 
                   opacity = 0.65,
                   group = layerID, 
                   layerId = layerID) %>%
    
    # Risk layer raster query (use project = TRUE or get wrong values)
    # Changed from "mousemove" to "mousemove" because value would 
    # sometimes get "stuck" (wouldn't update)
    addImageQuery(raster(rast), 
                  project = TRUE, 
                  prefix = "", 
                  digits = 0,
                  #raster(rast), project = TRUE, prefix = "", digits = 0,
                  layerId = layerID, 
                  position = "topleft", 
                  type = "mousemove") %>%
    
    # Add county lines / markers
    addPolylines(data = state_sf, 
                 group = "States", 
                 opacity = 0.25, 
                 color = "black", 
                 weight = 1.75) %>%
    
    addPolylines(data = county_sf, 
                 group = "Counties", 
                 opacity = 0.15, 
                 color = "black", 
                 weight = 1.25) %>%
    
    # Max bounds prevents zooming out past western OR and WA
    # Adjust for united states
    setMaxBounds(lng1 = -127.856833, 
                 lat1 = 23.717389, 
                 lng2 = -64.790557, 
                 lat2 = 50.864485) %>%

    
    # Shows map coordinates as mouse is moved over map
    addMouseCoordinates
  
  # TO DO: Could not figure out how to put legend outside of map!!!
  
  # The legend gets in the way when viewing the app on a phone
  
  return(map)
  
}
