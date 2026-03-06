# ----- ABOUT ------------------------------------------------------------------

# Should generate the pest reports so we don't have to write the same
# infomation for each one (since they will be sharing a lot of text)





# ------------------------------------------------------------------------------

# Load packages (we need stringr, fs, and glue)
source("packages.R")

# Read in species-specific text
pests <- read.csv("pest_report_text.csv")

# Make sure there's a folder for the reports
dir_create("reports")

# Function for creating text
template_text <- function(pest_name, scientific_name, intro1, intro2, slug) {
  
  glue::glue(
    
    '---
title: "{pest_name}"
description: "*{scientific_name}*"
image: "images/placeholder.png"
format:
  html:
    toc: true
  pdf:
    toc: true
    number-sections: false
---

::: {{.content-visible when-format="html"}}
<div style="text-align: left;">
[Download report as PDF](index.pdf){{.btn .btn-primary}}
</div>
:::

## Overview

{intro1}
    
{intro2}

## Identification

## Damage and Economic Impact

## Management Strategies

## DDRP and MK trends report

## References

'
  )
}

# Repeat for each species
for (i in 1:nrow(pests)) {
  
  pest <- pests$pest_name[i]
  sci  <- pests$scientific_name[i]
  intro1 <- pests$intro1[i]
  intro2 <- pests$intro2[i]
  
  slug <- pest |>
    str_to_lower() |>
    str_replace_all("[^a-z0-9]+", "-") |>
    str_replace_all("^-|-$", "")
  
  writeLines(
    template_text(pest, sci, intro1, intro2, slug),
    file.path("reports", paste0(slug, ".qmd"))
    
  )
}

