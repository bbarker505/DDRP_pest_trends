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
        
        # Select statistic
        selectInput(
          "trend_metric",
          label = tags$span(h4(HTML("<b>Select metric</b>"))),,
          choices = c(
            "Change in days per year (Sen’s slope)" = "sens",
            "Direction of trend (Kendall’s τ)" = "tau"
          ),
          selected = "sens"
        ),
        
        hr(),
        
        # (Dynamic) To select type of map (show climate or phenology options)
        conditionalPanel(
          
          condition = "input.pest && input.pest !== ''",
          
          selectInput(
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
          
          selectInput(
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
          
          selectInput(
            "phenology",
            label = tags$span(h4(HTML("<b>Select phenology metric</b>"))),
            choices = c(
              "1st adult emergence" = "First_adult_emergence",
              "1st egg hatch" = "First_egg_hatch"
              ), 
            selected = "First_adult_emergence"
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
            
            tags$p(strong("Years:"), " 1981–2024"),
            
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
  
  # Check which variable is selected
  selected_variable <- reactive({
    
    # Input a pest
    req(input$pest)
    
    if (input$var_type == "climate") return(input$clim_variable)
    if (input$var_type == "phenology") return(input$phenology)
    NULL
  })
  
  #### * For display purposes ####
  display_name <- reactive({
    
    # Get selected variable
    var <- selected_variable()
    
    # Display-friendly name (without the underscores)
    variable_labels[var] %||% var
    
  })
  
  #### * Update input selection pane depending on pest selected ####
  observeEvent(input$pest, {
    
    req(input$pest)
    
    # Filter lookup table for selected pest & fixed year
    available_vars <- raster_lookup %>%
      filter(pest == input$pest, year_range == "81-24") %>%
      pull(variable) %>%
      unique()
    
    # Keep only phenology variables
    phenology_vars <- intersect(available_vars, names(variable_labels)[3:4])
    
    # Update phenology radio buttons
    if (length(phenology_vars) > 0) {
      choices <- phenology_vars
      names(choices) <- variable_labels[phenology_vars]
      
      updateRadioButtons(
        session,
        "phenology",
        choices = choices,
        selected = phenology_vars[2]
      )
    }
    
  })
  
  
  #### * Collect p-value raster ####
  pest_raster_pval <- reactive({
    
    req(input$pest, selected_variable())
    
    row <- raster_lookup %>%
      filter(pest == input$pest,
             variable == selected_variable(),
             year_range == "81-24")
    
    validate(need(nrow(row) == 1, "No raster found"))
    
    rast_import_pval(row$file_path)
    
  })
  
  #### * Get file of interest ####
  selected_file <- reactive({
    
    req(input$pest, selected_variable())
    
    row <- raster_lookup %>%
      filter(
        pest == input$pest,
        variable == selected_variable(),
        year_range == "81-24"
      )
    
    validate(need(nrow(row) == 1, "No raster found"))
    
    row$file_path
    
  })
  
  
  #### * Reactive for metric ####
  selected_trend <- reactive({
    
    req(input$trend_metric, selected_file())
    
    layer <- switch(
      input$trend_metric,
      "sens" = 2,
      "tau" = 1
    )
    
    list(
      rast  = rast_import(selected_file(), layer),
      title = switch(
        input$trend_metric,
        "sens" = "Change in days per year",
        "tau"  = "Direction of trend"
      )
    )
  })
  
  
  #### * Initial map plotted ####
  output$map <- renderLeaflet({
    
    trend <- selected_trend()
    
    # Plot map
    produce_map(rast = trend$rast,
                bounds = bounds,
                metric = input$trend_metric,
                legend_title = trend$title)
  })
  
  
  
  #### * Update map when pest changes ####
  observeEvent(list(input$pest, input$var_type, input$clim_variable, 
                    input$phenology, input$trend_metric), {
                      
                      trend <- selected_trend()
                      
                      # Build palette + limits
                      pal_obj <- make_palette(trend$rast, input$trend_metric)
                      pal     <- pal_obj$pal
                      limits  <- pal_obj$limits
                      
                      # Build horizontal legend
                      legend_html <- paste0(
                        "<div style='background:white;padding:8px 10px;border-radius:6px;'>",
                        
                        "<div style='text-align:center;font-weight:bold;margin-bottom:4px;'>",
                        trend$title,
                        "</div>",
                        
                        "<div style='display:flex;flex-direction:column;align-items:center;'>",
                        
                        "<div style='width:160px;height:14px;border:1px solid #ccc;",
                        "background:linear-gradient(to right,",
                        paste(pal(seq(limits[1], limits[2], length.out = 50)), 
                              collapse = ","),
                        ");'></div>",
                        
                        "<div style='display:flex;justify-content:space-between;",
                        "width:160px;font-size:11px;margin-top:2px;'>",
                        "<span>", round(limits[1],2), "</span>",
                        "<span>0</span>",
                        "<span>", round(limits[2],2), "</span>",
                        "</div>",
                        
                        "</div></div>"
                      )
                      
                      # Plot updated map
                      leafletProxy("map") %>%
                        clearImages() %>%
                        clearControls() %>%
                        clearGroup("click_marker") %>%
                        addRasterImage(
                          trend$rast,
                          colors  = pal,
                          opacity = 0.65,
                          layerId = "Value"
                        ) %>%
                        addControl(
                          html = HTML(legend_html),
                          position = "bottomright"
                        )
                    }, 
               ignoreInit = TRUE)
  
  
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
        fitBounds(bounds$west, bounds$south, bounds$east, bounds$north) %>%
        clearGroup("click_marker")
      
      
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
      ) %>%
      clearGroup("click_marker")
    
  })
  
  #### * Panel that holds location click outputs ####
  observeEvent(input$map_click, {
    
    trend <- selected_trend()
    
    req(input$map_click, trend$rast, pest_raster_pval())
    
    # Store click info
    click <- input$map_click
    
    # Add marker where user clicked
    leafletProxy("map") %>%
      clearGroup("click_marker") %>%   # removes old marker
      addMarkers(
        lng = click$lng,
        lat = click$lat,
        group = "click_marker"
      )
    
    
    # Store coordinates
    xy <- data.frame(x = click$lng, y = click$lat)
    
    # Extract selected metric value
    value <- terra::extract(trend$rast, xy)[1,2]
    
    # Extract p-value
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
    
    # Selected metric value
    output$clicked_value <- renderUI({
      
      info_text <- if (input$trend_metric == "tau") {
        "Kendall’s τ indicates the direction and consistency of a trend over
        time. Positive values suggest the variable is generally increasing / 
        occurring progressively later over time, while negative values suggest 
        decreasing / earlier timing."
      } else {
        "Sen’s slope estimates the annual rate of change in timing. Positive 
        values suggest increasing x units per year; negative values suggest a
        decrease of x units per year."
      }
      
      tags$div(
        tags$b(paste0(trend$title, ": ")),
        round(value, 3), " ",
        tags$span(
          tags$i(class = "bi bi-info-circle"),
          style = "cursor:pointer;",
          `data-bs-toggle` = "popover",
          `data-bs-trigger` = "click",
          `data-bs-placement` = "right",
          `data-bs-html` = "true",
          title = "About the statistic",
          `data-bs-content` = info_text
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
            "The p-value describes the strength of evidence for a trend.
          Values less than 0.05 are typically considered statistically 
            significant."
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
