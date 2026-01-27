# Last modified: 11 October 2025

# ----- ABOUT ------------------------------------------------------------------

# Contains custom functions to be loaded into the app.R file





# ----- Function to import outputs (rasters) -----------------------------------

# The Mann-Kendall test has some values that we're interested in

# Tau
rast_import_tau <- function(file_name) {
  
  # Pull in file as Spatraster
  rast_stack <- rast(file_name)
  
  # Select layer containing tau
  rast <- rast_stack$tau
  
  # Reproject to WGS84
  rast <- project(rast, "EPSG:4326")
  
  return(rast)
  
}

# P-value
rast_import_pval <- function(file_name) {
  
  # Pull in file as Spatraster
  rast_stack <- rast(file_name)
  
  # Select layer containing p-values
  rast <- rast_stack$sl
  
  # Reproject to WGS84
  rast <- project(rast, "EPSG:4326")
  
  return(rast)
  
}

# Sen's slope
rast_import_ss <- function(file_name) {
  
  # Pull in file as Spatraster
  rast_stack <- rast(file_name)
  
  # Select layer containing slope
  rast <- rast_stack$S
  
  # Reproject to WGS84
  rast <- project(rast, "EPSG:4326")
  
  return(rast)
  
}






# ----- Function to factorize a raster (translate numbers to a category) -------

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






# ----- Produce a leaflet map showing risk of infection ------------------------

make_palette <- function(rast) {
  colorNumeric(
    palette = viridisLite::inferno(256),
    domain  = terra::values(rast),
    na.color = "transparent"
  )
}

