# ----- ABOUT ------------------------------------------------------------------

# Contains custom functions to be loaded into the app.R file

# New - Sep 2026 - CARTO key required for base tiles 
carto_key <- Sys.getenv("CARTO_KEY")

if (carto_key == "") {
  stop("CARTO_KEY is not set.")
}

# ----- Pest profile and image-card helpers ------------------------------------
# Store species information once so the UI and server use the same data.
make_pest_profile <- function(
    common_name,
    scientific_name,
    abbreviation,
    description,
    image_file,
    photo_credit
) {
  list(
    common_name = common_name,
    scientific_name = scientific_name,
    abbreviation = abbreviation,
    description = description,
    image_file = image_file,
    photo_credit = photo_credit
  )
}

# Preserve existing HTML italics while italicizing names supplied as plain text.
format_scientific_name <- function(name) {
  if (inherits(name, "html")) name else tags$em(name)
}

# Create a clickable image card for the Pest Reports page.
make_pest_card <- function(profile) {
  actionButton(
    inputId = paste0("pest_card_", profile$abbreviation),
    label = tagList(
      tags$img(
        src = profile$image_file,
        alt = profile$common_name,
        class = "pest-card-image"
      ),
      tags$span(profile$common_name, class = "pest-card-name"),
      tags$span(format_scientific_name(profile$scientific_name), class = "pest-card-scientific"),
      tags$span(profile$photo_credit, class = "pest-card-credit")
    ),
    class = "pest-card",
    width = "100%"
  )
}

pest_profiles <- list(
      
      ##### * Asian longhorned beetle #####
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
        photo_credit = "Photo: Allen Smith, dallastrees.org"
      ),
      
      ##### * False codling moth #####
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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
      make_pest_profile(
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

# ----- Function to import outputs (rasters) -----------------------------------

# 1 = Tau statistic, 2 = Sen's slope, 3 = p-value
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
  
  # Min and max value
  mm <- as.vector(terra::minmax(rast))
  
  # Spp. comparison maps
  if (metric == "comparison") {
    
    limits <- c(0, 18)
    pal <- gen_pal(comp_pal, limits)
    
  } else if (metric == "sens") {
    
    max_abs <- max(abs(mm), na.rm = TRUE)
    
    if (is.infinite(max_abs) || max_abs == 0)
      
    max_abs <- 0.1
    limits <- c(-max_abs, max_abs)
    pal <- gen_pal(sp_pal, limits)
    
  } else if (metric %in% c("tau", "clm")) {
    
    max_abs <- max(abs(mm), na.rm = TRUE)
    limits <- c(-max_abs, max_abs)
    pal <- gen_pal(sp_pal, limits)
    
  }
  
  list(pal = pal, limits = limits)
}

# ----- Consolidated legend builder --------------------------------------------


