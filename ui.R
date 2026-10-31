# ---------- DEFINE USER INTERFACE (UI) ----------------------------------------

# User interface for DDRP Pest Trends app 

# R Shiny Server requires packages, raster lookup and functions to be loaded here
source("packages.R")

# Raster lookup
source("create_raster_lookup.R")

# Import custom functions
source("functions.R")

# User interface for DDRP Pest Trends app
ui <- page_navbar(
  
  useShinyjs(),
  
  # For the popover info
  tags$head(
  
    # Info message bubbles
    tags$style(HTML("
    .tooltip .tooltip-inner {
      font-size: 18px !important;
      padding: 10px 14px !important;
      max-width: 350px !important;
    }
  ")),
    
    # Mouseover
    tags$script(HTML("
    document.addEventListener('mouseover', function (e) {
      const el = e.target.closest('[data-bs-toggle=\"popover\"]');
      if (!el) return;
  
      if (!bootstrap.Popover.getInstance(el)) {
        new bootstrap.Popover(el);
      }
    });
  
    // Close popovers when a new metric is selected
    document.addEventListener('change', function (e) {
      if (e.target.id === 'clim_variable' ||
          e.target.id === 'phenology') {
  
        document.querySelectorAll('[data-bs-toggle=\"popover\"]').forEach(function (el) {
          const popover = bootstrap.Popover.getInstance(el);
          if (popover) {
            popover.hide();
          }
        });
      }
    });
  ")),
  
    # Icons
    tags$link(
      rel = "stylesheet",
      href = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
    ),
    
  # Capture map center and zoom
  tags$script(HTML("
      $(document).on('shiny:connected', function() {
        var map = $('#map').data('leaflet-map');
        
        if (map) {
          map.on('moveend', function() {
            var center = map.getCenter();
            
            Shiny.setInputValue('map_center', {
              lat: center.lat,
              lng: center.lng
            });
            
            Shiny.setInputValue('map_zoom', map.getZoom());
          });
        }
      });
    "))
  ),

  # Ensure footer doesn't overlap the content
  fillable = FALSE,
  
  # Browser window title
  window_title = "DDRP Pest Trends",
  
  # Title
  title = HTML("<b>DDRP Pest Trends in the United States</b>"),
  
  # Theme
  theme = bs_theme(
    bootswatch = "minty",
    bg = "#FAFCFF",
    fg = "#434C5E",
    base_font = font_google("Golos Text")
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
    
    # USDA logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "usda-logo_original.png", height = "50px")),
    
    # APHISlogo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "APHIS.png", height = "50px")),
    
    # NIFA logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "NIFA.png", height = "60px")),
    
    # OSU ARF logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "arf-logo.png", height = "50px")),
    
    # PRISM logo
    div(style = "display:inline-block; margin: 0 15px;",
        tags$img(src = "PRISM.png", height = "50px"))
    
  ),
  
  # Tab 1: About site ----
  
  # HTML code for allowing species table to open when clicked in Overview tab
  tags$script(HTML("
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('a[href=\"#species\"]').forEach(function(link) {
      link.addEventListener('click', function() {
        setTimeout(function() {
          const title = document.getElementById('species');
          if (!title) return;
          const accordionItem = title.closest('.accordion-item');
          if (!accordionItem) return;
          const button = accordionItem.querySelector('.accordion-button');
          if (button && button.classList.contains('collapsed')) {
            button.click();
          }
        }, 100);
      });
    });
  });
")),
  
  # Opens up reference section when citation clicked
  tags$script(HTML("
    document.addEventListener('DOMContentLoaded', function () {
      document.querySelectorAll('a[href^=\"#ref_\"]').forEach(function(link) {
        link.addEventListener('click', function(e) {
          e.preventDefault();
          const targetId = this.getAttribute('href').substring(1);
          const refPanel = document.getElementById('references_panel');
          if (!refPanel) return;
            const accordionItem = refPanel.closest('.accordion-item');
          if (!accordionItem) return;
            const button = accordionItem.querySelector('.accordion-button');
          if (button && button.classList.contains('collapsed')) {
            button.click();
          }
          setTimeout(function() {
            const target = document.getElementById(targetId);
          if (target) {
            target.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          });
        }
      }, 250);
    });
  });
});
")),
  
  # Landing page - About this site
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
      
      class = "p-4 my-1",
      
      h3(HTML("<b>Overview</b>")),
      
      p(style = "margin-bottom: 8px;",
        "Here, we use the ", 
        a("DDRP platform", href = "https://uspest.org/DDRP",
          target="_blank", style="text-decoration:underline;"), 
      " to assess the potential impacts of weather changes from 1981 to the 
      current year on the timing of pest activities, such as spring emergence 
      (phenology) and potential for establishment of ", 
        a("18 invasive pest species", href = "#species"),
      " in the contiguous United States (CONUS). Recent weather trends are 
      likely promoting overwintering survival and increasing developmental 
      rates of invasive insects, allowing some to expand their range, emerge 
      earlier, and attain higher densities over a longer growing season. 
      Model products available on this app can inform strategic planning by 
      the USDA Plant Protection and Quarantine’s (PPQ) and state agencies in 
      terms of both when and where to conduct pest surveillance. For example, 
      a trend towards the earlier appearance of adult insects may indicate that 
      monitoring traps should be installed earlier in the season, whereas areas 
      that are becoming increasingly suitable for pest establishment should be 
      prioritized for surveillance. Allocating survey resources more 
      strategically may reduce the likelihood of pest establishment and spread, 
      thereby incrasing the productivity of U.S. farms, rangelands, and forests.")
    
      ), # end overview
      
      accordion(
        
        open = FALSE,
        
        tags$style(HTML("
        .accordion-body {
        padding-top: 10px !important;
        padding-bottom: 10px !important;
        }

        .accordion-body p {
        margin-top: 6px !important;
        margin-bottom: 10px !important;
        line-height: 1.35 !important;
        }
      ")),
        
        ##### * Species #####
        accordion_panel(
          value = "species",
          title = div(
            id = "species",
            tagList(bs_icon("plus-circle"), strong("Species")
            )
          ),
          status = "info",
          tagList(
            p("The 18 species with DDRP models are shown below. Five species 
            are established in CONUS, 12 are on PPQ's ",
              a("National Priority Pest List", 
                href = "https://approvedmethods.ceris.purdue.edu/", 
                target="_blank", style="text-decoration:underline;"),
              ", six were formerly included on the list, and two are Federal 
                Program Pests."),
            tableOutput("species_table")
          )
        ), # end species table
        
     ##### * Instructions for use #####
     accordion_panel(
       
       value = "instructions",
       title = tagList(bs_icon("plus-circle"), strong("Instructions for Use")),
         
         p("The 'DDRP Maps' page delivers predictions of how long-term weather
         changes may impact the the timing of pest activities, climate 
         suitability, and the potential distribution of the 18 species. The
         'Pest reports' page provides reports that present the major results for
         each species and their potential applications for surveillance. The 
         tutorial below describes app usage, explains the different map 
         types, and provides guidance on how to interpret maps. Note that this 
         app requires an internet connection and will therefore not work in 
         airplane or off-line mode."),
         
         div(
           class = "text-left my-4",
           tags$a(
             href = "reports/tutorial.html",
             target = "_blank",
             class = "btn btn-primary btn-md",
             icon("book-open"),
             " View App Tutorial"
           )
         )
     ), # end instructions
   
   ##### * About DDRP #####
   accordion_panel(
     
     value = "DDRP",
     title = tagList(bs_icon("plus-circle"), strong("About DDRP")),
     
     p("DDRP is part of a suite of decision-support tools at ",
       a("USPest.org", href = "https://uspest.org/wea/",
         target="_blank", style="text-decoration:underline;"),
       " that are developed and maintained by the ", 
       a("Oregon IPM Center", href = "https://agsci.oregonstate.edu/oipmc",
         target="_blank", style="text-decoration:underline;"), 
       " at Oregon State University. These tools provide thousands of end users 
       nationwide with information to support timely and effective management 
       activities for agricultural pests and diseases. The ", 
       a("homepage for DDRP", href = "https://uspest.org/CAPS",
         target="_blank", style="text-decoration:underline;"), 
       " provides near-real time forecasts for the 18 pest species as well as
       spreadsheets, technical reports, and peer-reviewed publications 
       associated with the models."),
     
     p("Details on the mechanics of DDRP are presented in ",
       a("Barker et al. (2020)", href = "#ref_barker2020"), 
     " Briefly, DDRP uses a process-based modeling approach in which degree-days 
     and climate stress are calculated daily and accumulate over time to model 
     phenology and climatic suitability, respectively. Figure 1 in ",
     a("Barker et al. (2023)", href = "#ref_barker2023"),
     " provides a schematic of the DDRP model for the emerald ash borer", 
     HTML("<i>Agrilus planipennesis</i>."), "Required inputs for modeling include 
     gridded daily minimum and maximum temperature data. The phenology model
     includes one phenological event each for five life stages: the overwintering
     stage, egg, larva, pupa, and adult. To model the potential distribution 
     of a pest, DDRP compares estimates of climate stress accumulations to 
     user-defined moderate and severe stress limits. Moderate stress may 
     inhibit long-term establishment, in which short-term (one complete year) 
     establishment may occur only during favorable years, whereas areas under 
     severe stress would likely prevent even short-term establishment. 
     Areas excluded by moderate stress may also be used to 
     communicate uncertainty in the potential for establishment.")
     ),
     
      ##### * Source code and feedback #####
      accordion_panel(
        
        value = "source_code",
        title = tagList(bs_icon("plus-circle"), strong("Source code")),
        
        p("The source code and raw outputs of this project are available on ",
          a("GitHub.",
            href = "https://github.com/bbarker505/DDRP_pest_trends",
            target = "_blank",
            style = "text-decoration:underline;"
          ), "Source code and model parameter files used for modeling are 
          available in the ",
          a("GitHub repo for DDRP.",
            href = "https://github.com/bbarker505/ddrp_v3",
            target = "_blank",
            style = "text-decoration:underline;")
        )
     ), # end source code
     
      ##### * Contact #####
      accordion_panel(
        
        value = "contact",
        title = tagList(bs_icon("plus-circle"), strong("Contact")),
        
        p(
          "Please feel free to reach out to ",
          tags$a(
            href = "mailto:brittany.barker@oregonstate.edu",
            "Dr. Brittany Barker"
          ),
          " for any questions or comments regarding the project or app.")
        ), # end contact
    
      ##### * Acknowledgements #####
      accordion_panel(
        
        value = "acknowledgements",
        title = tagList(bs_icon("plus-circle"), strong("Acknowledgements")),
        
        p("Funding for this project was provided by the USDA's National 
          Institute of Food and Agriculture, the PPQ Plant Protection Act 7721
          program, and OSU's Agricultural Research Fund. The web application 
          was developed using the ",
          a("Shiny package for R",
            href = "https://shiny.posit.co/",
            target = "_blank",
            style = "text-decoration:underline;"),
          a("(Chang et al. 2026).", href = "#ref_chang2026"),
          " We would like to thank the developers at Posit (formerly RStudio) 
          and the broader R community for providing the open-source tools that 
          powered this project. Portions of the code were developed with 
          assistance from ChatGPT", 
          a("(OpenAI 2026).", href = "#ref_chatgpt2026")
          ) # end acknowledgements
      ),
    
      ##### * References #####
      accordion_panel(
        
        value = "references",
        title = div(
          id = "references_panel",
          tagList(
            bs_icon("plus-circle"),
            strong("References")
          )
        ),
        
        div(
          
          class = "references",
          
          div(
            
            style = "padding-left: 2em;text-indent: -2em;margin-bottom: 0.8em;",
            id = "ref_barker2020",
            class = "reference-entry",
            
            "Barker, B. S., L. Coop, T. Wepprich, F. Grevstad, and G. Cook. 2020. DDRP: real-time phenology and climatic suitability modeling of invasive insects. PLoS ONE 15:e0244005.",
            
            a("https://doi.org/10.1371/journal.pone.0244005",
              href = "https://doi.org/10.1371/journal.pone.0244005"
            )
          ),
          
          div(
            
            style = "padding-left: 2em;text-indent: -2em;margin-bottom: 0.8em;",
            id = "ref_barker2023",
            class = "reference-entry",
            
            "Barker et al. 2023. An integrative phenology and climatic suitability model for emerald ash borer. Frontiers in Insect Science 3:1239173 Frontiers in Insect Science 3:1239173.",
            
            a("https://doi.org/10.3389/finsc.2023.1239173",
              href = "https://doi.org/10.3389/finsc.2023.1239173"
            )
          ),
          
          div(
            
            style = "padding-left: 2em;text-indent: -2em;margin-bottom: 0.8em;",
            id = "ref_chang2026",
            class = "reference-entry",
            
          "Chang, W., J. Cheng, J. J. Allaire, C. Sievert, et al. 2026. shiny: Web Application Framework for R. R package version 1.13.0.9000.",
            
            a("https://github.com/rstudio/shiny",
              href = "https://github.com/rstudio/shiny"
            )
          ),
          
          div(
            style = "padding-left: 2em;text-indent: -2em;margin-bottom: 0.8em;",   
            id = "ref_chatgpt2026",
            class = "reference-entry",
            
            "OpenAI. 2026. ChatGPT (GPT-5.5, May 27 version) [Large language model].",
            
            a(
              "https://chat.openai.com/chat/",
              href = "https://chat.openai.com/chat/"
            )
          ),
          
          div(style = "padding-left: 2em;text-indent: -2em;margin-bottom: 0.8em;")
        )
      )
    )
  ),
  
  # Tab 2: Map ----
  nav_panel(
    
    title = "DDRP Map",
    
    layout_sidebar(
      
      # ----- Controls (Left side) --------------------------------------------
      
      sidebar = sidebar(
        
        # How wide the sidebar is
        width = 320,
        
        h3(HTML("<b>DDRP Map</b>")),
        
        # Words
        p("Due to a large amount of data being plotted,
          the map may take a few seconds to load."),
        
        ##### * Select pest #####
        selectInput(
          "pest",
          label = tags$span(h4(HTML("<b>Select insect pest</b>"))),
          choices = c("All species (comparisons)" = "All 18 spp", 
                      sort(unique(raster_lookup$common_name))),
          # CHANGE THIS:
          selected = "Asian longhorned beetle"
        ),
        
        ##### * Select region #####
        selectInput(
          "region",
          #label = tags$span(h4(HTML("<b>Select region</b>"))),
          tags$h4(
            tags$b("Select region"),
            tags$span(
              tags$i(class = "bi bi-info-circle"),
              style = "cursor: pointer; margin-left: 5px; font-size: 0.8em;",
              `data-bs-toggle` = "popover",
              `data-bs-trigger` = "hover",
              `data-bs-placement` = "right",
              title = "About region selection",
              `data-bs-content` = paste(
                "Select the contiguous United States or",
                "a state to zoom the map to that area."
              )
            )
          ),
          choices = c(
            "Contiguous U.S." = "CONUS",
            "Alabama" = "AL", "Arizona" = "AZ", "Arkansas" = "AR",
            "California" = "CA", "Colorado" = "CO", "Connecticut" = "CT",
            "Florida" = "FL", "Georgia" = "GA", "Idaho" = "ID",
            "Illinois" = "IL", "Indiana" = "IN", "Iowa" = "IA",
            "Kansas" = "KS", "Kentucky" = "KY", "Louisiana" = "LA",
            "Maine" = "ME", "Maryland" = "MD", "Massachusetts" = "MA",
            "Michigan" = "MI", "Minnesota" = "MN", "Missouri" = "MO",
            "Montana" = "MT", "Nebraska" = "NE", "Nevada" = "NV",
            "New Hampshire" = "NH", "New Jersey" = "NJ", "New Mexico" = "NM",
            "New York" = "NY", "North Carolina" = "NC", "North Dakota" = "ND",
            "Ohio" = "OH", "Oklahoma" = "OK", "Oregon" = "OR",
            "Pennsylvania" = "PA", "South Carolina" = "SC", 
            "South Dakota" = "SD", "Tennessee" = "TN", "Texas" = "TX", 
            "Utah" = "UT", "Virginia" = "VA", "Washington" = "WA", 
            "Wisconsin" = "WI", "Wyoming" = "WY"
          ),
          selected = "CONUS"
        ),
        
        ##### * Select variable #####
        
        # Info circle nested in the title to provide info on variables
        selectInput(
          "var_type",
          label = tagList(
            h4(
              HTML("<b>Select variable type</b>"),
              tags$span(
                tags$i(class = "bi bi-info-circle"),
                style = "cursor:pointer; margin-left:5px; font-size:0.8em;",
                `data-bs-toggle` = "popover",
                `data-bs-trigger` = "hover",
                `data-bs-placement` = "right",
                `data-bs-html` = "true",
                title = "About variable types",
                `data-bs-content` = paste(
                  "<b>Phenology:</b> Trends in the timing of pest life-cycle events.",
                  "<br><br>",
                  "<b>Climate stress:</b> Trends in accumulated cold or heat stress.",
                  "<br><br>",
                  "<b>Suitability:</b> Change in suitability (establishment risk) based on both stress factors."
                )
              )
            )
          ),
          choices = c(
            "Climate stress" = "climate",
            "Phenology" = "phenology",
            "Suitability" = "clm"
          ),
          selected = "phenology"
        ),
        
        ##### * Comparison metric #####
        # Info circle nested in the title to provide info on metrics
        conditionalPanel(
          #"input.pest == 'All 18 spp' && input.var_type != 'clm'" ,
          "input.pest == 'All 18 spp' && 
          (input.var_type == 'phenology' ||
          input.var_type == 'climate')" ,
          
          selectInput(
            "comparison_metric",
            label = tags$span(
              h4(HTML("<b>Select comparison metric</b>"))
            ),
            choices = c(
              "Earlier adult emergence" = "species_num_adult",
              "Earlier egg hatch" = "species_num_egg"
            ),
            selected = "species_num_adult"
          )
        ),
        
        
        # Select climate variable
        conditionalPanel(
          "input.var_type == 'climate' && input.pest != 'All 18 spp'",
          
          uiOutput("climate_metric_label"),
          
          selectInput(
            "clim_variable",
            label = NULL,
            choices = c("Cold Stress", "Heat Stress"),
            selected = "Cold Stress"
          )
        ),
        
        # Select phenology variable
        conditionalPanel(
          "input.var_type == 'phenology' && input.pest != 'All 18 spp'",
          
          uiOutput("phenology_metric_label"),
          
          selectInput(
            "phenology",
            label = NULL,
            choices = c("First Adult Emergence", "First Egg Hatch"),
            selected = "First Adult Emergence"
          )
        ),
        
        # (Shows if climate and a species is selected)
        # Select climate variable
        # conditionalPanel(
        #   "input.var_type == 'climate' && input.pest != 'All 18 spp'",
        #   
        #   selectInput(
        #     "clim_variable",
        #     label = tags$span(h4(HTML("<b>Select climate variable</b>"))),
        #     choices = c("Cold Stress", "Heat Stress"),
        #     selected = "Cold Stress"
        #   )
        # ),
        # 
        # 
        # # (Shows if phenology and a species is selected)
        # # Select phenology variable
        # conditionalPanel(
        #   "input.var_type == 'phenology' && input.pest != 'All 18 spp'",
        #   
        #   selectInput(
        #     "phenology",
        #     label = tags$span(h4(HTML("<b>Select phenology metric</b>"))),
        #     choices = c("First Adult Emergence", "First Egg Hatch"),
        #     selected = "First Adult Emergence"
        #   )
        # ),
        # 
        # Year range selection
        # selectInput(
        #   "year_range",
        #   label = tags$span(h4(HTML("<b>Select time range</b>"))),
        #   choices = c("1981-2025", "2001-2025"),
        #   selected = "1981-2025"
        # )
        # 
        tags$h4(
          tags$b("Select time range"),
          tags$span(
            tags$i(class = "bi bi-info-circle"),
            style = "cursor: pointer; margin-left: 5px; font-size: 0.8em;",
            `data-bs-toggle` = "popover",
            `data-bs-trigger` = "hover",
            `data-bs-placement` = "right",
            title = "About the time range",
            `data-bs-content` = paste(
              "Select the years used to calculate trends.",
              "The selected period determines the time span",
              "over which changes are evaluated."
            )
          )
        ),
        
        selectInput(
          "year_range",
          label = NULL,
          choices = c("1981-2025", "2001-2025"),
          selected = "1981-2025"
        )
      ), # End side panel
      
      # Visuals (Right side) ----
      
      div(
        
        style = "height: 100%;",
        
        ##### * Map #####
        div(
          
          # Ensure map fills mWhy didost of the viewport
          #tags$style("#map {height: calc(100vh - 300px) !important;}"),
          
          # To know map is loading
          leafletOutput("map", height = "70vh") %>%
            withSpinner(color = "cornflowerblue")
        ),
        
        # Below map: Show sig areas check box and export map as PNG button
        div(
          style = "display:flex;
           justify-content:space-between;
           align-items:center;
           margin-top:10px;
           width:100%;",
          
          # Left side
          conditionalPanel(
            condition = "input.pest != 'All 18 spp'",
            
            div(
              style = "padding-left:5px;",
              
              checkboxInput(
                "sig_only",
                HTML(
                  "<span style='color:#434C5E; font-weight:300;'>
           Show significant areas only
           <i class='bi bi-info-circle'
              style='margin-left:4px; cursor:pointer;'
              data-bs-toggle='popover'
              data-bs-trigger='hover'
              data-bs-placement='right'
              title='About this option'
              data-bs-content='Masks out areas with a P-value ≥ 0.1 
              (not statistically significant). A lack of significance may 
              occur due to high variability/noise, non-linear trends, or other factors.'>
           </i>
           </span>"
                ),
                value = FALSE
              )
            )
          ),
          
          # Right side
          div(
            style = "margin-left:auto;",
            
            tooltip(
              downloadButton(
                "download_map",
                "Download map",
                class = "btn-info"
              ),
              "Export a high-resolution image (PNG) of the current map view.
     Warning: download may take several seconds (up to ~1/2 min).")
            )
          ),
        
        ##### * Location statistics #####
        # Different statistics shown for individual species vs. comparison
        # Statistics for all species comparisons
        card(
          class = "mt-3",
          
          card_header(
            tags$b("Location-based information", style = "font-size: 16px")
          ),
          
          # Show results after click
          conditionalPanel(
            condition = "output.has_click == 'FALSE'",
            tags$p("Click on a location of interest on the map to 
                   produce location-based results.")
          ),
          
          layout_columns(
            
            # Left column
             div(
               
              # Left column: summary statistics
               # Left column: summary statistics
               tags$h5(
                 tags$b("Summary statistics"),
                 tags$span(
                   tags$i(class = "bi bi-info-circle"),
                   style = "cursor: pointer; margin-left: 5px; font-size: 0.8em;",
                   `data-bs-toggle` = "popover",
                   `data-bs-trigger` = "hover",
                   `data-bs-placement` = "right",
                   `data-bs-html` = "true",
                   title = "About summary statistics",
                   `data-bs-content` = paste0(
                     "<b>Change (days/year or units/year):</b> The estimated rate ",
                     "of change over time according to Sen's slope, expressed in ",
                     "either days per year (phenology) or units per year ",
                     "(cold and heat stress). Positive values indicate an ",
                     "increase while negative values indicate a decrease.",
                     "<br><br>",
                     "<b>Trend direction and strength:</b> Kendall's tau (&tau;) ",
                     "measures the direction and strength of a monotonic trend ",
                     "over time. Positive values indicate an upward trend, while ",
                     "negative values indicate a downward trend. Values closer to ",
                     "−1 or +1 indicate a stronger trend, whereas values near 0 ",
                     "indicate a weaker trend.",
                     "<br><br>",
                     "<b>P-value:</b> Statistical significance of the trend based ",
                     "on the Mann–Kendall test. A P-value &lt; 0.1 indicates a ",
                     "statistically significant trend, suggesting that the trend ",
                     "differs from zero (no trend)."
                   )
                 ),
                 style = "font-size: 18px"
               ),
            
              # Summary statistics for all species
              conditionalPanel(
                condition = "input.pest == 'All 18 spp'",
                uiOutput(
                  "comparison_summary",
                  style = "font-size: 14px; line-height: 2.0"
                )
              ),
              
              # Summary statistics for an individual pest
              conditionalPanel(
                condition = "input.pest != 'All 18 spp'",
                uiOutput(
                  "location_summary",
                  style = "font-size: 14px; line-height: 2.0"
                )
              )
              ),
            
            # Right column 
            div(
              
              ##### * Individual species plot #####
              conditionalPanel(
                condition = "input.pest != 'All 18 spp'",
                
                h5(
                  "Trend plot ",
                  style = "font-size: 18px",
                  tags$span(
                    tags$i(class = "bi bi-info-circle"),
                    style = "cursor:pointer; margin-left:5px;",
                    `data-bs-toggle` = "popover",
                    `data-bs-trigger` = "hover",
                    `data-bs-placement` = "right",
                    `data-bs-html` = "true",
                    title = "About this plot",
                    `data-bs-content` = "Plots show predicted values over time 
                    at the selected location. For phenology and climate stress, 
                    the red line indicates the trend (slope), and the P-value 
                    indicates statistical significance. Missing points indicate 
                    conditions were unsuitable for the selected event to occur."
                  )
                ),
                
                # Plot
                plotOutput("loc_plot_indiv", height = "400px"),
                tags$br(),
                
                conditionalPanel(
                  condition = "output.has_click == 'TRUE' &&
               input.pest != 'All 18 spp'",
                  
                  tooltip(
                    downloadButton(
                      "download_plot_indiv",
                      "Download plot",
                      class = "btn-info"
                    ),
                    "Export a high-resolution image (PNG) of the current plot."
                  )
                )
              ),
              
              ##### * All species comparison plot #####
              conditionalPanel(
                condition = "input.pest == 'All 18 spp'",
                
                h5(
                  "Cross-species comparison plot ",
                  style = "font-size: 18px",
                  
                  tags$span(
                    tags$i(class = "bi bi-info-circle"),
                    style = "cursor:pointer; margin-left:5px;",
                    `data-bs-toggle` = "popover",
                    `data-bs-trigger` = "hover",
                    `data-bs-placement` = "right",
                    `data-bs-html` = "true",
                    title = "About this plot",
                    `data-bs-content` = "This box-and-whisker plot shows a 
                      summary of predicted change for a selected variable across 
                      all 18 species at the location. The plot portrays the 
                      distribution of predicted (slope estimates in the model), 
                      outliers, and the median across species."
                  )
                ),
                
                plotOutput("loc_plot_comp"),
                tags$br(),
                downloadButton(
                  "download_plot_comp", 
                  "Download Plot",
                  class = "btn-info")
              )
            ),
            
            # Column widths
            col_widths = c(5, 7)
          )
          
        ) # end map div
        
      ) # end layout_sidebar
      
    ) # end nav_panel
  ), # end conditional panel to show trend plot and stats
  
  
  # Tab 3: Pest Reports ----
  nav_panel(
    
    title = "Pest Reports",
    
    # Overview of page
    div(
      
      style = "
      margin-bottom:15px;
      line-height:1.4;
    ",
    
      tags$style(HTML("
      .accordion-body {
        padding-top: 10px !important;
        padding-bottom: 10px !important;
      }
    
      .accordion-body p {
        margin-top: 6px !important;
        margin-bottom: 10px !important;
        line-height: 1.35 !important;
      }
    ")),
      
      p("The individual species profiles and research reports below provide 
      background information, present and interpret model predictions, and 
      discuss the implications for pest surveillance and management in the 
      contiguous United States. Selecting a species link takes you directly to 
      its corresponding section in the full report. The full report provides an 
      overview of the project goals and objectives, methods, and findings for 
      all species."),
      
      tags$div(style = "margin-top: 2px;"),
      
      div(
        class = "text-left my-4",
        tags$a(
          href = "reports/Full_report.html",
          target = "_blank",
          class = "btn btn-primary btn-md",
          icon("file-lines"),
          " View Full Pest Report"
        )
      )
      
    ),
    
    # Smaller Pest Reports cards: approximately 70% of their previous width.
    tags$style(HTML("
      .pest-card-grid {
        width: 70%;
        max-width: 100%;
        margin-left: 0;
        margin-right: auto;
      }

      .pest-card {
        padding: 6px;
      }

      .pest-card-image {
        width: 100%;
        aspect-ratio: 4 / 3;
        object-fit: cover;
      }

      @media (max-width: 991px) {
        .pest-card-grid {
          width: 85%;
        }
      }

      @media (max-width: 575px) {
        .pest-card-grid {
          width: 100%;
        }
      }
    ")),

    # Clickable species image grid and one shared information panel
    tags$script(HTML("
      (function() {
        function placePestInfoPanel() {
          var grid = document.querySelector('.pest-card-grid');
          var slot = document.getElementById('selected_pest_info_slot');
          if (!grid || !slot) return;

          var selected = grid.querySelector('.pest-card.is-selected');
          if (!selected) {
            // When collapsed, return the placeholder below the complete grid.
            grid.insertAdjacentElement('afterend', slot);
            return;
          }

          // Find the last card in the same visual row as the selected card.
          var selectedTop = selected.getBoundingClientRect().top;
          var cards = Array.prototype.slice.call(grid.querySelectorAll('.pest-card'));
          var rowCards = cards.filter(function(card) {
            return Math.abs(card.getBoundingClientRect().top - selectedTop) < 2;
          });

          if (rowCards.length) {
            rowCards[rowCards.length - 1].insertAdjacentElement('afterend', slot);
          }

          // Keep the expanded profile in view after it has been positioned.
          setTimeout(function() {
            var panel = slot.querySelector('.pest-info-panel');
            if (panel) {
              panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
          }, 80);
        }

        $(document).on('click', '.pest-card', function() {
          var wasSelected = $(this).hasClass('is-selected');
          $('.pest-card').removeClass('is-selected');
          if (!wasSelected) $(this).addClass('is-selected');

          // Shiny updates the selected profile asynchronously.
          setTimeout(placePestInfoPanel, 100);
          setTimeout(placePestInfoPanel, 350);
        });

        // Reposition the panel when Shiny replaces its contents.
        document.addEventListener('DOMContentLoaded', function() {
          var slot = document.getElementById('selected_pest_info_slot');
          if (slot) {
            var observer = new MutationObserver(function() {
              placePestInfoPanel();
            });
            observer.observe(slot, { childList: true, subtree: true });
          }
        });

        // Recalculate the visual row if the browser width changes.
        window.addEventListener('resize', function() {
          setTimeout(placePestInfoPanel, 100);
        });
      })();
    ")),
    div(
      class = "pest-card-grid",
      lapply(pest_profiles, make_pest_card)
    ),
    div(
      id = "selected_pest_info_slot",
      uiOutput("selected_pest_info")
    )
  )
)