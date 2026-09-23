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
    tags$script(HTML("
    document.addEventListener('mouseover', function (e) {
      const el = e.target.closest('[data-bs-toggle=\"popover\"]');
      if (!el) return;

      if (!bootstrap.Popover.getInstance(el)) {
        new bootstrap.Popover(el);
      }
    });
  ")),

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
        a("DDRP platform", href = "https://uspest.org/CAPS",
          target="_blank", style="text-decoration:underline;"), 
      " to assess the potential impacts of weather changes from 1980 to the 
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
            tableOutput("intro_table")
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
         
         tags$div(style = "margin-top: 2px;"),
         
         tags$a(
           href = "#",
           paste0("Download tutorial"),
           target = "_blank",
           style = "text-decoration: underline;"
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
          label = tags$span(h4(HTML("<b>Select region</b>"))),
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
                  "<b>All stress exclusion:</b> Change in the potential distribution based on both stress factors."
                )
              )
            )
          ),
          choices = c(
            "Climate stress" = "climate",
            "Phenology" = "phenology",
            "All stress exclusion" = "clm"
          ),
          selected = "phenology"
        ),
        
        ##### * Comparison metric #####
        # Info circle nested in the title to provide info on metrics
        # selectInput(
        #   "trend_metric",
        #   label = tagList(
        #     h4(
        #       HTML("<b>Select metric</b>"),
        #       tags$span(
        #         tags$i(class = "bi bi-info-circle"),
        #         style = "cursor:pointer;
        #          margin-left:5px;
        #          position:relative;
        #          top:-1px;
        #          font-size:0.8em;",
        #         `data-bs-toggle` = "popover",
        #         `data-bs-trigger` = "hover",
        #         `data-bs-placement` = "right",
        #         `data-bs-html` = "true",
        #         title = "About this metric",
        #         `data-bs-content` = paste(
        #           "<b>Change per year:</b> Sen's slope estimate of the trend in days/year (phenology) or units/year (climate stress).",
        #           "<br><br>",
        #           "<b>Direction of trend:</b> Kendall's tau, indicating the strength and direction of the monotonic trend."
        #         )
        #       )
        #     )
        #   ),
        #   choices = c(
        #     "Change per year" = "sens",
        #     "Direction of trend" = "tau"
        #   ),
        #   selected = "sens"
        # ),
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
        
        # (Shows if climate and a species is selected)
        # Select climate variable
        conditionalPanel(
          "input.var_type == 'climate' && input.pest != 'All 18 spp'",
          
          selectInput(
            "clim_variable",
            label = tags$span(h4(HTML("<b>Select climate variable</b>"))),
            choices = c("Cold Stress", "Heat Stress"),
            selected = "Cold Stress"
          )
        ),
        
        # (Shows if phenology and a species is selected)
        # Select phenology variable
        conditionalPanel(
          "input.var_type == 'phenology' && input.pest != 'All 18 spp'",
          
          selectInput(
            "phenology",
            label = tags$span(h4(HTML("<b>Select phenology metric</b>"))),
            choices = c("First Adult Emergence", "First Egg Hatch"),
            selected = "First Adult Emergence"
          )
        ),
        
        # Year range selection
        selectInput(
          "year_range",
          label = tags$span(h4(HTML("<b>Select time range</b>"))),
          choices = c("1981-2025", "1981-2000", "2001-2025"),
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
                class = "btn-info btn-sm"
              ),
              "Export a high-resolution image (PNG) of the current map view.
       Download may take several seconds."
            )
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
              h5("Summary statistics", style = "font-size: 18px"),
              tags$hr(),
              
              conditionalPanel(
                condition = "input.pest != 'All 18 spp'",
                uiOutput("location_summary", style = "font-size: 14px; line-height: 2.0")
              ),
              
              # All species stats
              conditionalPanel(
                condition = "input.pest == 'All 18 spp'",
                uiOutput("comparison_summary", style = "font-size: 14px; line-height: 2.0")
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
                    `data-bs-content` = "This plot shows predicted values at the 
                    selected location over time. If the variable type is 'Phenology' 
                    or 'Climate stress', the red line represents Sen’s 
                    slope (trend), and the p-value indicates statistical 
                    significance. If the plot you selected shows missing points,
                    those points are due to conditions being unsatisfactory for
                    the selected event to occur."
                  )
                ),
                
                # Plot
                plotOutput("loc_plot_indiv", height = "400px"),
                tags$br(),
                
                
                conditionalPanel(
                  condition = "output.has_click == 'TRUE' && 
                  input.pest != 'All 18 spp'",
                  
                  downloadButton(
                    "download_plot_indiv",
                    "Download plot",
                    class = "btn-info btn-sm"
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
                  class = "btn-info btn-sm")
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
      
    "Below are profiles and research reports for the 18 invasive pest species 
    modeled for this project. Each report provides background information on the
    species, presents and interprets models predictions, and discusses the 
    relevance of the results to the surveillance and management of the pest in
    in the contiguous United States."
      
    ),
    
    # Species menu
    accordion(
      
      open = FALSE,
      
      ##### * Asian longhorned beetle #####
      make_pest_panel(
        common_name = "Asian longhorned beetle",
        scientific_name = HTML("<i>Anoplophora glabripennis</i>"),
        abbreviation = "ALB",
        description = tagList(
          "The Asian longhorn beetle (ALB), ",
          HTML("<i>Anoplophora glabripennis</i>"),
          "Motschulsky (Coleoptera: Cerambycidae), is a xylophagous beetle native to the Korean peninsula and eastern China. In the United States, the beetle was first discovered on Long Island, NY, in 1996. ALB spread to a number of sites in the eastern United States and Canada but has since been eradicated in Illinois, New Jersey, New York City, Boston, Mississauga, and Toronto. The pest is a major threat to the maple hardwood lumber and sugar maple syrup industries, as well as tourism associated with fall colors in maple trees. Learn more about ALB and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "ALB.png",
        photo_credit = "Photo: Iowa State University Extension and Outreach"
      ),
      
      ##### * Asiatic rice borer #####
      make_pest_panel(
        common_name = "Asiatic rice borer",
        scientific_name = HTML("<i>Chilo suppressalis</i>"),
        abbreviation = "ASRB",
        description = tagList(
          "The Asiatic rice borer (ASRB), ",
          HTML("<i>Chilo suppressalis</i>"),
          "(Crambiidae), is a stem borer widespread throughout Asia, Oceana, the Middle East, and Europe and has been recorded in Hawaii. While host plants include water oat, sorghum, millet, corn, and other grasses, ASRB larvae cause major damage to rice crops by severing panicles or the vascular system of tillers leading to white earheads and dead heart. The pest is not known to occur in the conterminous United States but Pyraloidea larvae are frequently intercepted at U.S. ports. Learn more about ASRB and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "ASRB.png",
        photo_credit = "Photo: Hanna Royals, Screening Aids, USDA APHIS PPQ, Bugwood.org"
      ),
      
      ##### * Common cutworm #####
      make_pest_panel(
        common_name = "Common / Cotton cutworm",
        scientific_name = HTML("<i>Spodoptera litura</i>"),
        abbreviation = "SLI",
        description = tagList(
          "The common or cotton cutworm (SLI), ",
          HTML("<i>Spodoptera litura</i>"),
          "(Fabricius, 1775) (Lepidoptera: Noctuidae), is a highly polyphagous pest of at least 120 species, including economically important crops such as corn, cotton, groundnut, potato, soybean, sweet potato, tea, tobacco, and other vegetables. Native to Southeast Asia, SLI is now distributed throughout Australia, Oceania, several African islands, Hawaii, and regions of Asia. SLI has developed resistance to a wide range of insecticides and transgenic Bt cotton and can migrate long distances, possibly aided by typhoons. Heavy defoliation of host plants by larvae has led to severe crop and economic losses. Learn more about SLI and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "SLI.png",
        photo_credit = "Photo: Birgit E. Rhode, Landcare Research New Zealand Ltd."
      ),
      
      ##### * Egyptian cottonworm #####
      make_pest_panel(
        common_name = "Egyptian cottonworm",
        scientific_name = HTML("<i>Spodoptera littoralis</i>"),
        abbreviation = "ECW",
        description = tagList(
          "The Egyptian cottonworm (ECW), ",
          HTML("<i>Spodoptera littoralis</i>"),
          "Boisduval (Lepidoptera: Noctuidae), is a highly destructive, polyphagous moth present throughout southern Europe, the Mediterranean basin, the Middle East, Africa, China, and India. Host plants include 80 plant species from over 40 families, but ECW is considered a major pest of cotton, maize, potato, sugarcane, soybeans, vegetables, and wheat. The larval stage can damage plants by extensive defoliation and by attacking growing points and mining or cutting stems. ECW is not known to be established in the United States but has been intercepted numerous times at ports of entry. Learn more about ECW and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "ECW.png",
        photo_credit = "Photo: Russel IPM"
      ),
      
      ##### * Emerald Ash borer #####
      make_pest_panel(
        common_name = "Emerald ash borer",
        scientific_name = HTML("<i>Agrilus planipennis</i>"),
        abbreviation = "EAB",
        description = tagList(
          "The emerald ash borer (EAB), ",
          HTML("<i>Agrilus planipennis</i>"),
          "Fairmaire (Coleoptera: Buprestidae), is a wood-boring beetle native to eastern Asia that feeds exclusively on ash trees ",
          HTML("(<i>Fraxinus</i> spp.),"),
          "though it occasionally attacks fringe trees ",
          HTML("(<i>Chionathus</i> spp.)"),
          "and olive trees ",
          HTML("(<i>Olea</i> spp.)."),
          "The pest is present in at least 37 U.S. states and six Canadian provinces. Feeding by larvae usually results in the death of the tree within about six years. EAB’s cryptic nature, in which all life stages except for the adult beetle are inside of trees, makes early detection of this pest extremely difficult. The financial impact of EAB in the U.S. is estimated to be in the billions of dollars. Additionally, the widespread loss of ash trees has resulted in decreased biodiversity and lost ecosystem services. Learn more about EAB and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "EAB.png",
        photo_credit = "Photo: Treescape Certified Arborists, treescapecanada.ca"
      ),
      
      ##### * False codling moth #####
      make_pest_panel(
        common_name = "False codling moth",
        scientific_name = HTML("<i>Thaumatotibia leucotreta</i>"),
        abbreviation = "FCM",
        description = tagList(
          "Native to sub-saharan Africa, the false codling moth (FCM), ",
          HTML("<i>Thaumatotibia leucotreta</i>"),
          "Meyrick (Lepidoptera: Tortricidae), is a highly polyphagous pest now present throughout most of Africa and Israel. Economically important hosts include avocado, certain ",
          HTML("<i>Citrus</i> spp.,"),
          "corn, cotton, eggplants, grapes, stonefruit, peppers, and cut roses. FCM larvae cause damage by boring into plant fruit before forming cocoons in the soil. In 2008, a single adult FCM male was discovered in the wild in California. If established in the United States, the pest could cause significant economic damage. Learn more about FCM and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "FCM.png",
        photo_credit = "Photo: J. H. Hofmeyr, Citrus Research International, Bugwood.org"
      ),
      
      ##### * Honeydew moth #####
      make_pest_panel(
        common_name = "Honeydew moth",
        scientific_name = "Cryptoblabes gnidiella",
        abbreviation = "CGN",
        description = tagList(
          "Native to the Mediterranean region, the honeydew moth (CGN), ",
          HTML("<i>Cryptoblabes gnidiella</i>,"),
          "is a highly polyphagous pest primary and secondary pest of many economically important crops, including avocado, citrus, corn, cotton, grape, loquat, pomegranate, rice, and wheat. CGN is usually associated with coccoids and pseudococcids, the honeydew of which CGN larvae feed on, but the pest can also directly harm fruit on certain crops. CGN has spread throughout many southern European and northern and southern African countries, as well as Brazil, Fiji, India, Malaysia, New Zealand, Uruguay, and Hawaii in the United States. While not yet established in the contiguous United States, it has been intercepted hundreds of times at ports of entry, often from countries where it is not known to be established. Learn more about CGN and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "CGN.png",
        photo_credit = "Photo: Hanna Royals, Screening Aids, USDA APHIS PPQ, Bugwood.org"
      ),
      
      ##### * Japanese beetle #####
      make_pest_panel(
        common_name = "Japanese beetle",
        scientific_name = "Popillia japonica",
        abbreviation = "JPB",
        description = tagList(
          "Native to Japan, the Japanese beetle (JPB), ",
          HTML("<i>Popillia japonica</i>,"),
          "is a highly polyphagous pest with more than 400 host plants, including food crops, fruit trees, turfgrass, and ornamental plants. Since its first detection in 1916 in the United States in New Jersey, the beetle has become widespread throughout the eastern and central states, as well as parts of eastern Canada. Outbreaks in Colorado and California were eradicated; however, JPB is established in a small number of locations in the Pacific Northwest, including in British Columbia, Washington, and Oregon. Total associated costs of JPB in the United States are estimated at $460 million annually, with $234 million a year spent on control and turf replacement costs. Learn more about JPB and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "JPB.png",
        photo_credit = "Photo: YinYang, iStock"
      ),
      
      ##### * Japanese pine sawyer beetle #####
      make_pest_panel(
        common_name = "Japanese pinesawyer beetle",
        scientific_name = "Monochamus alternatus",
        abbreviation = "JPSB",
        description = tagList(
          "The Japanese pine sawyer beetle (JPSB), ",
          HTML("<i>Monochamus alternatus</i>"),
          "Hope (Coleoptera: Cerambycidae), is a major vector of nematodes that cause pine wilt disease. Native to mainland China, Taiwan, Laos, Korea, and Japan, JPSB has spread to South Korea and Vietnam. Adult beetles carrying the nematodes feed upon and infect healthy pine trees, which will show symptoms of infection due to xylem blockage caused by the nematode in about three weeks. JPSB beetles oviposit in the diseased tree, producing larvae that feed under the bark before diapausing. In regions invaded by the JPSB, such as Portugal and Korea, pine wilt disease has resulted in millions of dollars of damage to forest products. Host plants are usually gymnosperms or are from the ",
          HTML("<i>Pinus</i>, <i>Abies</i>, <i>Picea</i>, <i>Larix</i> and <i>Cedrus</i>"),
          "families, though ",
          HTML("<i>Malus</i>"),
          "spp. and ",
          HTML("<i>Acer</i>"),
          "spp. are also possible hosts. Learn more about JPSB and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),  
        image_file = "JPSB.png",
        photo_credit = "Photo: Christopher Pierce, USDA APHIS PPQ, Bugwood.org"
      ),
      
      ##### * Light brown apple moth #####
      make_pest_panel(
        common_name = "Light brown apple moth",
        scientific_name = "Epiphyas postvittana",
        abbreviation = "LBAM",
        description = tagList(
          "Native to Australia, the light brown apple moth (LBAM), ",
          HTML("<i>Epiphyas postvittana</i>"),
          "(Walker) (Lepidoptera: Tortricidae), is invasive in the United States, the United Kingdom, New Zealand, New Caledonia, and the Azores, with multiple interceptions reported in other countries. The highly polyphagous pest has over 500 reported host plants, though its economic impacts have been greatest for apple, pears, and grapes. LBAM infestation can result in market access issues due to the risks of transporting live larvae on a large variety of host plants. The pest’s distribution in the United States is limited to Hawaii, where it was first reported in 1893, and in California, where it was first confirmed in 2007 and now persists mainly around San Francisco and along the coast. Learn more about LBAM and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "LBAM.png",
        photo_credit = "Photo: Todd M. Gilligan and Marc E. Epstein"
      ),
      
      ##### * Oak ambrosia beetle #####
      make_pest_panel(
        common_name = "Oak ambrosia beetle",
        scientific_name = "Platypus quercivorus",
        abbreviation = "OAB",
        description = tagList(
          "The oak ambrosia beetle (OAB), ",
          HTML("<i>Platypus quercivorus</i>"),
          "Murayama (Coleoptera: Platypodidae), is a forest pest and vector of its symbiont, the pathogenic fungus, ",
          HTML("<i>Raffaelea quercivora</i>"),
          "Kubono & Shin-Ito. Japanese oak wilt disease (JOW) caused by this fungus kills both healthy and stressed trees by blocking tracheary function. Host plants required to complete reproduction are ",
          HTML("<i>Quercus</i>"),
          "species and several other members of the ",
          HTML("<i>Fagaceae</i>"),
          "family, including chestnut ",
          HTML("(<i>Castanea</i> spp.),"),
          "chinquapin ",
          HTML("(<i>Castanopsis</i> spp.),"),
          "and stone oaks ",
          HTML("(<i>Lithocarpus</i> spp.)."),
          "OAB is distributed throughout India, Indonesia, Japan, and Papua New Guinea; however, ",
          HTML("<i>R. quercivora</i>"),
          "has only been reported in Japan, where the fungus has caused significant mortality in oak trees. OAB and JOW would cause considerable economic, environmental, and social impact if introduced to the United States, where there are 28 possible susceptible species of oak. Learn more about OAB and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "OAB.png",
        photo_credit = "Photo: Joseph Benzel, Screening Aids, USDA APHIS PPQ, Bugwood.org"
      ),
      
      ##### * Old world bollworm #####
      make_pest_panel(
        common_name = "Old world bollworm",
        scientific_name = "Helicoverpa armigera",
        abbreviation = "OWBW",
        description = tagList(
          "The Old World or cotton bollworm (OWBW), ",
          HTML("<i>Helicoverpa armigera</i>"),
          "(Hübner) (Lepidoptera: Noctuidae), is a highly polyphagous pest of agricultural crops from 68 different plant families, including chickpeas, corn, cotton, tobacco, tomatoes, potatoes, and soybeans. Widespread throughout almost all of Europe, Asia, Africa, and Australasia, OWBW began spreading through Central and South America in 2013. In 2015, several specimens were detected in Florida, but populations did not establish. The pest has the ability to migrate over great distances, even up to 2,000 km if aided by wind. OWBW is resistant to a number of insecticides and transgenic crops. An estimated $78 billion per year in crops could be at risk of pest damage if OWBW becomes established in the United States. Learn more about OWBW and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "OWBW.png",
        photo_credit = "Photo: Birgit E. Rhode, Landcare Research New Zealand Ltd."
      ),
      
      ##### * Pine tree lappet moth #####
      make_pest_panel(
        common_name = "Pine-tree lappet moth",
        scientific_name = "Dendrolimus pini",
        abbreviation = "PTLM",
        description = tagList(
          "The pine-tree lappet moth (PTLM), ",
          HTML("<i>Dendrolimus pini</i>"),
          "Linnaeus (Lepidoptera: Lasiocampidae), is an economically important pest of pine trees that is native to Europe and Asia. PTLM’s primary host is the Scots pine",
          HTML("(<i>Pinus sylvestris</i>),"),
          "but it can successfully develop on 17 other species of pine, Douglas fir ",
          HTML("(<i>Pseudotsuga menziesii</i>,)"),
          "and Eastern hemlock",
          HTML("(<i>Tsuga canadensis</i>),"),
          "and may be able to successfully develop on ",
          HTML("<i>Pinus</i>"),
          "species outside of its current range. Surviving affected trees take several years to recover from defoliation and are more susceptible to other forest pests. If introduced to the United States, PTLM could cause significant damage to forests dominated by pine and monoculture pine plantations, resulting in economic damage to the timber and Christmas tree industries. Learn more about PTLM and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "PTLM.png",
        photo_credit = "Photo: Vítězslav Maňák (SLU)"
      ),
      
      ##### * Silver Y moth #####
      make_pest_panel(
        common_name = "Silver Y moth",
        scientific_name = "Autographa gamma",
        abbreviation = "SLYM",
        description = tagList(
          "Widespread throughout Europe, northern Africa, and Asia, the Silver Y moth (SLYM), ",
          HTML("<i>Autographa gamma</i>"),
          "Linnaeus (Lepidoptera: Noctuidae), is a highly polyphagous, defoliating pest of cereals, ",
          HTML("<i>Brassica</i>"),
          "species, legumes, tobacco, and other fruit and vegetable crops, especially sugarbeet. Adults migrate annually to northern breeding grounds throughout Eurasia to escape the hot and dry conditions of Mediterranean overwintering sites. Mass outbreaks of SLYM in breeding areas occur sporadically, which have been correlated with very wet weather. The pest has been intercepted at United States ports hundreds of times and has a high establishment risk if introduced. Learn more about SLYM and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "SLYM.png",
        photo_credit = "Photo: Vítězslav Maňák (SLU)"
      ),
      
      ##### * Small tomato borer #####
      make_pest_panel(
        common_name = "Small tomato borer",
        scientific_name = "Neoleucinodes elegantalis",
        abbreviation = "STB",
        description = tagList(
          "The small tomato borer (STB), ",
          HTML("<i>Neoleucinodes elegantalis</i>"),
          "(Guenée) (Lepidoptera: Pyralidae), is an oligophagous pest of ",
          HTML("<i>Solanum</i>"),
          "species, including tomato, eggplant, red and green pepper, and lulo/naranjilla. Native to South America, STB has spread throughout Mexico, Central America, and the Caribbean. The pest occupies a wide range of climates in South America, though its presence varies by host plant and altitude. Larvae cause the most damage to plants, feeding on foliage, boring into stems, and burrowing into green or ripe fruit. Regions with extensive tomato and pepper production would face especially high risk if STB becomes established in the United States. The pest is a major barrier to the export of solanaceous products to the United States and the European Union from South America. Learn more about STB and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "STB.png",
        photo_credit = "Photo: Hanna Royals, Screening Aids, USDA APHIS PPQ, Bugwood.org"
      ),
      
      ##### * Spotted lanternfly #####
      make_pest_panel(
        common_name = "Spotted lanternfly",
        scientific_name = "Lycorma delicatula",
        abbreviation = "SLF",
        description = tagList(
          "The spotted lanternfly (SLF), ",
          HTML("<i>Lycorma delicatula</i>"),
          "(White) (Hemiptera: Fulgoridae), is a highly polyphagous planthopper native to China, India, and Vietnam that has invaded South Korea, Japan, and the United States. Since its initial detection in Pennsylvania in 2014, SLF has spread to numerous states in the eastern United States. Preferred hosts include tree-of-heaven",
          HTML("(<i>Ailanthus altissima</i>),"),
          "grapes, apples, hops, maples, walnuts, and stone fruit. Both nymphs and adults feed on phloem sap, causing stress to plants and producing honeydew that promotes the growth of sooty mold. Heavy infestations can reduce crop yields, weaken trees, and negatively impact vineyards and orchards. SLF is capable of spreading long distances through human-assisted movement of egg masses on vehicles and outdoor materials. Learn more about SLF and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "SLF.png",
        photo_credit = "Photo: USDA APHIS PPQ"
      ),
      
      ##### * Sunn pest #####
      make_pest_panel(
        common_name = "Sunn pest",
        scientific_name = "Eurygaster integriceps",
        abbreviation = "SUNP",
        description = tagList(
          "Sunn pest (SUNP), ",
          HTML("<i>Eurygaster integriceps</i>"),
          "Puton (Hemiptera: Scutelleridae), is a serious economically important pest of cereals throughout central and western Asia, including Afghanistan, Iran, Iraq, Syria, Turkey, and parts of the former Soviet Union. Wheat and barley are the primary hosts, though rye and oats may also be attacked. Both nymphs and adults feed on leaves, stems, and grains using piercing-sucking mouthparts, reducing crop yield and grain quality. Feeding damage can severely impact flour quality by degrading gluten proteins, making dough unsuitable for baking. SUNP outbreaks are influenced by climatic conditions, especially warm and dry weather during development. If introduced into the United States, SUNP could pose a significant threat to cereal production and food quality. Learn more about SUNP and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "SUNP.png",
        photo_credit = "Photo: Konstantinos Kalaentzis"
      ),
      
      ##### * Tomato leaf miner #####
      make_pest_panel(
        common_name = "Tomato leaf miner",
        scientific_name = "Phthorimaea absoluta",
        abbreviation = "TABS",
        description = tagList(
          "The tomato leaf miner (TABS), ",
          HTML("<i>Phthorimaea absoluta</i>"),
          "(Meyrick) (Lepidoptera: Gelechiidae), is a serious pest of tomato and other solanaceous plants, including potato, eggplant, and pepper. Native to South America, TABS has rapidly spread throughout Europe, Africa, the Middle East, and Asia since the early 2000s. Larvae mine leaves, bore into stems, and feed directly on fruit, causing substantial crop losses and reducing marketability. Tomato crops can experience nearly complete yield loss under severe infestations if control measures are not implemented. TABS has a high reproductive capacity, multiple generations per year, and has developed resistance to numerous insecticides, complicating management efforts. The pest is considered a major threat to tomato production worldwide and poses a significant risk to United States agriculture if it becomes established. Learn more about TABS and how long-term weather changes may be impacting its activities and potential for establishment in the report below."
        ),
        image_file = "TABS.png",
        photo_credit = "Photo: Andrew M Allport, Driffield"
      )
    )
  )
)