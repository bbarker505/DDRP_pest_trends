# ----- ABOUT ------------------------------------------------------------------

# Contains custom functions to be loaded into the app.R file

# ----- Make the pest panels for UI --------------------------------------------
# Formats the species titles, descriptions, and reports and images for UI
make_pest_panel <- function(
    common_name,
    scientific_name,
    abbreviation,
    description,
    image_file,
    photo_credit
) {
  
  accordion_panel(
    
    # Plus icon with species name
    value = "species",
    title = tagList(
      bs_icon("plus-circle"),
      HTML(
        paste0(
          "<b>", common_name, "</b> ",
          "(<i>", scientific_name, "</i>)"
        )
      )
    ),
    
    layout_columns(
      
      # Left column
      div(
        
        style = "font-size: 14px;",
        
        p(description),
        
        tags$div(style = "margin-top: 2px;"),
        
        tags$a(
          href = "#",
          paste0("Download PDF report for ", abbreviation),
          target = "_blank",
          style = "text-decoration: underline;"
        )
        
      ),
      
      # Right column
      div(
        
        style = "width:160px; margin:auto;",
        
        tags$img(
          src = image_file,
          style = "width:100%; max-width:150px;
                 border-radius:8px;"
        ),
        
        tags$p(
          photo_credit,
          style = "font-size:9px; color:#666;
                 margin-top:4px;
                 margin-bottom:0px;
                 text-align:left;
                 line-height:1;"
        )
        
      ),
      
      col_widths = c(10, 2)
      
    )
  )
  
}

# ----- Function to import outputs (rasters) -----------------------------------
# 1 = Tau statistic, 2 = Sen's slope, 3 = p-value
# rast_import <- function(file, layer = 1) {
#   key <- paste0(file, "_", layer)
#   if (!exists(key, envir = .raster_cache)) {
#     r <- terra::rast(file)[[layer]]
#     assign(key, r, envir = .raster_cache)
#   }
#   get(key, envir = .raster_cache)
# }
# Base loading function
raw_rast_import <- function(file, layer = 1) {
  terra::rast(file)[[layer]]
}

# Automatically wraps the loading function in a managed in-memory cache
rast_import <- memoise::memoise(raw_rast_import)

# Helper to convert terra extent to a list of numeric bounds
ext_to_list <- function(ext) {
  list(
    north = as.numeric(terra::ymax(ext)),
    south = as.numeric(terra::ymin(ext)),
    east  = as.numeric(terra::xmax(ext)),
    west  = as.numeric(terra::xmin(ext))
  )
}

# An alias often used in the region observer
ext_to_bounds <- ext_to_list

# ----- Produce a color palette ------------------------------------------------

# Helper function to generate a colorNumeric palette
gen_pal <- function(pal, limits) {
  pal <- colorNumeric(
    palette = pal, domain = limits, na.color = "transparent")
}

# Make the reactive palette
make_palette <- function(rast, metric) {
  
  # Palette for maps for iniviual spe3cies
  #sp_pal <-  scico::scico(100, palette = "vik")
  sp_pal <- colorRampPalette(
    c("#053061","#2166AC","#67A9CF","#FFF7BC","#EF8A62","#D73027","#67001F")
    )(100)
  comp_pal <- "viridis"
  #rb_pal <- rev(RColorBrewer::brewer.pal(11, "RdBu"))
  
  if (is.null(rast)) return(NULL)
  
  is_comparison <- grepl("species_num", metric)
  
  # Spp. comparison maps
  if (is_comparison) {
    # Continuous scale for species counts (0 to 18)
    limits <- c(0, 18)
    pal <- gen_pal(comp_pal, limits)
  } else if (metric == "tau") {
    limits <- c(-1, 1)
    pal <- gen_pal(sp_pal, limits)
    # Individual species maps
  } else if (metric == "sens") {
    # Use minmax for speed and to prevent crashes
    mm <- as.vector(terra::minmax(rast))
    max_abs <- max(abs(mm), na.rm = TRUE)
    if (is.infinite(max_abs) || max_abs == 0) max_abs <- 0.1
    limits <- c(-max_abs, max_abs)
    pal <- gen_pal(sp_pal, limits)
  } else {
    limits <- c(0, 1)
    pal <- gen_pal(comp_pal, limits)
  }
  
  list(pal = pal, limits = limits)
}