produce_map <- function(input, rast, north, south, east, west) {
  
  # Need different layer IDs (for "addImageQuery") and zoom/drag options 
  layerID <- "Value"
  
  # For map legend
  pal <- make_palette(rast)
  
  # Generate map
  map <- leaflet( 
    
    # Custom leaflet options
    options = leafletOptions(attributionControl = FALSE,
                             zoomControl = FALSE,
                             minZoom = 4.75,
                             zoomSnap = 0.25,
                             zoomDelta = 0.25,
                             maxBounds = list(c(south, west), c(north, east)),
                             maxBoundsViscosity = 1.0)) %>%
    
    # Extra edits, Javascript
    htmlwidgets::onRender("
      function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this);
      }
    ") %>%
    
    # Add OpenStreetMap layer
    addProviderTiles(providers$CartoDB.Voyager)  %>%
    
    # Raster layer output
    #addRasterImage(raster(rast), 
    #               opacity = 0.65,
    #               group = layerID, 
    #               layerId = layerID) %>%
    
    addRasterImage(raster(rast),
                   colors = pal,
                   opacity = 0.65,
                   layerId = "Value"
    ) %>%
  
    
    # Add legend
    addLegend(
      position = "bottomright",
      pal = pal,
      values = terra::values(rast),
      title = "Kendall’s τ",
      labFormat = labelFormat(digits = 2)
    ) %>%
    
    # Add county lines
    addPolylines(data = county_sf, 
                 group = "Counties", 
                 opacity = 0.15, 
                 color = "grey", 
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






# ----- Function to clear absolutePanel stats when pest is changed -------------

clear_click_info <- function(output) {
  output$clicked_latlon <- renderUI(NULL)
  output$clicked_value  <- renderUI(NULL)
  output$clicked_pval   <- renderUI(NULL)
}






# ----- Function to filter content to state ------------------------------------

# Taken from https://github.com/bbarker505/ddrp_v3/blob/main/DDRP_v3_funcs.R

# Assign_extent: assign geographic extent
# Add new extent definitions here for use in models and plots
# Set up regions
# Use switch() (works like a single use hash) 

assign_extent <- function(region_param = paste0(region_param)) {
  REGION <- switch(region_param,
                   "CONUS"        = ext(-125.0, -66.5, 24.54, 49.4),
                   "WEST"         = ext(-125.0, -102, 31.1892, 49.4),
                   "EAST"         = ext(-106.8, -66.5, 24.54, 49.4),
                   "MIDWEST"      = ext(-104.2, -87, 30, 49.3),
                   "NORTHWEST"    = ext(-125.1, -103.8, 40.6, 49.15),
                   "SOUTHWEST"    = ext(-124.6, -101.5, 31.2, 42.3),
                   "SOUTHCENTRAL" = ext(-83.6, -78.3, 31.8, 35.3),
                   "NORTHCENTRAL" = ext(-104.3, -80.2, 35.7, 49.4),
                   "SOUTHEAST"    = ext(-107.1, -75.0, 24.54, 39.6),
                   "NORTHEAST"    = ext(-84.2, -64.3, 36.9, 48.1),
                   "N_AMERICA"    = ext(-159.8597, -48.08864, 18.57516, 61.04535),
                   "EUROPE"       = ext(-11, 45, 35.5, 71.5),
                   "CHINA"        = ext(70, 140, 15, 55),
                   "AL"           = ext(-88.5294, -84.7506, 30.1186, 35.1911),
                   "AR"           = ext(-94.8878, -89.5094, 32.8796, 36.6936),
                   "AZ"           = ext(-115, -108.98, 31.2, 37),
                   "CA"           = ext(-124.6211, -113.7428, 32.2978, 42.2931),
                   "CO"           = ext(-109.2625, -101.8625, 36.7461, 41.2214),
                   "CT"           = ext(-73.7700, -71.7870, 40.9529, 42.0355),
                   "DL"           = ext(-76.1392, -74.1761, 38.3508, 39.9919),
                   "FL"           = ext(-87.8064, -79.9003, 24.54, 31.1214),
                   "GA"           = ext(-85.7850, -80.5917, 30.1767, 35.1594),
                   "HI"           = ext(-178.335, -154.8068, 18.910, 28.402),
                   "IA"           = ext(-96.8617, -89.9697, 40.1147, 43.7353),
                   "ID"           = ext(-117.3917, -110.6167, 41.4500, 49.15),
                   "IL"           = ext(-91.5897, -87.0461, 36.8903, 42.6375),
                   "IN"           = ext(-88.1686, -84.4686, 37.7836, 41.9794),
                   "KS"           = ext(-102.3342, -94.1756, 36.6369, 40.2836),
                   "KY"           = ext(-89.3581, -81.8425, 36.4208, 39.3347),
                   "LA"           = ext(-94.3019, -88.7758, 28.8333, 33.2994),
                   "MA"           = ext(-73.5639, -69.7961, 41.1689, 42.9525),
                   "MD"           = ext(-79.7014, -74.8833, 37.0631, 39.9075),
                   "ME"           = ext(-71.4056, -66.6667, 42.9525, 47.5228),
                   "MI"           = ext(-90.5542, -82.3047, 41.6311, 47.5739),
                   "MN"           = ext(-97.4000, -89.3786, 43.2550, 49.4),
                   "MO"           = ext(-95.8803, -88.9883, 35.8822, 40.7058),
                   "MS"           = ext(-91.7475, -87.8522, 29.9842, 35.2631),
                   "MT"           = ext(-116.3667, -103.8250, 44.0667, 49.15),
                   "NC"           = ext(-84.44092, -75.3003, 33.6829, 36.6461),
                   "ND"           = ext(-104.2708, -96.3075, 45.6403, 49.15),
                   "NE"           = ext(-104.3553, -95.0464, 39.7506, 43.2022),
                   "NH"           = ext(-72.6617, -70.6142, 42.6256, 45.4700),
                   "NJ"           = ext(-75.9175, -73.1892, 38.8944, 41.5806),
                   "NM"           = ext(-109.2942, -102.6383, 31.1892, 37.2000),
                   "NV"           = ext(-120.3358, -113.6803, 34.7356, 42.2981),
                   "NY"           = ext(-80.0867, -71.7381, 40.4828, 45.1692),
                   "OH"           = ext(-85.0439, -80.2464, 38.2797, 42.0217),
                   "OK"           = ext(-103.2850, -94.1964, 33.3839, 37.2850),
                   "OR"           = ext(-124.7294, -116.2949, 41.7150, 46.4612),
                   "PA"           = ext(-80.7672, -74.5033, 39.4694, 42.5094),
                   "RI"           = ext(-71.8628, -71.1206, 41.1463, 42.0188),
                   "SC"           = ext(-83.6422, -78.3275, 31.8814, 35.3811),
                   "SD"           = ext(-104.3553, -96.0806, 42.3050, 46.2050),
                   "TN"           = ext(-90.3239, -81.5047, 34.5578, 37.1125),
                   "TX"           = ext(-107.1592, -93.2411, 25.8614, 36.7200),
                   "UT"           = ext(-114.2925, -108.7450, 36.7778, 42.2347),
                   "VA"           = ext(-83.8322, -75.6200, 36.3892, 39.7886),
                   "VT"           = ext(-73.6747, -71.4108, 42.5886, 45.1956),
                   "WA"           = ext(-124.9585, -116.8364, 45.4554, 49.15),
                   "WI"           = ext(-93.1572, -86.6822, 42.2733, 46.9914),
                   "WV"           = ext(-82.8783, -77.5114, 37.1158, 40.7836),
                   "WY"           = ext(-111.6167, -103.7333, 40.6667, 45.4833))
  return(REGION)
}






# ----- Help to fix bounds after selectiong a region ---------------------------

ext_to_bounds <- function(ext) {
  list(
    west  = ext$xmin,
    south = ext$ymin,
    east  = ext$xmax,
    north = ext$ymax
  )
}






# ----- Function for pest report cards -----------------------------------------

pest_card <- function(id, common, scientific, img) {
  div(
    class = "col-md-4 col-lg-3 mb-4",
    
    card(
      class = "h-100 shadow-sm pest-card",
      style = "cursor:pointer;",
      
      onclick = sprintf("$('#%s').modal('show')", id),
      
      tags$img(
        src = img,
        class = "card-img-top",
        style = "height:180px; object-fit:cover;"
      ),
      
      card_body(
        h5(common, class = "card-title"),
        tags$p(tags$em(scientific), class = "card-text")
      )
    )
  )
}

pest_modal <- function(id, common, scientific, content, img) {
  modal(
    id = id,
    title = HTML(paste0("<b>", common, "</b><br><i>", scientific, "</i>")),
    size = "lg",
    
    tags$img(
      src = img,
      style = "width:100%; max-height:300px; object-fit:contain; margin-bottom:15px;"
    ),
    
    content,
    easyClose = TRUE,
    footer = modalButton("Close")
  )
}

