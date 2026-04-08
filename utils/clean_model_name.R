clean_model_name <- function(x) {
  
  # Dictionaries
  suffix_map <- c(
    cap = "consumption per capita",
    rel = "reliance",
    roc = "rate of change",
    prop_of_aquatic_cons = "share of aquatic foods"
  )
  
  domain_map <- c(
    terr_animal = "Terrestrial animal",
    terrestrial = "Terrestrial",
    animal = "Animal",
    aquatic_animal = "Aquatic animal",
    aquatic = "Aquatic animal",
    capture = "Capture",
    aquaculture = "Aquaculture",
    domestic = "Domestic",
    foreign = "Foreign",
    marine = "Marine",
    inland = "Inland"
  )
  
  metric_map <- c(
    cons = "consumption",
    protein = "protein"
  )
  
  # Split all names at once
  parts <- strsplit(x, "_")
  
  # Vectorized parsing
  purrr::map_chr(parts, function(p) {
    
    # Detect suffix
    if (length(p) >= 4 && paste(p[(length(p)-3):length(p)], collapse = "_") == "prop_of_aquatic_cons") {
      suffix <- "prop_of_aquatic_cons"
      core <- p[1:(length(p)-4)]
    } else {
      suffix <- p[length(p)]
      core <- p[1:(length(p)-1)]
    }
    
    suffix_clean <- suffix_map[[suffix]]
    
    # Detect domain
    if (length(core) >= 2 && paste(core[1:2], collapse = "_") %in% names(domain_map)) {
      domain <- paste(core[1:2], collapse = "_")
      rest <- core[-(1:2)]
    } else {
      domain <- core[1]
      rest <- core[-1]
    }
    
    domain_clean <- domain_map[[domain]]
    
    # Detect metric — skip if suffix already encodes consumption
    suffixes_with_cons <- c("cap", "rel", "roc")  # these expand via cons_cap etc.
    
    # Detect metric
    if (length(rest) >= 1 && rest[1] %in% names(metric_map) && 
        !(rest[1] == "cons" && suffix %in% suffixes_with_cons)) {
      metric_clean <- metric_map[[rest[1]]]
    } else {
      metric_clean <- NULL
    }
    
    # Build label
    if (!is.null(metric_clean) && suffix != "prop_of_aquatic_cons") {
      paste(domain_clean, metric_clean, suffix_clean)
    } else {
      paste(domain_clean, suffix_clean)
    }
  })
}