# ----- Consolidated legend builder --------------------------------------------
create_legend_html <- function(metric, title, pal, limits) {
  is_comparison <- grepl("species_num", metric)
  
  if (is_comparison) {
    # 1. Generate colors for the gradient bar
    grad_colors <- paste(pal(seq(0, 18, length.out = 50)), collapse = ",")
    
    # 2. Generate the numeric labels first
    ticks <- seq(0, 18, by = 2)
    
    # 3. Create the HTML string for labels
    # We use flexbox to ensure they spread evenly across the 240px width
    tick_labels <- paste0("<span style='flex: 1; text-align: center;'>", ticks, "</span>", collapse = "")
    
    # 4. Now the sub() function will work because tick_labels exists
    tick_labels <- sub("<span>18</span>$", "<span>18</span>", tick_labels)
    
    paste0(
      "<div style='background:white;padding:8px 10px;border-radius:6px;box-shadow:0 0 5px rgba(0,0,0,0.2);'>",
      "<div style='text-align:center;font-weight:bold;margin-bottom:4px;'>", title, "</div>",
      "<div style='width:240px;height:14px;border:1px solid #ccc;background:linear-gradient(to right,", grad_colors, ");'></div>",
      "<div style='display:flex;justify-content:space-between;font-size:9px;margin-top:2px;'>",
      tick_labels,
      "</div>",
      "<div style='text-align:right; font-size:9px; margin-top:2px;'>",
      "</div></div>"
    )
  } else {
    # Continuous gradient for Trends (Tau/Sens)
    paste0(
      "<div style='background:white;padding:8px 10px;border-radius:6px;box-shadow:0 0 5px rgba(0,0,0,0.2);'>",
      "<div style='text-align:center;font-weight:bold;margin-bottom:4px;'>", title, "</div>",
      "<div style='width:160px;height:14px;border:1px solid #ccc;background:linear-gradient(to right,",
      paste(pal(seq(limits[1], limits[2], length.out = 50)), collapse = ","),
      ");'></div>",
      "<div style='display:flex;justify-content:space-between;font-size:11px;margin-top:2px;'>",
      "<span>", round(limits[1], 2), "</span><span>0</span><span>", round(limits[2], 2), "</span>",
      "</div></div>"
    )
  }
}

# ----- Mask out non-significant areas -----------------------------------------
mask_by_pval <- function(value_rast, pval_rast, threshold = 0.1) {
  # Ensure alignment (important if rasters differ slightly)
  if (!terra::compareGeom(value_rast, pval_rast, stopOnError = FALSE)) {
    pval_rast <- terra::resample(pval_rast, value_rast)
  }
  
  # Apply mask (fast, vectorized)
  value_rast[pval_rast > threshold] <- NA
  
  return(value_rast)
}

# Apply p-value mask 
apply_sig_mask <- function(r, pval, sig_only) {
  
  # No masking requested
  if (is.null(pval) || !isTRUE(sig_only)) {
    return(r)
  }
  
  # Apply significance mask
  mask_by_pval(
    value_rast = r,
    pval_rast = pval,
    threshold = 0.1
  )
  
}

