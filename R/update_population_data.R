# Recalculate per capita since we combined territories into countries
update_population_data <- function(input_data, animal_products = FALSE, historical = FALSE) {
  
  # Define which elements we'll be creating/updating
  per_capita_elements <- c("Protein supply quantity (g/capita/day)", 
                           "Food supply (kcal/capita/day)",
                           "Food supply quantity (kg/capita/yr)")
  
  # Filter for total yearly values that need recalculation
  if (historical == FALSE) {
    elements_to_update <- c("Food supply (kcal)", "Protein supply quantity (t)")
  } else {
    elements_to_update <- c("Protein supply quantity (t)")
  }
  
  # Split data: elements to update vs elements to keep as-is
  data_to_update <- input_data %>%
    filter(Element %in% elements_to_update)
  
  # Keep elements that are NOT being updated AND NOT the per capita elements we're creating
  data_no_update <- input_data %>%
    filter(!Element %in% elements_to_update,
           !Element %in% per_capita_elements)
  
  # Join population data to the elements that need updating
  data_with_pop <- data_to_update %>%
    left_join(population, by = c("iso3c", "year", "data_source"))
  
  # Filter for animal products if specified
  if (animal_products == TRUE) {
    data_with_pop <- data_with_pop
  }
  
  # Calculate per capita values based on historical vs current data
  if (historical == TRUE) {
    # For historical data, only recalculate protein
    updated_data <- data_with_pop %>%
      mutate(
        value_updated = case_when(
          Element == "Protein supply quantity (t)" ~ (value * 1e6) / (population * 365),
          TRUE ~ value
        ),
        Element = case_when(
          Element == "Protein supply quantity (t)" ~ "Protein supply quantity (g/capita/day)",
          TRUE ~ Element
        ),
        Unit = case_when(
          Element == "Protein supply quantity (g/capita/day)" ~ "g/capita/day",
          TRUE ~ Unit
        )
      ) %>%
      select(-population, -value) %>%
      rename(value = value_updated)
    
  } else {
    # For current data, calculate multiple per capita measures
    # We need to create separate rows for each per capita calculation
    
    # Calculate kcal per capita per day
    kcal_per_capita <- data_with_pop %>%
      filter(Element == "Food supply (kcal)") %>%
      mutate(
        value = (value * 1e6) / (population * 365),
        Element = "Food supply (kcal/capita/day)",
        Unit = "kcal/capita/day"
      ) %>%
      select(-population)
    
    # Calculate kg per capita per year (need energy density - this seems to be missing from original)
    # Note: You'll need to define energy_density_kcal_per_kg or handle this differently
    kg_per_capita <- data_with_pop %>%
      filter(Element == "Food supply (kcal)") %>%
      mutate(
        # Using a placeholder energy density - you'll need to provide this value
        energy_density_kcal_per_kg = 2000, # Replace with actual energy density data
        value = (value * 1e6) / (population * energy_density_kcal_per_kg),
        Element = "Food supply quantity (kg/capita/yr)",
        Unit = "kg/capita/yr"
      ) %>%
      select(-population, -energy_density_kcal_per_kg)
    
    # Calculate protein per capita per day
    protein_per_capita <- data_with_pop %>%
      filter(Element == "Protein supply quantity (t)") %>%
      mutate(
        value = (value * 1e6) / (population * 365),
        Element = "Protein supply quantity (g/capita/day)",
        Unit = "g/capita/day"
      ) %>%
      select(-population)
    
    # Combine all the per capita calculations
    updated_data <- bind_rows(kcal_per_capita, kg_per_capita, protein_per_capita)
  }
  
  # Combine the updated per capita data with the data that didn't need updating
  final_data <- bind_rows(data_no_update, updated_data)
  
  return(final_data)
}