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
      
      p("Here, we use the Degree-Day, establishment Risk, and Phenological (DDRP) 
        event mapping system to assess the potential impacts of weather from 
        1980 to the current year on the timing of pest activity such as 
        emergence (phenology) and potential for establishment of 18 invasive 
        pest species in the contiguous United States."),
      
      p(HTML("<b>Note:</b> 
             The contiguous United States pertains to all states excluding 
             Alaska and Hawaii.")),
      
      accordion(
        
        open = FALSE,
        
        accordion_panel(
          title = "Open to see more info on the 18 species",
          status = "info",
          tagList(
            p("Of the 18 species with models, 12 are presently on Plant
            Protection and Quarantine’s National Priority Pest List. Six were 
            formerly included on the list, and two are Federal Program Pests. 
            Most of the species do not occur in the contiguous United States 
            (N = 13); however, five are established and may spread to additional 
            regions. Real-time forecasts for these pests are available at ",
              a("USPest.org", href = "https://uspest.org/CAPS",
                target="_blank", style="text-decoration:underline;"),
              "."),
            tableOutput("intro_table")
          )
        )),
      
      br(),
      
      # Text
      p("The system is part of a suite of decision-support tools at ",
        a("USPest.org", href = "https://uspest.org/wea/",
          target="_blank", style="text-decoration:underline;"),
        " that are developed and maintained by the Oregon Integrated Pest 
        Management Center (OIPMC) at Oregon State University. These tools 
        provide thousands of end users nationwide with information to support 
        timely and effective management activities for agricultural pests and 
        diseases. This project implements the DDRP event mapping system to predict
        where pests may exhibit earlier activities, increases in the number of 
        generations, and increases in habitat suitability. This information 
        helps Plant Protection and Quarantine allocate survey resources more 
        strategically, thereby reducing the likelihood of pest establishment and 
        spread. "
      ),
      
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
      )
    ),
    
    # Citations and references
    div(
      
      class = "p-4 my-3",
      
      h3(HTML("<b>References</b>")),
      
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
        
        # Words
        p("Due to a large amount of data being plotted,
          the map may take a few seconds to load."),
        
        # Add space
        #hr(),
        #hr(style = "margin-top: 1px; margin-bottom: 1px;"),
        
        # Select pest
        selectInput(
          "pest",
          label = tags$span(h4(HTML("<b>Select insect pest</b>"))),
          choices = c("All species (comparisons)" = "All 18 spp", 
                      sort(unique(raster_lookup$common_name))),
          # CHANGE THIS:
          selected = "Asian longhorned beetle"
        ),
        
        # Select region filter
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
        
        # Add space
        #hr(),
        #hr(style = "margin-top: 1px; margin-bottom: 1px;"),
        
        #uiOutput("var_type_ui"),
        selectInput(
          "var_type",
          label = tags$span(h4(HTML("<b>Select variable type</b>"))),
          choices = c(
            "Climate stress" = "climate",
            "Phenology" = "phenology",
            "All stress exclusion" = "clm"
          ),
          selected = "phenology"
        ),
        
        #uiOutput("metric_ui"),
        div(
          id = "trend_metric_container",
          
          selectInput(
            "trend_metric",
            label = tags$span(h4(HTML("<b>Select metric</b>"))),
            choices = c(
              "Change per year" = "sens",
              "Direction of trend" = "tau"
            ),
            selected = "sens"
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
        
        # Select trend metric for a species (shows unless All spp or CLM is selected)
        # conditionalPanel(
        #   condition = "input.pest != 'All 18 spp' && input.var_type != 'clm'",
        #   selectInput(
        #     "trend_metric",
        #     label = tags$span(h4(HTML("<b>Select metric</b>"))),
        #     choices = c(
        #       "Change per year" = "sens",
        #       "Direction of trend" = "tau"
        #     ),
        #     selected = "sens"
        #   )
        # ),
        
        # Year range selection
        selectInput(
          "year_range",
          label = tags$span(h4(HTML("<b>Select time range</b>"))),
          choices = c("1981-2025", "1981-2000", "2001-2025"),
          selected = "1981-2025"
        )
        
      ), # End side panel
      
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
        
        # Below map: Show sig areas check box and Export map as PNG button
        div(
          class = "d-flex justify-content-between align-items-center my-2",
          
          # Fixed-width container - check box only for tau and sen maps
          div(
            style = "min-width: 260px;",  # adjust width as needed
            
            conditionalPanel(
              condition = "input.pest != 'All 18 spp' && input.var_type != 'clm'",
              
              tooltip(
                checkboxInput(
                  "sig_only",
                  HTML("<span style='color:#434C5E; font-weight:300;'>
                Show significant areas only
               </span>"),
                  value = FALSE
                ),
                "Masks out areas where P ≥ 0.1 according to the Mann-Kendall test",
                placement = "right"
              )
            )
          ),
          # 1. The visible warning text
          # span(
          #   "Note: download may take several seconds.", 
          #   style = "font-size: 0.85rem; color: #666; font-style: italic; margin-right: 15px;"
          # ),
          
          # 2. The button (wrapped in a tooltip for extra detail on hover)
          tooltip(
            downloadButton(
              "download_map",
              "Download map",
              class = "btn-info btn-sm"
            ),
            "Export a high-resolution image (PNG) of the current map view. 
            Download may take several seconds."
          )
        ),
        
        # Location statistics (under map)
        # Different statistics shown for individual species vs. comparison
        # Statistics for all species comparisons
          card(
            class = "mt-3",
            
            card_header(
              tags$b("Location-based information", style = "font-size: 16px")
            ),
    
            # Show instructions before click
            conditionalPanel(
              condition = "output.has_click != 'TRUE'",
              tags$p("Click on a location of interest on the map to 
                   produce location-based results.")
              ),
              
              # Show results after click
              conditionalPanel(
                condition = "output.has_click == 'TRUE'",
                
              layout_columns(
                
                # ================= LEFT COLUMN =================
                div(
                  h5("Summary statistics", style = "font-size: 18px"),
                  tags$hr(),
                  
                  uiOutput("clicked_years", style = "font-size: 14px; line-height: 2.0"),
                  uiOutput("clicked_latlon", style = "font-size: 14px; line-height: 2.0"),
                  uiOutput("clicked_pest", style = "font-size: 14px; line-height: 2.0"),
                  uiOutput("clicked_variable", style = "font-size: 14px; line-height: 2.0"),
                  uiOutput("clicked_value", style = "font-size: 14px; line-height: 2.0"),
                  
                  # Individual species stats
                  conditionalPanel(
                    condition = "input.pest != 'All 18 spp'",
                    uiOutput("clicked_pval", style = "font-size: 14px; line-height: 2.0")
                  ),
                  
                  # All species stats
                  conditionalPanel(
                    condition = "input.pest == 'All 18 spp'",
                    uiOutput("clicked_slopemed", style = "font-size: 14px; line-height: 2.0"),
                    uiOutput("clicked_sloperange", style = "font-size: 14px; line-height: 2.0")
                  )
                ),
                
                # ================= RIGHT COLUMN =================
                div(
                  
                  # ---- Individual species plot ----
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
                    plotOutput("loc_plot_indiv"),
                    tags$br(),
                    
                    # Download plot (conditional if plot appears)
                    
                    #   downloadButton(
                    #     "download_plot_indiv", 
                    #     "Download Plot",
                    #     class = "btn-info btn-sm")
                    # ),
                    
                    conditionalPanel(
                      condition = "input.map_click && input.pest != 'All 18 spp'",
                      
                      downloadButton(
                        "download_plot_indiv",
                        "Download plot",
                        class = "btn-info btn-sm"
                      )
                    )
                  ),
                  
                  # ---- All species comparison plot ----
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
            )
            
          ) # end map div
          
        ) # end layout_sidebar
      
      ) # end nav_panel
    ), # end conditional panel to show trend plot and stats
 
  
  ##### * Tab 3: Pest Reports #####
  
  nav_panel(
    
    title = "Pest Reports",
    
    accordion(
      
      open = FALSE,
      
      ##### ** Asian longhorned beetle #####
      accordion_panel(
        HTML("<b>Asian longhorned beetle</b> (<i>Anoplophora glabripennis</i>)"),
        
        p("The Asian longhorn beetle (ALB), Anoplophora glabripennis Motschulsky 
        (Coleoptera: Cerambycidae), is a xylophagous longhorned beetle native to 
        the Korean peninsula and eastern China. It became  a serious pest in 
        China following the widespread planting of nonnative trees (Lingafelter 
        and Hoebeke 2002, Williams et al. 2004, Herard et al. 2009, Javal 2019) 
        and now has a  range that extends from 21° to 43° N (Yan 1985, Haack and 
        Hoebeke 1996, Lingafelter and Hoebeke 2002). In North America, this 
        latitudinal range encompasses Cancun, Mexico to  Milwaukee, Wisconsin. 
        Invasive ALB populations in Europe occur as far north as 60° N, in 
        Finland (EPPO 2021, Schmitt et al. 2025b). In the United States, the 
        beetle was first discovered on Long Island, NY, in 1996, where it likely 
        arrived via wood packaging from China (Haack and Hoebeke 1996). The pest 
        spread to a number of sites in the eastern United States and Canada but 
        has since been eradicated in Illinois, New Jersey, New York City, 
        Boston, Mississauga, and Toronto (Coyle et al. 2021, EPPO 2021). 
        However, infestations currently persist in central Long Island, NY; 
        Worcester County, MA; Clermont County, OH; and Charleston County, SC 
        (Coyle et al. 2021, USDA-APHIS 2025). ALB is a major threat to the maple 
        hardwood lumber and sugar maple syrup industries, as well as tourism 
        associated with fall colors in maple trees (Smith and Wu 2008). The cost 
        of a complete infestation of all urban areas in the U.S. has been 
        estimated at $669 billion (Nowak et al. 2001)."),
        
        br(),
        
        p("An estimated 30-35% of trees in the eastern United States are species 
          commonly attacked by the pest (Nowak et al. 2001, Smith and Wu 2008). 
          ALB can complete is its lifecycle on Acer, Aesculus, Albizia 
          julibrissin, Betula, Cercidiphyllum, Elaeagnus angustifolia, Fraxinus, 
          Platanus, Populus, Salix, Sorbus aucuparia and Ulmus species (van der 
          Gaag and Loomans 2014). However, preferred genera in North America are 
          Acer and Ulmus, compared to Populus and Salix in China (Hu et al. 2009, 
          van der Gaag and Loomans 2014). Following oviposition under the bark 
          of host trees, larvae feed in the cambial region before burrowing into 
          the inner xylem and heartwood (Haack and Hoebeke 1996, Haack 2006). ALB
          may overwinter as an egg, larva, or pupa, though typically as an egg 
          or larva, before emerging from round exit holes as adults (Haack and 
          Hoebeke 1996, Haack 2006, Herard et al. 2009, Faccoli et al. 2015, 
          Trotter and Keena 2016). ALB diapause termination requires a chilling 
          period, and ALB larvae may be freeze tolerant (Roden et al. 2008, 
          Torson et al. 2021).")
      ),
      
      ##### ** Asiatic rice borer #####
      accordion_panel(
        HTML("<b>Asiatic rice borer</b> (<i>Chilo suppressalis</i>)"),
        
        p("The Asiatic rice borer (ASRB), Chilo suppressalis Walker (Lepidoptera: 
      Crambiidae), is a stem borer widespread throughout Asia, Oceana, the 
      Middle East, and Europe and has been recorded in Hawaii (CAPS 2025, Meng 
      et al. 2008). While host plants include water oat, sorghum, millet, corn, 
      and other grasses, ASRB larvae cause major damage to rice crops by 
      severing panicles or the vascular system of tillers leading to white 
      earheads and dead heart (Kiritani and Iwao 1967, Muralidharan and Pasalu 
      2006, Chen et al. 2014, EPPO 2019). The pest is not known to occur in the 
      conterminous United States but Pyraloidea larvae are frequently 
      intercepted at U.S. ports (Solis 2006).")
      ),
      
      ##### ** Common cutworm #####
      accordion_panel(
        HTML("<b>Common / Cotton cutworm</b> (<i>Spodoptera litura</i>)"),
        
        p("The common or cotton cutworm (SLI), Spodoptera litura (Fabricius, 
        1775) (Lepidoptera: Noctuidae), is a highly polyphagous pest of at least 
        120 species, including economically important crops such as corn, 
        cotton, groundnut, potato, soybean, sweet potato, tea, tobacco, and 
        other vegetables (Bragard et al. 2019, EPPO 2023). Native to Southeast 
        Asia, SLI is now distributed throughout Australia, Oceania, several 
        African islands, Hawaii, and regions of Asia (Bragard et al. 2019, 
        EPPO 2023). Development rates and fecundity are significantly affected 
        by temperature, humidity, and host plant quality (Garard et al. 1984, 
        EPPO 2023, Maharjan et al. 2023, Fu et al. 2025). SLI completes 3-12 
        generations in tropical regions versus X generations in colder parts of 
        its distribution (cite).  In areas north of 30° in China, the pest 
        establishes summer migratory populations because it cannot survive the 
        winter due to a lack of diapause (Fand et al. 2015, Fu et al. 2015, 
        Bragard et al. 2019, EPPO 2023). SLI has developed resistance to a wide 
        range of  insecticides and transgenic Bt cotton and can migrate long 
        distances, possibly aided by typhoons (Tu et al. 2010, Fu et al. 2015, 
        Wan et al. 2008, Bragard et al. 2019, Murata et al. 1998). Heavy 
        defoliation of host plants by larvae has led to severe crop and economic 
        losses (Murata et al. 1998, Prasad et al. 2013, Bragard et al. 2019, 
        Maharjan et al. 2023).")
      ),
      
      ##### ** Egyptian cottonworm #####
      accordion_panel(
        HTML("<b>Egyptian cottonworm</b> (<i>Spodoptera littoralis</i>)"),
        
        p("The Egyptian cottonworm (ECW), Spodoptera littoralis Boisduval 
      (Lepidoptera: Noctuidae), is a highly destructive, polyphagous moth 
      present throughout southern Europe, the Mediterranean basin, the Middle 
      East, Africa, China, and India (EPPO 2025). Host plants include 80 plant 
      species from over 40 families, but ECW is considered a major pest of 
      cotton, maize, potato, sugarcane, soybeans, vegetables, and wheat 
      (CABI 2022). Development times and overall survival rates of ECW can 
      depend on the host plant (Salama et al. 1971, Shoman et al. 2025). The 
      larval stage, which has six instars, can damage plants by extensive 
      defoliation and by attacking growing points and mining or cutting stems 
      (Baker and Miller 1974, EFSA 2015, CABI 2022). ECW does not have diapause 
      but overwinters in the soil as a late stage larva or pupa (Yathom 1971, 
      Ellis 2004, Miller 1977, Coop and Barker 2021). ECW is not known to be 
      established in the United States but has been intercepted numerous times 
      at ports of entry (Ellis 2004).")
      ),
      
      ##### ** Emerald Ash borer #####
      accordion_panel(
        HTML("<b>Emerald Ash borer</b> (<i>Agrilus planipennis</i>)"),
        
        p("The emerald ash borer (EAB), Agrilus planipennis Fairmaire (Coleoptera: 
        Buprestidae), is a flat-headed, wood-boring beetle native to eastern 
        Asia that almost exclusively requires ash trees (Fraxinus spp.) to 
        complete its life cycle (Poland et al. 2015, USDA 2025). It was first 
        discovered in North America in 2002 in Michigan and Ontario, though it 
        likely had entered Michigan in the early to mid-1990s (Siegert et al. 
        2014). EAB is now present in 37 U.S. states and six Canadian provinces 
        (EPPO 2025, USDA-APHIS 2025). Upon hatching, eggs laid by adult beetles 
        in ash bark crevices burrow into the tree to feed on the inner phloem, 
        outer xylem, and cambium, where young larvae or pre-pupae overwinter in 
        serpentine larval galleries (Tluczek et al. 2011, Poland et al. 2015). 
        This feeding usually results in the death of the tree within about six 
        years (Knight et al. 2013). EAB’s cryptic nature, in which all life 
        stages except for the adult beetle are inside of trees, makes early 
        detection of this pest extremely difficult (Haack et al. 2002, 
        USDA-APHIS 2025)."),
        
        br(),
        
        p("All North American ash species are vulnerable to EAB, though blue ash 
        (F. quadrangulata Michaux) appears to be less preferred (Poland et al. 
        2015). In its native range, EAB generally attacks trees that are already 
        stressed (reviewed by Tluczek et al. 2011). In North America, it attacks 
        both healthy and stressed trees, though stressed trees produce higher 
        numbers of adults (Poland and McCullough 2006, Tluczek et al. 2011). 
        White fringetree [Chionanthus virginicus L. (Oleaceae)], and olive 
        [Olea europaea L. (Oleaceae)], both of which are in the same family as 
        Fraxinus spp., are possible hosts for EAB; however, insects may exhibit 
        higher mortality rates on these species (Rutledge and Arango-Velez 2017, 
        Peterson and Cipollini 2020). The financial impact of EAB in the U.S. is 
        estimated to be in the billions of dollars (Aukema et al. 2011). 
        Additionally, the widespread loss of ash trees has resulted in decreased 
        biodiversity and lost ecosystem services (Schrader et al. 2021).")
      ),
      
      ##### ** False codling moth #####
      accordion_panel(
        HTML("<b>False codling moth</b> (<i>Thaumatotibia leucotreta</i>)"),
        
        p("Native to sub-saharan Africa, the false codling moth (FCM), 
        Thaumatotibia leucotreta Meyrick (Lepidoptera: Tortricidae), is a highly 
        polyphagous pest now present throughout most of Africa and Israel 
        (Carstens and Moore 2020). Economically important hosts include avocado, 
        certain Citrus spp., corn, cotton, eggplants, grapes, stonefruit, 
        peppers, and cut roses (EPPO 2013, van de Vossenberg 2013). FCM 
        completes five larval instars, which cause damage by boring into plant 
        fruit before forming cocoons in the soil (NAPPFAST 2003). In 2008, a 
        single adult FCM male was discovered in the wild in California and 
        subsequently eradicated (Gilligan et al. 2011). If established in the 
        U.S., FCM could cause significant economic damage 
        (Venette et al. 2003).")
      ),
      
      ##### ** Honeydew moth #####
      accordion_panel(
        HTML("<b>Honeydew moth</b> (<i>Cryptoblabes gnidiella</i>)"),
        
        p("Native to the Mediterranean region, the honeydew moth (CGN), 
        Cryptoblabes gnidiella (Lepidoptera: Pyralidae), is a highly polyphagous 
        primary and secondary pest of many economically important crops, 
        including avocado, citrus, corn, cotton, grape, loquat, pomegranate, 
        rice, and wheat (Silva and Mexia 1999, Molet 2013). The pest is usually 
        associated with coccoids and pseudococcids, the honeydew of which CGN 
        larvae feed on, but CGN can also directly harm fruit though the 
        particular damage is highly host-species specific (Avidov and Gothilf 
        1960, Yehuda 1991, Silva and Mexia 1999, Molet 2013). Native to the 
        Mediterranean region, CGN has spread throughout many southern European 
        and northern and southern African countries, as well as Brazil, Fiji, 
        India, Malaysia, New Zealand, Uruguay, and Hawaii in the United States 
        (EPPO 2025, Molet 2013). While not yet established in the coterminous 
        U.S., it has been intercepted hundreds of times at ports of entry, often 
        from countries where it is not known to be established (Molet 2013, 
        Velez-Gavilan 2023). CGN lacks a true diapause, but overwinters in 
        either the larval or pupal stages (Avidov and Gothilf 1960, Molet et al. 
        2013, Lucchi et al. 2019).")
      ),
      
      ##### ** Japanese beetle #####
      accordion_panel(
        HTML("<b>Japanese beetle</b> (<i>Popillia japonica</i>)"),
        p("Native to Japan, the Japanese beetle (JPB), Popillia japonica Newman 
      (Coleoptera: Scarabaeidae), is a highly polyphagous pest with more than 
      400 host plants, including food crops, fruit trees, turfgrass, and 
      ornamental plants (Fleming 1972,  EPPO 2020, Tayeh et al. 2023). Since its 
      first U.S. detection in 1916 in New Jersey, the beetle has become 
      widespread throughout the eastern and central U.S. as well as parts of 
      eastern Canada (Dickerson and Weiss 1918, Fleming 1972, EPPO 2020, Althoff 
      and Rice 2022). Outbreaks in Colorado and California were eradicated 
      (Althoff and Rice 2022); however, JPB is established in a small number of 
      locations in the Pacific Northwest, including in British Columbia, 
      Washington, and Oregon (EPPO 2020, Stoven et al. 2021, Zhu et al. 2023). 
      The pest is also present in parts of Europe and eastern Russia and has 
      been reported in India (India Biodiversity Portal 2016, EPPO 2020). The 
      beetle is univoltine or semivoltine (2-year life cycle) depending on local 
      climatic conditions (Fleming 1972, Vittum 1986, EPPO 2020). Larvae 
      overwinter as second or third instars in the soil, typically beneath 
      managed turfgrass areas like lawns, pasture, and golf courses. Total 
      associated costs of JPB in the U.S. are estimated at $460 million 
      annually, with $234 million a year spent on control and turf replacement 
      costs (Fleming 1972, USDA-APHIS 2015).")
      ),
      
      ##### ** Japanese pinesawyer beetle #####
      accordion_panel(
        HTML("<b>Japanese pinesawyer beetle</b> (<i>Monochamus alternatus</i>)"),
        
        p("The Japanese pine sawyer beetle (JPSB), Monochamus alternatus Hope 
      (Coleoptera: Cerambycidae), is a major vector of nematodes that cause pine 
      wilt disease (PWD) (Vicente et al. 2012, EPPO 2024). Native to mainland 
      China, Taiwan, Laos, Korea, and Japan, the vector JPSB has spread to South 
      Korea and Vietnam (Kobayashi et al. 1984, Ma et al. 2006, EPPO 2024). 
      Adult beetles carrying the nematodes, namely North American-native 
      Bursaphelencus xylophilus (Steiner and Buhrer) Nickle (Nematoda: 
      Aphelenchoididae), feed upon and infect healthy pine trees, which will 
      show symptoms of infection due to xylem blockage caused by the nematode in 
      about three weeks (Togashi and Magira 1981, Kobayashi et al. 1984, Vicente 
      et al. 2012). JPSB beetles oviposit in the diseased tree, producing larvae 
      that feed under the bark before diapausing as a fourth or fifth instar in 
      the xylem or sapwood (Kobayashi et al. 1984, Ma et al. 2006, An et al. 
      2019, Togashi 2021). Before adult emergence, the nematodes congregate 
      around callow JPSB adults, repeating the cycle (Kobayashi et al. 1984). 
      While B. xylophilus is native to North America and is rarely pathogenic to 
      trees in its native range, JPSB also vectors other nematodes not known to 
      occur in North America (CAPS 2013, An et al. 2019). In regions invaded by 
      B. xylophilus, such as Portugal and Korea, PWD has resulted in millions of 
      dollars of damage to forest products (Vicente et al. 2012, An et al. 
      2019). JPSB host plants are usually gymnosperms or are from the Pinus, 
      Abies, Picea, Larix and Cedrus families, though Malus spp. and Acer spp. 
      are also possible hosts (Kobayashi et al. 1984, Ma et al. 2006, Hu et al. 
      2013).")
      ),
      
      ##### ** Light brown apple moth #####
      accordion_panel(
        HTML("<b>Light brown apple moth</b> (<i>Epiphyas postvittana</i>)"),
        p("Native to Australia, the light brown apple moth (LBAM), Epiphyas 
        postvittana (Walker) (Lepidoptera: Tortricidae), is invasive in the 
        United States, the United Kingdom, New Zealand, New Caledonia, and the 
        Azores, with multiple interceptions reported in other countries 
        (Danthanarayana 1975, EPPO 2024, Zhang et al. 2024). The highly 
        polyphagous pest has over 500 reported host plants, though its economic 
        impacts have been greatest for apple, pears, and grapes (Brinkerhoff 
        2011). Due to a lack of diapause or other synchronizing factors, such as 
        photoperiod or temperature, LBAM exhibits overlapping generations 
        (Sullivan et al. 2014, Buergi et al. 2011). LBAM infestation can result 
        in market access issues due to the risks of transporting live larvae on 
        a large variety of host plants (Suckling et al. 2014). The pests’s 
        distribution in the U.S. is limited to Hawaii, where it was first 
        reported in 1893, and in California, where it was first confirmed in 
        2007 and now persists mainly around San Francisco and along the coast 
        (Zimmerman 1978, Suckling and Brockerhoff 2010, Barker et al. 2020).")
      ),
      
      ##### ** Oak ambrosia beetle #####
      accordion_panel(
        HTML("<b>Oak ambrosia beetle</b> (<i>Platypus quercivorus</i>)"),
        
        p("The oak ambrosia beetle (OAB), Platypus quercivorus Murayama 
        (Coleoptera: Platypodidae), is a forest pest and vector of its symbiont, 
        the pathogenic fungus, Raffaelea quercivora Kubono & Shin-Ito (Kubono 
        and Ito 2002). Japanese oak wilt disease (JOW) caused by this fungus 
        kills both healthy and stressed trees by blocking tracheary function 
        (Kamata et al. 2002, Kubono and Ito 2002, Davis et al. 2005, Kobayashi 
        and Ueda 2005). Host plants required to complete reproduction are 
        Quercus species and several other members of the Fagaceae family, 
        including chestnut (Castanea spp.), chinquapin (Castanopsis spp.), 
        and stone oaks (Lithocarpus spp.) (Davis et al. 2005). However, OAB may 
        attack trees of other species adjacent to an area of mass attack (Davis 
        et al. 2005). Females inoculate galleries with the fungus prior to 
        laying eggs, which the hatched larvae feed on (Kinuura 2002). If 
        pupation does not occur before hibernation, larvae hibernate in the 
        fifth star (Kinuura 1995, Kinuura 2002, USDA-APHIS 2011)."),
        
        br(),
        
        p("OAB is distributed throughout India, Indonesia, Japan, and Papua New 
        Guinea; however, R. quercivora has only been reported in Japan, where 
        the beetle-vectored fungus has caused significant mortality in oak trees 
        (Davis et al. 2005, USDA-APHIS 2011, EPPO 2020). OAB has a preference 
        for larger trees due to their higher water content, which has left 
        abandoned oak coppice forests in Japan particularly vulnerable to 
        infection (Kobayashi and Ueda 2005, Nakajima 2019, EPPO 2020). OAB and 
        JOW would cause considerable economic, environmental, and social impact 
        if introduced to the U.S., where there are 28 possible susceptible 
        species of oak (Davis et al. 2005, EPPO 2020).")
      ),
      
      ##### ** Old world bollworm #####
      accordion_panel(
        HTML("<b>Old world bollworm</b> (<i>Helicoverpa armigera</i>)"),
        
        p("The old world or cotton bollworm, Helicoverpa armigera (Hübner) 
      (Lepidoptera: Noctuidae) (OWBW), is a highly polyphagous pest of 
      agricultural crops from 68 different plant families, including chickpeas, 
      corn, cotton, tobacco, tomatoes, potatoes, and soybeans (Cunningham and 
      Zalucki 2014, EPPO 2020). Widespread throughout almost all of Europe, 
      Asia, Africa, and Australasia, OWBW began spreading through Central and 
      South America in 2013 (EPPO 2020). In 2015, several specimens were 
      detected in Florida, but populations did not establish (reviewed by 
      EPPO 2020). OWBW has high fecundity: female moths can lay up to 
      3,000-4,000 eggs, which can hatch in three days in optimal conditions, 
      while a generation can be completed in 30 days (reviewed by Silva et al. 
      2018, EPPO 2025). Up to 12 generations are completed per year under 
      optimal conditions in tropical regions, though an average three to five 
      are completed in Mediterranean and subtropical regions (EPPO 2025). 
      OWBW has the ability to migrate over great distances, even up to 2,000 km 
      if aided by wind (Behere 2007, reviewed by Silva et al. 2018, EPPO 2025). 
      It also is resistant to a number of insecticides and transgenic crops 
      (reviewed by EPPO 2025). An estimated $78 billion per year in crops could 
      be at risk of pest damage by OWBW is established in the U.S. (Kriticos et 
      al. 2015).")
      ),
      
      ##### ** Pine tree lappet moth #####
      accordion_panel(
        HTML("<b>Pine-tree lappet moth</b> (<i>Dendrolimus pini</i>)"),
        
        p("The pine-tree lappet moth, Dendrolimus pini Linnaeus (Lepidoptera: 
      Lasiocampidae) (PTLM), is an economically important pest of pine trees 
      that is native to Europe and Asia (Hardin and Suazo 2012). Its current 
      range includes Europe, Russia, Kazakhstan, Northern China, and Morocco 
      (Hardin and Suazo 2012, EPPO 2024). PTLM’s primary host is the Scots pine 
      (Pinus sylvestris), but it can successfully develop on 17 other species of 
      pine, Douglas fir (Pseudotsuga menziesii), and Eastern hemlock (Tsuga 
      canadensis), and may be able to successfully develop on Pinus spp. 
      outside of its current range (Hardin and Suazo 2012, Łukowski 2021). 
      However, host species may affect larval and pupal development rates 
      (Hardin and Suazo 2012, Łukowski 2021). Photoperiod triggers both diapause 
      after the third larval instar and emergence the following spring, after 
      which the seventh or eighth instar pupates (Winokur 1991, Hardin and 
      Suazo 2012). Surviving affected trees take several years to recover from 
      defoliation and are more susceptible to other forest pests (Hardin and 
      Suazo 2012). If introduced to the U.S., PTLM could cause significant 
      damage to forests dominated by pine and monoculture pin plantations, 
      resulting in economic damage to the timber and Christmas tree industries 
      (Hardin and Suazo 2012, Ray et al. 2016).")
      ),
      
      ##### ** Silver Y moth #####
      accordion_panel(
        HTML("<b>Silver Y moth</b> (<i>Autographa gamma</i>)"),
        
        p("Widespread throughout Europe, northern Africa, and Asia, the Silver Y 
        moth (SLYM), Autographa gamma Linnaeus (Lepidoptera: Noctuidae), is a 
        highly polyphagous, defoliating pest of cereals, Brassica spp., legumes, 
        tobacco, and other fruit and vegetable crops, especially sugarbeet 
        (Maceljski and Balarin 1972, Sullivan and Molet 2007, EPPO 2019, 
        Carneiro 2022). Adults migrate annually to northern breeding grounds 
        throughout Eurasia to escape the hot and dry conditions of Mediterranean 
        overwintering sites (Honěk et al. 2002, Chapman et al. 2012, Chapman et 
        al. 2015, Saulich et al. 2017, Becher and Revadi 2020). The number of 
        generations completed in Eurasia ranges from one to four, increasing as 
        latitude decreases (Saulich et al. 2017, Carneiro 2022). Without a true 
        diapause, SLYM overwinters in the third or fourth instar (Sullivan and 
        Molet 2007, Saulich et al. 2017, Carneiro 2022). Mass outbreaks of SLYM 
        in breeding areas occur sporadically, which have been correlated with 
        very wet weather (Maceljski and Balarin 1974, Carneiro 2022). SLYM has 
        been intercepted at U.S. ports hundreds of times and has a high 
        establishment risk if introduced (Sullivan and Molet 2007).")
      ),
      
      ##### ** Small tomato borer #####
      accordion_panel(
        HTML("<b>Small tomato borer</b> (<i>Neoleucinodes elegantalis</i>)"),
        
        p("The small tomato borer (STB), Neoleucinodes elegantalis (Guenée) 
        (Lepidoptera: Pyralidae), is an oligophagous pest of Solanum species, 
        including tomato, eggplant, red and green pepper, lulo/naranjilla, and 
        wild Solanum spp. (OEPP/EPPO 2015). Native to South America, STB has 
        spread throughout Mexico, Central America, and the Caribbean (OEPP/EPPO 
        2015, Díaz-Montilla 2013a). The pest occupies a wide range of climates 
        in South America, though its presence varies by host plant and altitude 
        (Díaz-Montilla 2013b). Larvae pass through five instars, of which the 
        third through fifth cause the most damage to fruit, with developmental 
        rates that may vary by host plant (Serrano Plaza et al. 1992, 
        Díaz-Montilla 2013a). STB does not appear to have any diapause or 
        overwintering stage and has continuous, overlapping generations that 
        generally increase with latitude (Serrano Plaza et al. 1992, Moraes and 
        Foerster 2015, Barker et al. 2020). If introduced to the United S., 
        areas with high levels of tomato and pepper production will be 
        particularly at risk (USDA-APHIS-PPQ 2024). STB is a major barrier to 
        the export of solanaceous products to the U.S. and the European Union 
        from South America (Díaz-Montilla 2013a, 2013b).")
      ),
      
      ##### ** Spotted lanternfly #####
      accordion_panel(
        HTML("<b>Spotted lanternfly</b> (<i>Lycorma delicatula</i>)"),
        
        p("The spotted lanternfly (SLF), Lycorma delicatula (White) (Hemiptera: 
      Fulgoridae), is a highly polyphagous planthopper that feeds on a wide 
      variety of agricultural and nonagricultural plants, including grape vines, 
      fruit and walnut trees, as well as ornamental trees (Chu 1930, Barringer 
      and Ciafré 2020, EPPO 2021). SLF adults damage plants directly by feeding 
      on plant sap, and  sooty mold caused by excrement can impede 
      photosynthesis and attract additional pests (Dara et al. 2015, Urban and 
      Leach 2023). Native to China, SLF was first detected in the U.S. in 2014 
      in Pennsylvania and has since spread to at least 20 eastern states (Urban 
      and Leach 2023, NYSIPM 2025). Over the past 20 years, it has also become a 
      major pest in South Korea (Han et al. 2008). Introduced populations of 
      tree-of-heaven [Ailanthus altissima (Mill.) Swingle], SLF’s preferred host 
      plant, has facilitated the invasion of the pest (Barringer and Ciafré 
      2020). In suburban landscapes, SLF can become a nuisance as thousands of 
      adults may swarm on trees (Urban and Leach 2023).")
      ),
      
      ##### ** Sunn pest #####
      accordion_panel(
        HTML("<b>Sunn pest</b> (<i>Eurygaster integriceps</i>)"),
        
        p("Sunn pest (SUNP, Eurygaster integriceps Puton, 1881 (Hemiptera: 
        Scutelleridae), is a serious, economically important pest of wheat, 
        barley, oats, rye, and sorghum throughout Eastern Europe, West Asia, 
        Central Asia, and North Africa (Critchley 1998, Mackesy and Moylett 2018, 
        EPPO 2021). Larvae and adults cause host plant death, arrest grain 
        development, or damage surviving wheat kernels by degrading the gluten 
        content (Paulian and Popov 1980, Critchley 1998). Bread prepared from 
        SUNP-attacked grain has low quality and digestibility (Paulian and Popov 
        1980). Without control measures, the pest can cause complete wheat crop 
        loss (Kivan and Kilic 2005). If introduced to the U.S., SUNP could cause 
        considerable economic damage to the wheat and barley harvests, valued at 
        $7.9 billion and $685 million in 2017, respectively (USDA-NASS 2019)."),
        
        br(),
        
        p("SUNP is a univoltine pest with two major lifecycle periods throughout 
        the year (Davari and Parker 2018). Adults spend the late summer in 
        aestivation and overwintering sites where they pass through obligatory 
        diapause and remain largely inactive until spring temperatures ca. 10 to 
        14°C trigger emergence and migration to cereal fields for reproduction 
        (Banks et al. 1961, Critchley 1998, Davari and Parker 2018). After the 
        completion of five instars and pupation, adults migrate about 10-20 km 
        back to hillside aestivation/overwintering sites, which are in the 
        southern part of the range at higher altitudes under bushes or in the 
        northern part of its range in deciduous Quercus forests (Paulian and 
        Popov 1980, Critchley 1998, Davari and Parker 2018). Regional 
        geographical features that alter temperature may affect SUNP migration 
        (Parker et al. 2011). SUNP has a wide climatic tolerance, with an 
        estimated cold and heat stress threshold of -30 °C to 40 °C, 
        respectively (Barker and Coop 2020).")
      ),
      
      ##### ** Tomato leaf miner #####
      accordion_panel(
        HTML("<b>Tomato leaf miner</b> (<i>Tuta absoluta</i>)"),
        
        p("The tomato leaf miner (TABS), Phthorimaea absoluta (Meyrick) 
          (formerly Tuta absoluta) (Lepidoptera: Gelechiidae), is a serious pest 
          of tomato and other solanaceous plants native to Peru (Biondi et al. 
          2018). The pest is now widespread throughout Central and South America 
          and has also invaded most of Europe, Africa, and Asia to as far as 
          South Korea (Biondi et al. 2018, EPPO 2025). In China, a median 
          dispersal rate of more than 1,000 km/day has been calculated (Xue et 
          al. 2025). In colder areas, TABS may persist in greenhouses (Desneux 
          et al. 2010, Gao et al. 2025). At early stages, TABS is difficult to 
          detect, and can cause 100% loss of tomato crops if left unmanaged 
          (Desneux et al. 2010, Biondi et al. 2018). TABS is multivoltine, with 
          10-12 generations per year in South America, two to five in Bulgaria, 
          and four in Turkey (Desneux et al. 2010, Mamay and Yanik 2012, 
          Karadjova et al. 2013). Thirteen overlapping annual generations and 
          year-round activity have been reported in Spain (Vercher Aznar et al. 
          2010). Larvae of four instars mine mesophyllic tissue from leaves 
          before pupating in soil or a cocoon (Desneux et al. 2010, Erdogan and 
          Babaroglu 2014). Its rapid global spread has led to extensive 
          synthetic insecticide usage, with associated harmful effects 
          (Desneux et al. 2011). According to previous climate suitability 
          modeling studies, the U.S., Mexico, and Canada–all top tomato 
          producers–are at high risk of invasion, which could increase tomato 
          prices (Desneux et al. 2011, Biondi et al. 2018).")
      )
    )
  )
)






# ---------- DEFINE SERVER -----------------------------------------------------

server <- function(input, output, session) {
  
  # Selected variable type
  observeEvent(input$pest, {
    
    current_value <- isolate(input$var_type)
    
    if (input$pest == "All 18 spp") {
      
      choices <- c(
        "Climate stress" = "climate",
        "Phenology" = "phenology"
      )
      
      # Reset invalid CLM selection
      if (current_value == "clm") {
        current_value <- "phenology"
      }
      
    } else {
      
      choices <- c(
        "Climate stress" = "climate",
        "Phenology" = "phenology",
        "All stress exclusion" = "clm"
      )
    }
    
    updateSelectInput(
      session,
      "var_type",
      choices = choices,
      selected = current_value
    )
    
  }, ignoreInit = TRUE)
  
  # Selected metric
  observeEvent(
    list(input$pest, input$var_type),
    {
      
      req(input$pest, input$var_type)
      
      current_value <- isolate(input$trend_metric)
      
      # --- CLM ---
      if (input$var_type == "clm") {
        
        shinyjs::hide("trend_metric_container")
        
        return()
        
      } else {
        
        shinyjs::show("trend_metric_container")
      }
      
      # --- All-species comparisons ---
      if (input$pest == "All 18 spp") {
        
        if (input$var_type == "phenology") {
          
          choices <- c(
            "Earlier adult emergence" = "species_num_adult",
            "Earlier egg hatch" = "species_num_egg"
          )
          
          if (!current_value %in% unname(choices)) {
            current_value <- "species_num_adult"
          }
          
        } else {
          
          choices <- c(
            "Decreasing cold stress" = "species_num_cold",
            "Increasing heat stress" = "species_num_heat"
          )
          
          if (!current_value %in% unname(choices)) {
            current_value <- "species_num_cold"
          }
        }
        
      } else {
        
        # --- Individual species ---
        choices <- c(
          "Change per year" = "sens",
          "Direction of trend" = "tau"
        )
        
        if (!current_value %in% unname(choices)) {
          current_value <- "sens"
        }
      }
      
      updateSelectInput(
        session,
        "trend_metric",
        choices = choices,
        selected = current_value
      )
      
    },
    ignoreInit = FALSE
  )
  
  #### * Check which variable is selected ####
  # selected_variable <- reactive({
  #   
  #   req(input$var_type)
  #   
  #   # If CLM
  #   if (input$var_type == "clm") {
  #     return("All Stress Excl")
  #   }
  # 
  #   # If climate selected, return selected climate variable
  #   if (input$var_type == "climate") {
  #     req(input$clim_variable)
  #     return(input$clim_variable)
  #   }
  #   
  #   # If phenology selected, return selected phenology variable
  #   if (input$var_type == "phenology") {
  #     req(input$phenology)
  #     return(input$phenology)
  #   }
  #   
  # })
  
  selected_variable <- reactive({
    # Use a default if the input hasn't initialized yet
    v_type <- if (is.null(input$var_type)) "phenology" else input$var_type
    
    if (v_type == "clm") {
      return("All Stress Excl")
    }
    
    if (v_type == "climate") {
      # Default to Cold Stress if clim_variable is null
      return(if (is.null(input$clim_variable)) "Cold Stress" else input$clim_variable)
    }
    
    if (v_type == "phenology") {
      # Default to First Adult Emergence if phenology is null
      # Ensure this matches the string in your raster_lookup exactly
      return(if (is.null(input$phenology)) "First Adult Emergence" else input$phenology)
    }
  })
  
  ### ---------------------------------------------------------------------- ###
  
  #### * Get row with raster of interest ####
  selected_row <- reactive({
    
    req(input$pest, input$year_range, input$var_type)
    
    # Comparisons
    if (input$pest == "All 18 spp") {
      
      # Comparisons rasters
      row <- raster_lookup %>%
        dplyr::filter(
          model_type == "Comparisons",
          variable == selected_variable(),
          year == input$year_range
        )
    
    # CLM
    } else if (input$var_type == "clm") {
      
      row <- raster_lookup %>%
        dplyr::filter(
          model_type == "CLM",   
          common_name == input$pest,
          year == input$year_range
        )
    
    # MK 
    } else {
      
      row <- raster_lookup %>%
        dplyr::filter(
          model_type == "MK_trends",
          common_name == input$pest,
          variable == selected_variable(),
          year == input$year_range
        )
      
    }
    
    validate(need(nrow(row) == 1, "No raster found"))
    
    row
  })
  
  
  ### ---------------------------------------------------------------------- ###
  
  # Note: 1 = tau, 2 = sen, and 3 = p-value, as organized in the .tif file
  
  #### * Collect raster info ####
  
  # P-value
  #pest_raster_pval <- reactive({ rast_import(selected_row()$file_path, 3) })
  
  pest_raster_pval <- reactive({
    
    req(selected_row())
    
    # No p-values for comparisons or CLM
    if (input$pest == "All 18 spp" || input$var_type == "clm") {
      return(NULL)
    }
    
    rast_import(selected_row()$file_path, 3)
  })
  
  # Mask out non-significant areas if significance mask is selected
  # Only apply to trend layers (tau/sens)
  # Tau
  pest_raster_tau <- reactive({
    
    # Force dependency
    sig_only <- input$sig_only
    
    r <- rast_import(selected_row()$file_path, 1)
    
    if (input$pest == "All 18 spp" || input$var_type == "clm") {
      return(r)
    }
    
    apply_sig_mask(r, pest_raster_pval(), sig_only)
    
  })
  
  # Sen
  pest_raster_sen <- reactive({
    
    # Force dependency
    sig_only <- input$sig_only
    
    r <- rast_import(selected_row()$file_path, 2)
    
    if (input$pest == "All 18 spp" || input$var_type == "clm") {
      return(r)
    }
    
    apply_sig_mask(r, pest_raster_pval(), sig_only)
    
  })
  
  # CLM - only 1 layer
  pest_raster_clm <- reactive({ rast_import(selected_row()$file_path, 1) })
  
  # Note: 1 = # of species, 2 = median, 3 = min, 4 = max..., as organized in the .tif file
  
  # Comparisons - sum across 18 species
  pest_raster_sum <- reactive({ rast_import(selected_row()$file_path, 1) })
  pest_raster_slopemed <- reactive({ rast_import(selected_row()$file_path, 6) })
  pest_raster_slopese <- reactive({ rast_import(selected_row()$file_path, 7) })
  pest_raster_slopemin <- reactive({ rast_import(selected_row()$file_path, 8) })
  pest_raster_slopemax <- reactive({ rast_import(selected_row()$file_path, 9) })
  
  # Show checkbox "Show significant areas only" only for individual spp
  observeEvent(list(input$pest, input$var_type), {
    
    if (
      isTRUE(input$pest == "All 18 spp") ||
      isTRUE(input$var_type == "clm")
    ) {
      updateCheckboxInput(session, "sig_only", value = FALSE)
    }
    
  }, ignoreInit = TRUE)
  
  ### ---------------------------------------------------------------------- ###
  
  #### * Reactive for metric ####
  selected_trend <- reactive({
    
    # Force reactivity to significance mask
    sig_only <- input$sig_only
    
    v_type <- if (is.null(input$var_type)) {
      "phenology"
    } else {
      input$var_type
    }
    
    trend_metric <- if (is.null(input$trend_metric)) {
      "sens"
    } else {
      input$trend_metric
    }
    
    req(selected_row())
    
    # --- Comparisons ---
    if (input$pest == "All 18 spp") {
      
      return(list(
        rast = pest_raster_sum(),
        title = "Num. species with significant trend"
      ))
    }
    
    # --- CLM ---
    if (v_type == "clm") {
      
      return(list(
        rast = pest_raster_clm(),
        title = "Beta coefficient"
      ))
    }
    
    sens_title <- if (v_type == "phenology") {
      "Change (days/year)"
    } else {
      "Change (units/year)"
    }
    
    if (trend_metric == "sens") {
      
      return(list(
        rast = pest_raster_sen(),
        title = sens_title
      ))
      
    } else {
      
      return(list(
        rast = pest_raster_tau(),
        title = "Direction of trend"
      ))
      
    }
    
  })
  
  ### ---------------------------------------------------------------------- ###
  
  # 1. Initialize the base map once (stops the flashing)

  # Calculate initial CONUS bounds using your new function
  conus_extent <- assign_extent("CONUS")
  conus_bounds <- ext_to_bounds(conus_extent)
  
  # Initial Map Render WITH default raster
  # Default is ALB First Adult Emergence sens slope for 1981-2025
  output$map <- renderLeaflet({
    
    # Default startup raster
    startup_row <- raster_lookup %>%
      dplyr::filter(
        common_name == "Asian longhorned beetle",
        model_type == "MK_trends",
        variable == "First Adult Emergence",
        year == "1981-2025"
      )
    
    req(nrow(startup_row) > 0)
    
    # Load raster
    startup_rast <- rast_import(startup_row$file_path[1], 2)
    
    # Palette
    pal_obj <- make_palette(startup_rast, "sens")
    
    pal_func <- pal_obj$pal
    
    # Legend
    legend_html <- create_legend_html(
      "sens",
      "Change (days/year)",
      pal_func,
      pal_obj$limits
    )
    
    # Build initial map
    produce_map_base(conus_bounds) %>%
      
      addRasterImage(
        startup_rast,
        colors = pal_func,
        opacity = 0.9,
        layerId = "Value",
        project = TRUE
      ) %>%
      
      addControl(
        html = HTML(legend_html),
        position = "bottomright"
      )
    
  })
  
  # Observer to toggle County Lines based on zoom level
  observe({
    req(input$map_zoom)
    
    leafletProxy("map") %>%
      apply_boundary_visibility(input$map_zoom)
  })

  
  ### ---------------------------------------------------------------------- ###
  
  #### * Reactive palette ####
  
  # For legend
  palette_reactive <- reactive({
    
    req(selected_trend(), input$pest)
    
    # Default metric during startup / UI re-render
    trend_metric <- input$trend_metric %||% "sens"
    
    trend <- selected_trend()
    
    req(trend$rast)
    
    make_palette(
      trend$rast,
      trend_metric
    )
    
  })
  
  ### ---------------------------------------------------------------------- ###
  
  #### * Update map when pest changes ####
  observeEvent(
    list(selected_trend(), input$pest, input$region, 
         input$var_type, input$year_range, input$sig_only), {
    
    # Required inputs
    req(input$pest, input$region, input$var_type, 
        input$year_range)
  
    trend_metric <- input$trend_metric %||% "sens"
    
    pal_obj <- palette_reactive()
    
    if (is.null(pal_obj)) return()
    
    trend <- selected_trend()
    
    req(trend$rast)
    
    # Explicitly extract the function from the list
    pal_func <- pal_obj$pal
    
    # Generate the legend HTML
    legend_html <- create_legend_html(
      trend_metric,
      trend$title,
      pal_func,
      pal_obj$limits
    )

    # Immediately clear old legend
    leafletProxy(
      "map",
      deferUntilFlush = FALSE
    ) %>%
      clearControls()
    
    # Immediately remove old raster
    leafletProxy(
      "map",
      deferUntilFlush = FALSE
    ) %>%
      clearImages()
    
    # Add new raster, controls, and boundaries
    proxy <- leafletProxy("map") %>% 
      # Add raster
      addRasterImage(
        trend$rast,
        colors = pal_func,
        opacity = 0.9,
        layerId = "Value",
        project = TRUE
      ) %>%
      # Add legend
      addControl(
        html = HTML(legend_html),
        position = "bottomright"
      )
    
    # # Zoom to selected extent (all regions inc. CONUS)
    # ext <- assign_extent(input$region)
    # 
    # proxy %>% fitBounds(
    #   xmin(ext),
    #   ymin(ext),
    #   xmax(ext),
    #   ymax(ext)
    # )
  }, ignoreInit = FALSE)
  
  # Zoom to selected extent
  observeEvent(input$region, {
    
    ext <- assign_extent(input$region)
    
    leafletProxy("map") %>%
      fitBounds(
        xmin(ext),
        ymin(ext),
        xmax(ext),
        ymax(ext)
      )
    
  }, ignoreInit = TRUE)
  
  ### ---------------------------------------------------------------------- ###
  
  #### * Download map as PNG ####
  
  # Different file names used for comparison vs. individual spp
  output$download_map <- downloadHandler(
    filename = function() {
      
      # Use different file names for comparison vs. individual spp maps
      if (grepl("species_num", input$trend_metric)) {
        
        # Format text for comparison type
        comp_type <- assign_comparison(input$trend_metric)
        comp_type <- gsub(" ", "_", comp_type)
        comp_type <- tolower(gsub("\\(no._species\\)", "", comp_type))
        
        paste0("DDRP_map_18spp_", comp_type, input$year_range, ".png")
        
      } else {
        
        abbrev <- species_abbrev[[input$pest]]
        # fallback if something missing
        if (is.null(abbrev)) abbrev <- gsub(" ", "_", input$pest)
        
        paste0("DDRP_map_", abbrev, "_", input$var_type, "_", 
               input$trend_metric, "_", input$year_range, ".png")
        }
    },
    
    content = function(file) {
      
      trend <- selected_trend()
      pal_obj <- palette_reactive()
      req(trend, pal_obj, input$map_bounds)
      
      # Map bounds and zoom level
      bounds <- input$map_bounds
      zoom   <- input$map_zoom %||% 5
      
      # --- Detect comparison mode ---
      is_comparison <- grepl("species_num", input$trend_metric)
      
      center_lng <- (bounds$west + bounds$east) / 2
      center_lat <- (bounds$north + bounds$south) / 2
      
      # START CLEAN (no groups)
      m <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
        addProviderTiles(providers$CartoDB.Voyager) %>%
        setView(
          lng = center_lng,
          lat = center_lat,
          zoom = zoom
        )
      
      # 🔥 ADD ONLY WHAT SHOULD BE VISIBLE
      if (zoom >= 6.5) {
        m <- m %>%
          addPolylines(
            data = us_counties,
            opacity = 0.4,
            color = "#777777",
            weight = 0.5
          )
      } else {
        m <- m %>%
          addPolylines(
            data = us_states,
            opacity = 0.6,
            color = "#444444",
            weight = 1.2
          )
      }
      
      # Raster
      m <- m %>%
        addRasterImage(
          trend$rast,
          colors = pal_obj$pal,
          opacity = 0.9,
          project = TRUE
        )
      
      # Fix legend title for comparison mode 
      title_text <- if (is_comparison) {
        assign_comparison(input$trend_metric)
      } else {
        trend$title
      }
      
      # 🔥 LEGEND (must be baked in)
      legend_html <- create_legend_html(
        input$trend_metric,
        title_text,
        pal_obj$pal,
        pal_obj$limits
      )
      
      m <- htmlwidgets::prependContent(
        m,
        htmltools::tagList(
          
          # 🔹 Load font + scoped CSS
          htmltools::tags$head(
            htmltools::tags$link(
              rel = "stylesheet",
              href = "https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap"
            ),
            htmltools::tags$style(htmltools::HTML("
        .custom-legend {
          font-family: 'Roboto', sans-serif;
        }
      "))
          ),
          
          # 🔹 Legend container (now with class)
          htmltools::tags$div(
            class = "custom-legend",
            style = "position:absolute; bottom:20px; right:20px; z-index:9999;",
            htmltools::HTML(legend_html)
          )
        )
      )
      
      # Delay to ensure rendering
      m <- htmlwidgets::onRender(m, "
  function(el, x) {
    return new Promise(resolve => setTimeout(resolve, 4000));
  }
")
      # Export map using mapshot2
      mapview::mapshot2(
        m,
        file = file,
        delay = 6,
        vwidth  = session$clientData$output_map_width,
        vheight = session$clientData$output_map_height
      )
    }
  )
  
  ### ---------------------------------------------------------------------- ###
  
  #### * Settings on map bounds (prevent over-zooming) ####
  
  # Observe bounds of current map in order to
  # keep the bounds from resetting when map selected changes
  
  #observeEvent(input$map_bounds, {
    
    # Map zoom can't be entire area (level 6) or get weird behavior
    # (non-stop loop of zooming) when select risk maps multiple times
 #   bounds <- input$map_bounds
 #   mapzoom <- input$map_zoom
    
    # Keep bounds from resetting
 #   if (mapzoom > 6) {
      
      # Update map
 #     leafletProxy("map") %>%
 #       fitBounds(bounds$west, bounds$south, bounds$east, bounds$north) %>%
 #       clearGroup("click_marker")
      
      
   # }
  #})
  
  counties_visible <- reactiveVal(FALSE)
  
  observe({
    
    zoom <- input$map_zoom
    if (is.null(zoom)) return()
    
    show <- zoom >= 6
    
    if (show && !counties_visible()) {
      
      leafletProxy("map") %>%
        addPolylines(
          data = us_counties,
          color = "#666666",
          weight = 0.4,
          opacity = 0.6,
          group = "Counties"
        ) %>% 
        clearGroup("States")
      
      counties_visible(TRUE)
      
    } else if (!show && counties_visible()) {
      
      leafletProxy("map") %>%
        clearGroup("Counties")
      
      counties_visible(FALSE)
    }
  })
  ### ---------------------------------------------------------------------- ###
  
  #### * Adjust to another region when selected ####
  observeEvent(input$region, {
    
    # Check
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
      ) %>%
      clearGroup("click_marker")
    
  })
  
  
  
  ### ---------------------------------------------------------------------- ###
  
  #### * Reactive for where person clicked on map ####
  
  # NULL until click
  click_val <- reactiveVal(NULL)
  
  # When clicked
  observeEvent(input$map_click, {
    click_val(input$map_click)
  }, ignoreInit = TRUE)
  
  # If anything changes, make it null again
  observeEvent(
    list(input$year_range, input$pest, input$var_type,
         input$clim_variable, input$phenology, input$trend_metric),
    {
      click_val(NULL)
    },
    ignoreInit = TRUE
  )
  
  output$has_click <- renderText({
    if (is.null(click_val())) {
      ""
    } else {
      "TRUE"
    }
  })
  
  outputOptions(output, "has_click", suspendWhenHidden = FALSE)
  
  ### ---------------------------------------------------------------------- ###
  
  #### * Update panel that holds location click outputs ####
   observeEvent(click_val(), {
    req(click_val())
    
    is_comparison <- grepl("species_num", input$trend_metric)
    trend <- selected_trend()
    req(trend$rast)
    
    click <- click_val()
    
    # Add marker where user clicked
    leafletProxy("map") %>%
      clearGroup("click_marker") %>% 
      addMarkers(
        lng = click$lng,
        lat = click$lat,
        group = "click_marker"
      )
    
    # Store coordinates
    xy <- data.frame(x = click$lng, y = click$lat)
    
    # Extractions for all species comparison only
    if (is_comparison) {
      value <- terra::extract(pest_raster_sum(), xy)[1,2]
    } else {
      if (input$var_type == "clm") {
        value <- terra::extract(pest_raster_clm(), xy)[,2]
      } else {
        value <- as.numeric(terra::extract(trend$rast, xy)[1,2])
      }
    }
    
    if (is.na(value) || length(value) == 0) value <- NA
    
    # Text UI elements
    output$clicked_years <- renderUI({
      req(input$map_click, cancelOutput = TRUE)
      tags$div(tags$b("Year range:"), input$year_range)
    })
    
    output$clicked_latlon <- renderUI({
      req(input$map_click, cancelOutput = TRUE)
      tags$div(tags$b("Location:"), round(click$lat, 4), ", ", round(click$lng, 4))
    })
    
    output$clicked_pest <- renderUI({
      req(input$map_click, cancelOutput = TRUE)
      tags$div(tags$b("Pest selected:"), input$pest)
    })
    
    variable_text <- if (is_comparison) {
      assign_comparison(input$trend_metric)
    } else {
      str_to_sentence(selected_variable())
    }
    
    if (is_comparison) {
      unit_text <- if (grepl("stress", input$trend_metric)) "units" else "days"
      
      # Re-extract local temporary text representations safely for UI panels
      text_med <- round(terra::extract(pest_raster_slopemed(), xy)[1,2], 2)
      text_se  <- round(terra::extract(pest_raster_slopese(), xy)[1,2], 2)
      text_min <- round(terra::extract(pest_raster_slopemin(), xy)[1,2], 2)
      text_max <- round(terra::extract(pest_raster_slopemax(), xy)[1,2], 2)
      
      output$clicked_variable <- renderUI({
        req(input$map_click, cancelOutput = TRUE)
        tags$div(tags$b("Variable:"), variable_text)
      })
      
      output$clicked_slopemed  <- renderUI({
        req(input$map_click, cancelOutput = TRUE)
        tags$div(tags$b(paste0("Median change (", unit_text, "/year): ")), 
                 paste0(text_med, " (SE = ", text_se, ")"))
      })
      
      output$clicked_sloperange  <- renderUI({
        req(input$map_click, cancelOutput = TRUE)
        tags$div(tags$b(paste0("Range (", unit_text, "/year): ")), 
                 paste0(text_min, " to ", text_max))
      })
    } else {
      output$clicked_variable <- renderUI({
        req(input$map_click, cancelOutput = TRUE)
        tags$div(tags$b("Variable:"), variable_text)
      })
    }
    
    output$clicked_value <- renderUI({
      req(input$map_click, cancelOutput = TRUE)
      
      info_text <- if (input$trend_metric == "tau") {
        "Kendall’s τ indicates direction..."
      } else if (input$trend_metric == "sens") {
        "Sen’s slope estimates..."
      } else if (is_comparison) {
        "The number of species..."
      } else {
        "The cumulative link model..."
      }
      
      tags$div(
        tags$b(paste0(trend$title, ": ")),
        if (is.na(value)) "No data" else round(value, 3),
        tags$span(
          tags$i(class = "bi bi-info-circle"), style = "cursor:pointer;",
          `data-bs-toggle` = "popover", `data-bs-trigger` = "hover",
          `data-bs-placement` = "right", `data-bs-html` = "true",
          title = "About the statistic", `data-bs-content` = info_text
        )
      )
    })
    
    output$clicked_pval <- renderUI({
      req(input$map_click, cancelOutput = TRUE)
      if (input$var_type == "clm" || is_comparison) return(NULL)
      pval_val <- terra::extract(pest_raster_pval(), xy)[1,2]
      
      tags$div(
        tags$b("P-value:"), signif(pval_val, 3),
        tags$span(
          tags$i(class = "bi bi-info-circle"), style = "cursor:pointer;",
          `data-bs-toggle` = "popover", `data-bs-trigger` = "hover",
          `data-bs-placement` = "right", `data-bs-html` = "true",
          title = "About the p-value",
          `data-bs-content` = HTML("The p-value describes the strength...")
        )
      )
    })
  })
    
    ### ---------------------------------------------------------------------- ###
    
    #### * Generate a trend plot for location ####
  ### ---------------------------------------------------------------------- ###
  
  #### * Generate a trend plot for location ####
  
  # 1. INDIVIDUAL PEST TREND PLOT DATA GENERATOR
  loc_plot_obj_indiv <- reactive({
    # Precursor message
    validate(need(click_val(), "Click on the map to generate a plot!"))
    
    # Require map click and verify it's not a comparison view
    req(click_val(), cancelOutput = TRUE)
    if (grepl("species_num", input$trend_metric)) return(NULL)
    
    click <- click_val()
    
    # For checking on Console
    message("Rendering individual plot...")
    
    # Convert years from character to index (to pull in files)
    range_vals <- strsplit(input$year_range, "-")[[1]]
    yrs <- as.numeric(range_vals[1]):as.numeric(range_vals[2])
    
    # Variable name modifications
    var_raw <- selected_variable()
    label <- tolower(gsub("_", " ", var_raw))
    is_pem <- grepl("First", var_raw)
    
    # Spatial point
    site <- terra::vect(
      data.frame(x = click$lng, y = click$lat),
      geom = c("x", "y"),
      crs = "EPSG:4326"
    )
    
    # File lookup
    files <- raster_lookup %>%
      dplyr::filter(
        model_type == "DDRP",
        common_name == input$pest,
        variable == var_raw,
        year %in% yrs
      ) %>%
      dplyr::arrange(year)
    
    if (nrow(files) == 0) return(NULL)
    
    # Load rasters
    rasts <- lapply(files$file_path, rast_import)
    rasts <- terra::rast(rasts)
    names(rasts) <- files$year
    
    site <- terra::project(site, rasts)
    
    # Extract data
    site_data <- terra::extract(rasts, site) %>%
      dplyr::select(-ID) %>%
      tidyr::pivot_longer(
        cols = everything(),
        names_to = "year",
        values_to = "value") %>%
      dplyr::mutate(
        year = as.numeric(year),
        value = as.numeric(value))
    
    validate(need(nrow(site_data) > 0, "No data available for this location"))
    
    # Axis setup
    x_brks <- if (length(yrs) == 20) 2 else 5
    yr_first <- if (min(yrs) == 1981) 1980 else min(yrs)
    yr_last  <- if (max(yrs) >= 2024) 2025 else max(yrs)
    breaks_func <- scales::breaks_pretty(n = 6)
    y_brks <- breaks_func(site_data$value)
    ymax_pt <- max(site_data$value, na.rm = TRUE)
    ymax_df <- dplyr::slice(dplyr::filter(site_data, value == ymax_pt), 1) %>%
      dplyr::mutate(year = max(site_data$year), value = NA)
    
    # PEM date conversion
    if (is_pem) {
      doys <- c(
        min(terra::values(rasts), na.rm = TRUE),
        max(terra::values(rasts), na.rm = TRUE)
      )
      
      range_date <- as.Date(doys - 1, origin = "2025-01-01")
      all_dates <- format(seq(range_date[1], range_date[2], by = 1), "%b-%d")
      dates_df <- data.frame(
        value = seq(doys[1], doys[2], by = 1),
        dates = all_dates
      )
      
      site_data <- dplyr::left_join(site_data, dates_df, by = "value")
    }
    
    if (input$var_type == "clm") {
      p <- ggplot(site_data, aes(x = year, y = value)) +
        geom_point() +
        geom_line(color = "steelblue") +
        scale_x_continuous(limits = c(yr_first, yr_last),
                           breaks = seq(yr_first, yr_last, x_brks)) +
        labs(title = paste("Predicted stress exclusion for", input$pest),
             x = "Year",
             y = "Climate Stress Exclusion") +
        scale_y_continuous(
          breaks = c(-2, -1, 0),
          labels = c("Severe", "Moderate", "None")
        ) +
        theme_bw() +
        custom_theme_indiv +
        theme(legend.position = "none")
      
      return(p)
      
    } else {
      # If no variation
      if (all(site_data$value == 0 | is.na(site_data$value))) {
        p <- ggplot(site_data, aes(x = year, y = value)) +
          geom_point() +
          geom_line(color = "steelblue") +
          scale_x_continuous(limits = c(yr_first, yr_last),
                             breaks = seq(yr_first, yr_last, x_brks)) +
          scale_y_continuous(breaks = y_brks) +
          labs(title = paste("Predicted", label, "for", input$pest),
               x = "Year",
               y = label) +
          ggrepel::geom_text_repel(data = ymax_df,
                                   aes(x = max(site_data$year) + 1,
                                       y = ymax_pt + 1.5,
                                       label = "No trend"),
                                   size = 4.5) +
          theme_bw() +
          custom_theme_indiv +
          theme(legend.position = "none")
        
        # If there is variation
      } else {
        # Mann-Kendall
        pwmk_test <- modifiedmk::pwmk(site_data$value)
        slope <- round(as.numeric(pwmk_test[["Sen's Slope"]]), 4)
        pval  <- round(as.numeric(pwmk_test[["P-value"]]), 4)
        median_x <- median(site_data$year, na.rm = TRUE)
        median_y <- median(site_data$value, na.rm = TRUE)
        intercept <- median_y - slope * median_x
        
        # Plot
        p <- ggplot(site_data, aes(x = year, y = value)) +
          geom_point() +
          geom_line(color = "steelblue") +
          geom_abline(intercept = intercept,
                      slope = slope,
                      color = "red") +
          scale_x_continuous(limits = c(yr_first, yr_last),
                             breaks = seq(yr_first, yr_last, x_brks)) +
          scale_y_continuous(breaks = y_brks) +
          labs(title = paste("Predicted", label, "for", input$pest),
               x = "Year",
               y = label) +
          ggrepel::geom_text_repel(data = ymax_df,
                                   aes(x = max(site_data$year) + 1,
                                       y = ymax_pt + 1.5,
                                       label = paste0("Slope: ", slope, ", P-value: ", pval)),
                                   size = 4.5) +
          theme_bw() +
          custom_theme_indiv
      }
      
      # Replace DOY with dates for PEM
      if (is_pem) {
        valid_idx <- match(y_brks, dates_df$value)
        p <- p + scale_y_continuous(
          breaks = y_brks[!is.na(valid_idx)],
          labels = dates_df$dates[valid_idx[!is.na(valid_idx)]]
        ) +
          labs(y = "Date")
      }
      
      return(p)
    }
  })
  
  # Render individual plot
  output$loc_plot_indiv <- renderPlot({
    p <- loc_plot_obj_indiv()
    req(p)
    p
  })
  
  # Individual plot download handler
  output$download_plot_indiv <- downloadHandler(
    filename = function() {
      abbrev <- species_abbrev[[input$pest]]
      if (is.null(abbrev)) abbrev <- gsub(" ", "_", input$pest)
      
      if (input$var_type == "clm") {
        paste0("Trend_plot_", abbrev, "_", input$var_type, "_", input$year_range, ".png")
      } else {
        paste0("Trend_plot_", abbrev, "_", input$var_type, "_", input$trend_metric, "_", input$year_range, ".png")
      }
    },
    content = function(file) {
      req(loc_plot_obj_indiv()) 
      ggsave(file, plot = loc_plot_obj_indiv(), width = 9, height = 6, dpi = 300)
    }
  )
  
  
  # 2. SPECIES COMPARISON PLOT DATA GENERATOR
  loc_plot_obj_comp <- reactive({
    
    is_pest_all <- (input$pest == "All 18 spp")
    is_metric_all <- grepl("species_num", input$trend_metric)
    
    if (is_pest_all != is_metric_all) return(NULL)
    
    validate(need(click_val(), "Click on the map to generate a plot!"))
    
    req(click_val(), cancelOutput = TRUE)
    if (!grepl("species_num", input$trend_metric)) return(NULL)
    
    click <- click_val()
    xy <- data.frame(x = click$lng, y = click$lat)
    
    # For checking on Console
    message("Rendering comparison plot...")
    
    slopemed_val <- round(terra::extract(pest_raster_slopemed(), xy)[1,2], 2)
    slopese_val  <- round(terra::extract(pest_raster_slopese(), xy)[1,2], 2)
    slopemin_val <- round(terra::extract(pest_raster_slopemin(), xy)[1,2], 2)
    slopemax_val <- round(terra::extract(pest_raster_slopemax(), xy)[1,2], 2)
    
    variable_text <- assign_comparison(input$trend_metric)
    
    if (grepl("stress", input$trend_metric)) {
      ylab <- "Change (units/year)"
      plot_title <- if (grepl("cold", input$trend_metric)) {
        "Change (units/year) in cold stress across 18 spp."
      } else {
        "Change (units/year) in heat stress across 18 spp."
      }
    } else {
      ylab <- "Change (days/year)"
      plot_title <- if (grepl("adult", variable_text)) {
        "Change in adult emergence date across 18 spp."
      } else {
        "Change in egg hatch date across 18 spp."
      }
    }
    
    df <- data.frame(
      group = "Selected location",
      med = slopemed_val,
      se = slopese_val,
      min_val = slopemin_val,
      max_val = slopemax_val
    )
    
    p <- ggplot(df, aes(x = group, y = med)) +
      geom_errorbar(aes(ymin = min_val, ymax = max_val), width = 0.1, color = "grey") +
      geom_crossbar(aes(ymin = med - se, ymax = med + se), width = 0.2, fill = "skyblue") +
      geom_point(size = 3) +
      theme_bw() +
      labs(title = plot_title, y = ylab, x = "") +
      custom_theme_comp 
    
    return(p)
  })
  
  # Render comparison plot
  output$loc_plot_comp <- renderPlot({
    p <- loc_plot_obj_comp()
    req(p)
    p
  })
  
  # Comparison plot download handler
  output$download_plot_comp <- downloadHandler(
    filename = function() {
      variable_text <- assign_comparison(input$trend_metric)
      paste0("Plot_", tolower(gsub(" ", "_", variable_text)), "_18spp_", input$year_range, ".png")
    },
    content = function(file) {
      req(loc_plot_obj_comp()) 
      ggsave(file, plot = loc_plot_obj_comp(), width = 8, height = 6, dpi = 300)
    }
  )
  ### ---------------------------------------------------------------------- ###
  
  #### * Table for intro ####
  output$intro_table <- renderTable({
    intro_tab <- read.csv("intro_table.csv", check.names = FALSE)
    intro_tab
  })
  
  
} # END OF SERVER


# ---------- RUN APP -----------------------------------------------------------

shinyApp(ui = ui, server = server)
