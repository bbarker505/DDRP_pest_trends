# Last modified: 11 October 2025

# ----- ABOUT ------------------------------------------------------------------

# Contains custom functions to be loaded into the app.R file





#  ----- Function to import outputs (rasters) -----

# The Mann-Kendall test has a tau and p-value that we're interested in

# Tau
rast_import_tau <- function(file_name) {
  
  # Pull in file as Spatraster
  rast_stack <- rast(file_name)
  
  # Select layer containing tau
  rast <- rast_stack$tau
  
  # Convert crs
  crs(rast) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=GRS80 +towgs84=0,0,0"
  
  return(rast)
  
}

# P-value
rast_import_pval <- function(file_name) {
  
  # Pull in file as Spatraster
  rast_stack <- rast(file_name)
  
  # Select layer containing p-values
  rast <- rast_stack$sl
  
  # Convert crs
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

produce_map <- function(input, rast, north, south, east, west) {
  
  # Need different layer IDs (for "addImageQuery") and zoom/drag options 
  layerID <- "Value"
  
  # Generate map
  map <- leaflet(#height = 500, 
    
    # Custom leaflet options
    options = leafletOptions(attributionControl = FALSE,
                             zoomControl = FALSE, 
                             minZoom = 1,
                             zoomSnap = 0,
                             zoomDelta = 0.25)) %>% 
    
    # Custom JavaScript overrides
    htmlwidgets::onRender(sprintf("
  function(el, x) {
    var map = this;

    // Zoom control
    L.control.zoom({ position: 'topright' }).addTo(map);

    // Exact bounds for map
    var exactBounds = L.latLngBounds(
      [%f, %f],
      [%f, %f]
    );

    // Enforce exact bounds for panning
    map.on('moveend', function() {
      if (!exactBounds.contains(map.getCenter())) {
        map.panInsideBounds(exactBounds, { animate: false });
      }
    });

    // Enforce fractional min-zoom (default leaflet only allows integer zoom)
    map.on('zoomend', function() {
      if (map.getZoom() < 4.75) {
        map.setZoom(4.75);
      }
    });
  }
", south, west, north, east))
  
  # Add additional map features
  map <- map %>%
    
    # Add OpenStreetMap layer
    addProviderTiles(providers$CartoDB.Voyager)  %>%
    
    # Raster layer output
    addRasterImage(raster(rast), 
                   opacity = 0.65,
                   group = layerID, 
                   layerId = layerID) %>%
    
    # Risk layer raster query (use project = TRUE or get wrong values)
    addImageQuery(raster(rast), 
                  project = TRUE, 
                  prefix = "", 
                  digits = 0,
                  layerId = layerID, 
                  position = "topleft", 
                  type = "mousemove") %>% # change to click later?
    
    # Add county lines
    addPolylines(data = county_sf, 
                 group = "Counties", 
                 opacity = 0.15, 
                 color = "black", 
                 weight = 1.25) %>%
    
    # Set initial view
    setView(lng = mean(c(west, east)),
            lat = mean(c(south, north)),
            zoom = 4.75) %>%
    
    # Shows map coordinates as mouse is moved over map
    addMouseCoordinates
  
  # Return map
  return(map)
  
}
