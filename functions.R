# Last modified: 11 October 2025

# ----- ABOUT ------------------------------------------------------------------

# Contains custom functions to be loaded into the app.R file





# ----- Function to import outputs (rasters) -----------------------------------

# The Mann-Kendall test has some values that we're interested in

rast_import <- function(file_name, layer) {
  
  r <- rast(file_name)
  
  # Select desired layer
  r <- r[[layer]]
  
  # Reproject to WGS84
  r <- project(r, "EPSG:4326")
  
  return(r)
}

rast_import_pval <- function(file_name) {
  
  # Pull in file as Spatraster
  rast_stack <- rast(file_name)
  
  # Select layer containing p-values
  rast <- rast_stack$Pval
  
  # Reproject to WGS84
  rast <- project(rast, "EPSG:4326")
  
  return(rast)
  
}






# ----- Produce a leaflet map showing risk of infection ------------------------

# Color palette for map
make_palette <- function(rast, metric) {
  
  vals <- terra::values(rast, na.rm = TRUE)
  
  # Define symmetric limits
  limits <- switch(
    metric,
    "tau"  = c(-1, 1),
    "sens" = {
      max_abs <- max(abs(vals))
      c(-max_abs, max_abs)
    }
  )
  
  pal <- colorNumeric(
    palette  = rev(RColorBrewer::brewer.pal(11, "RdBu")),
    domain   = limits,
    na.color = "transparent"
  )
  
  list(
    pal    = pal,
    limits = limits
  )
}


produce_map <- function(rast, bounds, metric, legend_title) {
  
  layerID <- "Value"
  
  pal_obj <- make_palette(rast, metric)
  
  pal    <- pal_obj$pal
  limits <- pal_obj$limits
  
  leaflet(
    options = leafletOptions(
      attributionControl = FALSE,
      zoomControl = FALSE,
      minZoom = 4.75,
      zoomSnap = 0.25,
      zoomDelta = 0.25,
      maxBounds = list(
        c(bounds$south, bounds$west),
        c(bounds$north, bounds$east)
      ),
      maxBoundsViscosity = 1.0
    )
  ) %>%
    htmlwidgets::onRender("
      function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this);
      }
    ") %>%
    addProviderTiles(providers$CartoDB.Voyager) %>%
    addRasterImage(
      rast,
      colors  = pal,
      opacity = 0.8,
      layerId = layerID
    ) %>%
    addControl(
      html = HTML(paste0(
        "<div style='background:white;padding:8px 10px;border-radius:6px;'>",
        "<div style='text-align:center;font-weight:bold;margin-bottom:4px;'>",
        legend_title,
        "</div>",
        
        "<div style='display:flex;flex-direction:column;align-items:center;'>",
        
        # gradient bar
        "<div style='width:160px;height:14px;border:1px solid #ccc;",
        "background:linear-gradient(to right,",
        paste(pal(seq(limits[1], limits[2], length.out = 50)), collapse = ","),
        ");'></div>",
        
        # labels
        "<div style='display:flex;justify-content:space-between;",
        "width:160px;font-size:11px;margin-top:2px;'>",
        "<span>", round(limits[1],2), "</span>",
        "<span>0</span>",
        "<span>", round(limits[2],2), "</span>",
        "</div>",
        
        "</div></div>"
      )),
      position = "bottomright"
    ) %>%
    addPolylines(
      data = county_sf,
      options = pathOptions(interactive = FALSE),
      group  = "Counties",
      opacity = 0.1,
      color  = "grey",
      weight = 1.25
    ) %>%
    addPolylines(data = us_states,
                 options = pathOptions(interactive = FALSE),
                 group  = "Counties",
                 opacity = 0.5,
                 color  = "grey",
                 weight = 1.25
    ) %>%
    setView(
      lng  = mean(c(bounds$west, bounds$east)),
      lat  = mean(c(bounds$south, bounds$north)),
      zoom = 4.75
    ) %>%
    addMouseCoordinates
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

assign_extent <- function(region_param) {
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






