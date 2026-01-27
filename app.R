# ---------- NOTES -------------------------------------------------------------

# 






# ---------- DDRP Pest Trends Shiny App ----------------------------------------

# Purpose: 

# This app presents results from a proven modeling system to assess the  
  # potential impacts of recent weather trends (1980−2024) on the timing of  
  # pest activities such as emergence, number of generations, and establishment 
  # for 18 major invasive species for the contiguous United States. 






# ---------- Preamble things ---------------------------------------------------

# Packages
source("packages.R")

# Import custom functions
source("functions.R")

# Set-up
source("setup.R")





# ---------- DEFINE USER INTERFACE (UI) ----------------------------------------

ui <- page_navbar(
  
  # For the popover info
  tags$head(
    tags$script(HTML("
    document.addEventListener('mouseover', function (e) {
      const el = e.target.closest('[data-bs-toggle=\"popover\"]');
      if (!el) return;

      if (!bootstrap.Popover.getInstance(el)) {
        new bootstrap.Popover(el);
      }
    });
  "))
  ),
  
  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
    )
  ),
  
  # Ensure footer doesn't overlap the content
  fillable = FALSE,
  
  # Browser window title
  window_title = "DDRP Pest Trends",
  
  # Title
  title = HTML("<b>DDRP Pest Trends in the United States</b>"),
  
  # Theme
  theme = bs_theme(
    bootswatch = "sandstone",
    bg = "#FAFCFF",
    fg = "#434C5E",
    base_font = font_google("Golos Text"),
    heading_font = font_google("Crimson Text")
  ),
  
  # Custom CSS
  tags$head(
    includeCSS("styles.css")
  ),
  
  # Footer
  footer = tags$footer(
    
    style = "
      background-color:#FAFCFF; 
      padding:15px; 
      text-align:center; 
      border-top: 1px solid #ddd;",
    
    # OSU IPM logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "OIPMC.png", height = "50px")),
    
    # APHIS PPQ logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "APHIS_PPQ_logo.png", height = "50px")),
    
    # PRISM logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "PRISM.png", height = "50px")),
    
    # USDA logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "usda-logo_original.png", height = "50px"))
  ),
  
  ##### * Tab 1: About site #####
  
  nav_panel(
    
    title = "About this site",
    
    # Banner image
    tags$img(
      src = "banner.png",
      style = "width:100%;
      max-height:220px;
      object-fit:contain;
      margin-bottom:15px;"
    ),
    
    # Overview
    div(
      class = "p-4 my-3",
      h3(HTML("<b>Overview</b>")),
      
      # Text
      p("We use the Degree-Day, establishment Risk, and Phenological event 
      mapping system (known as DDRP) to assess the potential impacts of weather 
      between 1980 and 2024 on the timing of pest activity such as emergence 
      (phenology) and potential for establishment of 18 invasive pest species in 
      the contiguous United States (Table 1). The system is part of a suite of 
      decision-support tools at ",
        a("USPest.org", href = "https://uspest.org/wea/",
          target="_blank", style="text-decoration:underline;"),
        " that are developed and maintained by the Oregon Integrated Pest 
        Management Center at Oregon State University. These tools provide 
        thousands of end users nationwide with information to support timely 
        and effective management activities for agricultural pests and diseases. 
        This project will use the Degree-Day, establishment Risk, and 
        Phenological event mapping system to predict where pests exhibit earlier 
        activities, increases in the number of generations, and increases in 
        habitat suitability. This information helps Plant Protection and 
        Quarantine allocate survey resources more strategically, thereby 
        reducing the likelihood of pest establishment and spread."
      ),
      
      # Another paragraph
      p("Of the 18 species with models, 12 are presently on Plant Protection and 
      Quarantine’s National Priority Pest List, six were formerly included on 
      the List, and two are Federal Program Pests. Most of the species do not 
      occur in the contiguous United States (N = 13); however, five are 
      established and may spread to additional regions. Real-time forecasts for 
      these pests are available at ",
        a("USPest.org", href = "https://uspest.org/CAPS",
          target="_blank", style="text-decoration:underline;"),
          ".")
    ),
    
    # About
    div(
      class = "p-4 my-3",
      h3(HTML("<b>DDRP Model</b>")),
      
      # Text
      p("The Degree-Day, establishment Risk, and Phenological event mapping system is
     distinct from existing pest decision-support systems in its combination of ",
        tags$ol(
          tags$li(" integrated phenology and habitat suitability mapping to fully
     address both when and where a pest life stage may occur over a year (Fig. 1), "),
          tags$li(" incorporation of biologically meaningful parameters that
     increase model realism in contrast with simple degree-day models, and "),
          tags$li( " inclusion of survival-limiting cold and heat stresses to
     predict habitat suitability over a year, whereas most other systems use
     simpler models based on weather averages (Barker et al. 2020; Grevstad et al.
     2022; Barker et al. 2023).")),
        "Additionally, its ability to accept daily weather
     data for any time frame allows evaluation of historical conditions and impacts
     of weather changes on pest phenology and establishment."
      ),
    ),
    
    # Citations and references
    div(
      class = "p-4 my-3",
      h3(HTML("<b>Suggested citations and references</b>")),
      
      tags$ul(
        tags$li("Barker, B. S., L. Coop, T. Wepprich, F. Grevstad, and G. Cook. 
        2020. Public Library of Science ONE 15:e0244005. ", 
                a("https://doi.org/10.1371/journal.pone.0244005",
                  href = "https://doi.org/10.1371/journal.pone.0244005")),
        tags$li("Barker, B. S., L. Coop, J. J. Duan, and T. R. Petrice. 2023. 
        Frontiers in Insect Science 3:1239173. ", 
                a("https://doi.org/10.3389/finsc.2023.1239173",
                  href = "https://doi.org/10.3389/finsc.2023.1239173")),
        tags$li("Barker, B. S., and L. Coop. 2024. Digger. June 2024, pp. 41−45. 
                Online at: ", 
                a("https://diggermagazine.com/new-tools-to-forecast-boxwood-blight-infection-risk-in-pacific-
northwest-nurseries/",
                  href = "https://diggermagazine.com/new-tools-to-forecast-boxwood-blight-infection-risk-in-pacific-
northwest-nurseries/")),
        tags$li("Takeuchi, Y., A. Tripodi, and K. Montgomery. 2023. Frontiers in 
                Insect Science 3:1198355. ", 
                a("https://doi.org/10.3389/finsc.2023.1198355",
                  href = "https://doi.org/10.3389/finsc.2023.1198355"))
      ),
      
      p(strong("Source code and feedback: "),
        "To view the source code, visit the GitHub repo ",
        a("here",
          href = "https://github.com/bbarker505/DDRP_pest_trends",
          target = "_blank", style = "text-decoration:underline;"),
        "."
      ),
      
      p(strong("Contact: "),
        "For any questions or comments regarding this work, please feel free to
        reach out to Dr. Brittany Barker at ",
        a("brittany.barker@oregonstate.edu",
          href="mailto:brittany.barker@oregonstate.edu"),
        "."
      )
    )
    
  ),
  
  ##### * Tab 2: Map #####
  
  nav_panel(
    
    title = "DDRP Map",
    
    layout_sidebar(
      
      # ----- Controls (Left side) --------------------------------------------
      
      sidebar = sidebar(
        
        # How wide the sidebar is
        width = 320,
        
        h3(HTML("<b>DDRP Map</b>")),
        
        p("Please select an insect pest of interest and then available variables 
          for mapping will be shown."),
        
        # Divider line
        hr(),
        
        p("Due to a large amount of data being plotted, the map may take a few 
          seconds to load."),
        
        hr(),
        
        # Buttons to select pest
        selectInput(
          "pest",
          label = tags$span(h4(HTML("<b>Select insect pest</b>"))),
          choices = c("", sort(unique(raster_lookup$pest))),
          selected = sort(unique(raster_lookup$pest))[1]
        ),
        
        # Buttons to select a sub-region
        selectInput(
          "region",
          label = tags$span(h4(HTML("<b>Select region</b>"))),
          choices = c(
            "Contiguous U.S." = "CONUS",
            "Alabama" = "AL", "Arizona" = "AZ", "Arkansas" = "AR",
            "California" = "CA", "Colorado" = "CO", "Connecticut" = "CT",
            "Florida" = "FL", "Georgia" = "GA",
            "Idaho" = "ID", "Illinois" = "IL", "Indiana" = "IN",
            "Iowa" = "IA", "Kansas" = "KS", "Kentucky" = "KY",
            "Louisiana" = "LA", "Maine" = "ME", "Maryland" = "MD",
            "Massachusetts" = "MA", "Michigan" = "MI", "Minnesota" = "MN",
            "Missouri" = "MO", "Montana" = "MT", "Nebraska" = "NE",
            "Nevada" = "NV", "New Hampshire" = "NH", "New Jersey" = "NJ",
            "New Mexico" = "NM", "New York" = "NY",
            "North Carolina" = "NC", "North Dakota" = "ND",
            "Ohio" = "OH", "Oklahoma" = "OK", "Oregon" = "OR",
            "Pennsylvania" = "PA", "South Carolina" = "SC",
            "South Dakota" = "SD", "Tennessee" = "TN",
            "Texas" = "TX", "Utah" = "UT", "Virginia" = "VA",
            "Washington" = "WA", "Wisconsin" = "WI", "Wyoming" = "WY"
          ),
          selected = "CONUS"
        ),
        
        hr(),
        
        # (Dynamic) To select type of map (show climate or phenology options)
        conditionalPanel(
          
          condition = "input.pest && input.pest !== ''",
          
          radioButtons(
            "var_type",
            label = tags$span(h4(HTML("<b>Select variable type</b>"))),
            choices = c(
              "Climate stress" = "climate",
              "Phenology"      = "phenology"
            ),
            selected = "climate"
          )
        ),
        
        # (Dynamic) Buttons for climate variable
        conditionalPanel(
          
          condition = 
          "input.pest && input.pest !== '' && input.var_type === 'climate'",
          
          radioButtons(
            "clim_variable",
            label = tags$span(h4(HTML("<b>Select climate variable</b>"))),
            choices = c(
              "Cold Stress" = "Cold_Stress",
              "Heat Stress" = "Heat_Stress"
            ),
            selected = "Cold_Stress"
          )
        ),
        
        # (Dynamic) Buttons for phenology
        conditionalPanel(
          
          condition 
          = "input.pest && input.pest !== '' && input.var_type === 'phenology'",
          
          radioButtons(
            "phenology",
            label = tags$span(h4(HTML("<b>Select phenology metric</b>"))),
            choices = c("placeholder" = "placeholder"), 
            selected = "placeholder"
          )
          
        )
        
        # Year range selection
        #selectInput(
        #  "year_range",
        #  label = tags$span(h4(HTML("<b>Select time range</b>"))),
        #  choices = c(
        #    "2001–2010" = "01-10",
        #    "2011–2020" = "11-20",
        #    "1981–2024" = "81-24",
        #    "1981–1990" = "81-90",
        #    "1991–2020" = "91-20"
        #  ),
        #  selected = "81-24"
        #)
      ),
      
      # ------ Visuals (Right side) -------------------------------------------
      
      div(
        
        style = "height: 100%;",
        
        # Map
        div(
          
          # Ensure map fills most of the viewport
          tags$style("#map {height: calc(100vh - 300px) !important;}"),
          
          # To know map is loading
          leafletOutput("map") %>%
            withSpinner(color = "cornflowerblue")
        ),
        
        # Location statistics (under map)
        card(
          
          class = "mt-3",
          card_header(tags$b("Location statistics")),
          
          tags$p("Please click on your location of interest on the map to 
                 trigger the results below."),
          
          div(
            
            class = "p-2",
            
            uiOutput("clicked_latlon"),
            uiOutput("clicked_pest"),
            uiOutput("clicked_variable"),
            
            tags$p(strong("Years:"), " 1991–2020"),
            
            uiOutput("clicked_value"),
            
            uiOutput("clicked_pval"),
  
          )
        )
      ) # end main
    )
  ),
  
  ##### * Tab 3: Pest Reports #####
  
  nav_panel(
    
    title = "Pest Reports",
    
    accordion(
      
      open = "Asian longhorned beetle",
      
      accordion_panel(
        HTML("<b>Asian longhorned beetle</b> (<i>Anoplophora glabripennis</i>)"),
        p("words")
      ),
    
      accordion_panel(
      HTML("<b>Asiatic rice borer</b> (<i>Chilo suppressalis</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Common / Cotton cutworm</b> (<i>Spodoptera litura</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Egyptian cottonworm</b> (<i>Spodoptera littoralis</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Emerald Ash borer</b> (<i>Agrilus planipennis</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>False codling moth</b> (<i>Thaumatotibia leucotreta</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Honeydew moth</b> (<i>Cryptoblabes gnidiella</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Japanese beetle</b> (<i>Popillia japonica</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Japanese pinesawyer beetle</b> (<i>Monochamus alternatus</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Light brown apple moth</b> (<i>Epiphyas postvittana</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Oak ambrosia beetle</b> (<i>Platypus quercivorus</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Old world bollworm</b> (<i>Helicoverpa armigera</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Pine-tree lappet moth</b> (<i>Dendrolimus pini</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Silver Y moth</b> (<i>Autographa gamma</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Small tomato borer</b> (<i>Neoleucinodes elegantalis</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Spotted lanternfly</b> (<i>Lycorma delicatula</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Sunn pest</b> (<i>Eurygaster integriceps</i>)"),
      p("words")
    ),
    
    accordion_panel(
      HTML("<b>Tomato leaf miner</b> (<i>Tuta absoluta</i>)"),
      p("words")
    )
    )
  )
)






# ---------- DEFINE SERVER -----------------------------------------------------

server <- function(input, output, session) {
  
  # Check which variable is selected
  selected_variable <- reactive({
    req(input$pest)
    
    if (input$var_type == "climate") return(input$clim_variable)
    if (input$var_type == "phenology") return(input$phenology)
    NULL
  })
  
  #### * For display purposes ####
  display_name <- reactive({
    
    var <- selected_variable()
    
    variable_labels[var] %||% var
    
  })
  
  #### * Update input selection pane depending on pest selected ####
  observeEvent(input$pest, {
    req(input$pest)
    
    # Filter lookup table for selected pest & fixed year
    available_vars <- raster_lookup %>%
      filter(pest == input$pest, year_range == "91-20") %>%
      pull(variable) %>%
      unique()
    
    # Keep only phenology variables
    phenology_vars <- intersect(available_vars, names(variable_labels)[3:5])
    
    # Update phenology radio buttons
    if (length(phenology_vars) > 0) {
      choices <- phenology_vars
      names(choices) <- variable_labels[phenology_vars]
      
      updateRadioButtons(
        session,
        "phenology",
        choices = choices,
        selected = phenology_vars[1]
      )
    }
    
  })
  
  
  
  #### * Collect Kendall's tau raster ####
  pest_raster_tau <- reactive({
    req(input$pest, selected_variable())
    
    row <- raster_lookup %>%
      filter(pest == input$pest,
             variable == selected_variable(),
             year_range == "91-20")
    
    validate(need(nrow(row) == 1, "No raster found"))
    
    rast_import_tau(row$file_path)
  })
  
  #### * Collect p-value raster ####
  pest_raster_pval <- reactive({
    req(input$pest, selected_variable())
    
    row <- raster_lookup %>%
      filter(pest == input$pest,
             variable == selected_variable(),
             year_range == "91-20")
    
    validate(need(nrow(row) == 1, "No raster found"))
    
    rast_import_pval(row$file_path)
  })
  
  #### * Initial map plotted ####
  output$map <- renderLeaflet({
    
    # Require inputs
    req(input$pest, selected_variable())
    
    # Plot map
    produce_map(input, pest_raster_tau(),
                north = north, south = south,
                east = east, west = west)
  })
  
  #### * Update map when pest changes ####
  observeEvent(list(input$pest, input$var_type, input$clim_variable, input$phenology), {
    
    # Require change in inputs
    req(pest_raster_tau())
    
    # Update legend color palette
    pal <- make_palette(pest_raster_tau())
    
    # Update map
    #leafletProxy("map") %>%
    #  clearImages() %>%
    #  addRasterImage(raster(pest_raster_tau()),
    #                 opacity = 0.65,
    #                 layerId = "Value")
    
    leafletProxy("map") %>%
      clearImages() %>%
      clearControls() %>% 
      addRasterImage(
        raster(pest_raster_tau()),
        colors = pal,
        opacity = 0.65,
        layerId = "Value"
      ) %>%
      addLegend(
        position = "bottomright",
        pal = pal,
        values = terra::values(rast),
        title = "Kendall’s τ",
        labFormat = labelFormat(digits = 2)
      )
    
  })
  
  #### * Settings on map bounds (prevent over-zooming) ####
  
  # Observe bounds of current map in order to
  # keep the bounds from resetting when map selected changes
  
  observeEvent(input$map_bounds, {
    
    # Map zoom can't be entire area (level 6) or get weird behavior
    # (non-stop loop of zooming) when select risk maps multiple times
    bounds <- input$map_bounds
    mapzoom <- input$map_zoom
    
    # Keep bounds from resetting
    if (mapzoom > 6) {
      
      # Update map
      leafletProxy("map") %>%
        fitBounds(bounds$west, bounds$south, bounds$east, bounds$north)
      
    }
  })
  
  #### * Adjust to another region when selected ####
  observeEvent(input$region, {
    
    req(input$region)
    
    # Get extent from your helper
    ext <- assign_extent(input$region)
    
    # Fix bounds
    bounds <- ext_to_bounds(ext)
    
    # Adjust map
    leafletProxy("map") %>%
      fitBounds(
        lng1 = xmin(ext),
        lat1 = ymin(ext),
        lng2 = xmax(ext),
        lat2 = ymax(ext)
      )
  })
  
  
  #### * Panel that holds location click outputs ####
  observeEvent(input$map_click, {
    
    # Require inputs
    req(input$map_click, pest_raster_tau(), pest_raster_pval())
    
    # Store click info
    click <- input$map_click
    
    # Store coordinates
    xy <- data.frame(x = click$lng, y = click$lat)
    
    # Get test statistic
    tau_val <- terra::extract(pest_raster_tau(), xy)[1,2]
    
    # Get p-value
    pval_val <- terra::extract(pest_raster_pval(), xy)[1,2]
    
    # Coordinates
    output$clicked_latlon <- renderUI({
      tags$div(tags$b("Coordinates:"), 
               round(click$lat, 4), ", ", round(click$lng, 4))
    })
    
    # Pest
    output$clicked_pest <- renderUI({
      tags$div(tags$b("Pest:"), input$pest)
    })
    
    # Variable
    output$clicked_variable <- renderUI({
      var <- selected_variable()
      display_name <- variable_labels[var] %||% var %||% "Not available"
      tags$div(tags$b("Variable:"), display_name)
    })
    
    # Kendall's tau statistic
    output$clicked_value <- renderUI({
      tags$div(
        tags$b("Kendall’s Tau:"), " ", round(tau_val, 3), " ",
        tags$span(
          tags$i(class = "bi bi-info-circle"),
          style = "cursor:pointer;",
          `data-bs-toggle` = "popover",
          `data-bs-trigger` = "click",
          `data-bs-placement` = "right",
          `data-bs-html` = "true",
          title = "About the statistic",
          `data-bs-content` = HTML(
            'The Mann–Kendall tau statistic describes whether a trend is 
            monotonic (e.g. the proportion of "upward" changes against time 
            versus the proportion of "downward" changes against time, for all 
            pairwise differences). <br><br>
            Positive values (0 &lt; &tau; &lt; 1) indicate an upward trend.
            <br><br>
            Negative values (-1 &lt; &tau; &lt; 0) indicate a downward trend.'
          )
        )
      )
    })
    
    # P-value
    output$clicked_pval <- renderUI({
      tags$div(
        tags$b("P-value:"), signif(pval_val, 3),
      tags$span(
        tags$i(class = "bi bi-info-circle"),
        style = "cursor:pointer;",
        `data-bs-toggle` = "popover",
        `data-bs-trigger` = "click",
        `data-bs-placement` = "right",
        `data-bs-html` = "true",
        title = "About the p-value",
        `data-bs-content` = HTML(
          "The p-value describes the strength of evidence we have on the 
          presence of this trend. <br><br> Generally, 0.05 is considered the 
          threshold and values less than this suggest there is evidence of a
          trend (with those tending towards 0 suggesting stronger evidence). 
          <img src='pval_chart.png' style='width:100%; max-width:200px; 
          height:auto; display:block; margin-top:5px;' />"
        )
      )
      )
    })
  })
  
  #### * Clear absolutePanel() when pest / variable changes ####
  observeEvent(list(input$var_type, input$clim_variable, input$phenology), {
    
    output$clicked_latlon   <- renderUI(NULL)
    output$clicked_pest     <- renderUI(NULL)
    output$clicked_variable <- renderUI(NULL)
    output$clicked_value    <- renderUI(NULL)
    output$clicked_pval     <- renderUI(NULL)
    
  })
  
  
} # END OF SERVER




# ---------- RUN APP -----------------------------------------------------------

shinyApp(ui = ui, server = server)