create_legend_html <- function(metric, title, pal, limits) {
  
  is_comparison <- metric == "comparison"
  
  if (is_comparison) {
    
    grad_colors <- paste(
      pal(seq(0, 18, length.out = 50)),
      collapse = ","
    )
    
    ticks <- seq(0, 18, by = 2)
    
    tick_labels <- paste0(
      "<span style='flex:1;text-align:center;font-size:13px;'>",
      ticks,
      "</span>",
      collapse = ""
    )
    
    return(paste0(
      "<div style='background:white;padding:13px 14px;border-radius:7px;",
      "box-shadow:0 0 6px rgba(0,0,0,0.25);box-sizing:border-box;",
      "width:312px;max-width:100%;font-size:14px;'>",
      
      "<div style='text-align:center;font-weight:bold;font-size:18px;",
      "line-height:1.3;margin-bottom:10px;'>",
      title,
      "</div>",
      
      "<div style='width:100%;height:21px;border:1px solid #ccc;",
      "box-sizing:border-box;background:linear-gradient(to right,",
      grad_colors,
      ");'></div>",
      
      "<div style='display:flex;justify-content:space-between;",
      "margin-top:6px;'>",
      tick_labels,
      "</div>",
      
      "</div>"
    ))
  }
  
  grad_colors <- paste(
    pal(seq(limits[1], limits[2], length.out = 50)),
    collapse = ","
  )
  
  paste0(
    "<div style='background:white;padding:13px 14px;border-radius:7px;",
    "box-shadow:0 0 6px rgba(0,0,0,0.25);width:312px;max-width:100%;",
    "box-sizing:border-box;font-size:14px;'>",
    
    # Title with arrows on either side
    "<div style='display:flex;align-items:center;justify-content:space-between;",
    "gap:10px;margin-bottom:10px;'>",
    
    "<span style='font-size:28px;line-height:1;flex-shrink:0;",
    "font-weight:bold;'>&#8592;</span>",
    
    "<div style='font-weight:bold;text-align:center;font-size:18px;",
    "line-height:1.3;flex:1;min-width:0;overflow-wrap:anywhere;'>",
    title,
    "</div>",
    
    "<span style='font-size:28px;line-height:1;flex-shrink:0;",
    "font-weight:bold;'>&#8594;</span>",
    
    "</div>",
    
    # Horizontal gradient
    "<div style='width:100%;height:21px;border:1px solid #ccc;",
    "box-sizing:border-box;background:linear-gradient(to right,",
    grad_colors,
    ");'></div>",
    
    # Numeric labels
    "<div style='display:flex;justify-content:space-between;",
    "font-size:14px;margin-top:6px;'>",
    
    "<span>",
    if (limits[1] < 0) "&minus;" else "",
    abs(round(limits[1], 2)),
    "</span>",
    
    "<span>0</span>",
    
    "<span>",
    if (limits[2] < 0) "&minus;" else "",
    abs(round(limits[2], 2)),
    "</span>",
    
    "</div>",
    "</div>"
  )
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
  
  m <- leaflet(
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
    
    # Create panes for different z levels
    addMapPane("Basemap", zIndex = 400) %>%
    addMapPane("Value",   zIndex = 410) %>%
    addMapPane("Labels",  zIndex = 420) %>%
    addMapPane("Borders", zIndex = 430) %>%
    
    # Map tiles
    # Gives "API Required" message on map
    # addProviderTiles(providers$CartoDB.PositronNoLabels,
    #                  group = "Basemap") %>% 
    # CARTO Positron basemap
    addTiles(
      urlTemplate = paste0(
        "https://{s}.basemaps.cartocdn.com/rastertiles/light_all/",
        "{z}/{x}/{y}.png?key=",
        carto_key
      ),
      options = tileOptions(
        pane = "Basemap"
      ),
      group = "Basemap"
    ) %>%

    # CARTO labels
    addTiles(
      urlTemplate = paste0(
        "https://basemaps.cartocdn.com/rastertiles/voyager_only_labels/",
        "{z}/{x}/{y}.png?key=",
        carto_key
      ),
      options = tileOptions(
        subdomains = "abcd",
        pane = "Labels",
        attribution = paste0(
          '&copy; <a href="https://openstreetmap.org">',
          "OpenStreetMap</a> contributors ",
          '&copy; <a href="https://carto.com">',
          "CARTO</a>"
        )
      ),
      group = "Labels"
    ) %>%
    
    # Fit the initial view to the provided bounds (CONUS)
    fitBounds(
      lng1 = bounds$west, 
      lat1 = bounds$south, 
      lng2 = bounds$east, 
      lat2 = bounds$north) %>%
    
    # Always-on State Boundaries
    addPolylines(
      data = us_states,
      opacity = 0.6,
      color = "#444444",
      weight = 1.2,
      group = "States",
      options = pathOptions(
        pane = "Borders"
      )
    ) %>%
    
    # County Boundaries (hidden unless zoom > 6.5)
    addPolylines(
      data = us_counties,
      opacity = 0.4,
      color = "#777777",
      weight = 0.5,
      group = "Counties",
      options = pathOptions(
        pane = "Borders"
      )
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

# Plot stuff

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

# ----- Functions for naming exported files ------------------------------------

# Metric name for exported map and plot image files
assign_metric_name <- function(var_type,
                               phenology = NULL,
                               clim_variable = NULL) {
  
  if (var_type == "phenology") {
    
    if (grepl("Adult", phenology, ignore.case = TRUE)) {
      return("adult")
    } else {
      return("egg")
    }
    
  } else if (var_type == "climate") {
    
    if (grepl("Cold", clim_variable, ignore.case = TRUE)) {
      return("cold_stress")
    } else {
      return("heat_stress")
    }
    
  } else if (var_type == "clm") {
    
    return("stress_exclusion")
    
  } else {
    
    return(NULL)
    
  }
}