# ----- Initial map render setup -----------------------------------------------
produce_map_base <- function(bounds) {
  leaflet(
    options = leafletOptions(
      attributionControl = FALSE, 
      zoomControl = TRUE,
      minZoom = 4.75, # min zoom = CONUS
      zoomSnap = 0.25, 
      zoomDelta = 0.25,
      # Prevent zooming when clicking a location 
      doubleClickZoom = FALSE,
      # Prevents the user from panning away from North America
      maxBounds = list(c(bounds$south, bounds$west), 
                       c(bounds$north, bounds$east)),
      maxBoundsViscosity = 1.0
    )
  ) %>% 
    # Map tiles
    addProviderTiles(providers$CartoDB.Positron) %>% 
    #addProviderTiles(providers$CartoDB.Voyager) %>%
    # Fit the initial view to the provided bounds (CONUS)
    fitBounds(lng1 = bounds$west, lat1 = bounds$south, 
              lng2 = bounds$east, lat2 = bounds$north) %>%
    setMaxBounds(lng1 = bounds$west, lat1 = bounds$south, 
              lng2 = bounds$east, lat2 = bounds$north) %>% 
    # Always-on State Boundaries
    addPolylines(
      data = us_states, # Assumes this object is loaded in setup.R
      opacity = 0.6, 
      color = "#444444", 
      weight = 1.2, 
      group = "States"
    ) %>%
    # County Boundaries (hidden unless zoom > 6.5)
    addPolylines(
      data = us_counties, # Assumes this object is loaded in setup.R
      opacity = 0.4, 
      color = "#777777", 
      weight = 0.5, 
      group = "Counties"
    ) 
}

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

# ----- Additional spatial features in map -------------------------------------

# Create polygon for CLM raster for map to make more visible
create_clm_outline <- function(clm_raster) {
  
  # Create binary raster from non-NA cells
  clm_mask <- terra::ifel(
    !is.na(clm_raster),
    1,
    NA
  )
  
  # Create polygon from non-NA raster cells
  clm_poly <- terra::as.polygons(
    clm_mask,
    dissolve = TRUE,
    na.rm = TRUE
  )
  
  # Convert to sf, project, and create a polyline
  clm_poly_sf <- st_as_sf(clm_poly) %>% 
    st_transform(crs = 4326) %>% 
    st_boundary(.)
  
}

# Apply boundary visibility when map is zoomed to >= 6.5
apply_boundary_visibility <- function(map, zoom_level) {
  
  if (is.null(zoom_level)) return(map)
  
  if (zoom_level >= 6.5) {
    map %>%
      showGroup("Counties") 
  } else {
    map %>%
      hideGroup("Counties") %>%
      showGroup("States")
  }
}


# ----- Functions for location-based plots -------------------------------------

# For generating labels for location-based plots for species comparisons 
assign_comparison <- function(comparison_metric) {
  switch(comparison_metric,
         "species_num_adult" = "Earlier adult emergence",
         "species_num_egg"   = "Earlier egg hatch",
         "species_num_cold"  = "Decreasing cold stress",
         "species_num_heat"  = "Increasing heat stress",
         "Species comparison")
}

# Helper function for "check_na" to check for NA values at a map location
inside_us_states <- function(xy) {
  
  click_sf <- sf::st_as_sf(
    data.frame(
      x = xy$x,
      y = xy$y
    ),
    coords = c("x", "y"),
    crs = sf::st_crs(us_states)
  )
  
  inside_us <- lengths(
    sf::st_intersects(click_sf, us_states)
  ) > 0
  
}

# Check for NA values on clicked location 
# Return messaged depends on nature of NA value (if inside vs. outside US)
check_NA <- function(xy, site_data, is_comparison) {
  
  inside_us <- inside_us_states(xy)
  #is_comparison <- isTRUE(is_comparison)
  
  if (!inside_us) {
    validate(need(FALSE, "No data available for this location"))
    return(NULL)
  }
  
  # No raster values
  if (
    is.null(site_data) ||
    nrow(site_data) == 0 ||
    all(is.na(site_data$value))
  ) {
    
    validate(
      need(
        FALSE,
        if (is_comparison) {
          "No significant trends at this location for any species"
        } else {
          "No predicted phenological event for this location"
        }
      )
    )
    
    return(NULL)
    
  }
  
}

# Plot themes

# Individual species
custom_theme_indiv <- theme(
  axis.text.x = element_text(size = 14, angle = 60, hjust = 1),
  axis.text.y = element_text(size = 14),
  plot.title = element_text(size = 16, face = "bold"),
  axis.title = element_text(size = 16, face = "bold"))

# Comparison
custom_theme_comp <- theme(
  axis.text = element_text(size = 14),
  plot.title = element_text(size = 16, face = "bold"),
  axis.title = element_text(size = 16, face = "bold"))