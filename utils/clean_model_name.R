clean_model_name <- function(x) {
  
  suffix_map <- c(
    cap = "consumption per capita",
    dom = "protein dominance"
  )
  
  domain_map <- c(
    terr_animal    = "Terrestrial animal",
    terrestrial    = "Terrestrial",
    animal         = "Animal",
    aquatic_animal = "Aquatic animal",
    aquatic        = "Aquatic animal",
    capture        = "Capture",
    aquaculture    = "Aquaculture",
    domestic       = "Domestic",
    foreign        = "Foreign",
    marine         = "Marine",
    inland         = "Inland"
  )
  
  lookup <- function(map, key, full_name) {
    if (is.na(key) || !key %in% names(map)) {
      warning("No mapping for '", key, "' in model name '", full_name, "'",
              call. = FALSE)
      return(key)
    }
    map[[key]]
  }
  
  purrr::map2_chr(strsplit(x, "_"), x, function(p, full_name) {
    
    is_roc <- p[length(p)] == "roc"
    if (is_roc) p <- p[-length(p)]
    
    suffix <- p[length(p)]
    core   <- p[-length(p)]
    
    if (length(core) >= 2 && paste(core[1:2], collapse = "_") %in% names(domain_map)) {
      domain <- paste(core[1:2], collapse = "_")
    } else {
      domain <- core[1]
    }
    
    paste(
      c(lookup(domain_map, domain, full_name),
        lookup(suffix_map, suffix, full_name),
        if (is_roc) "rate of change"),
      collapse = " "
    )
  })
}