# foreign-dependency-protein

This is a repository for my first chapter, where I am analyzing trends in foreign dependency for seafood consumption with respect to consumed animal proteins

------------------------------------------------------------------------

# Outputs

The final data in the output folder **`supply_importance_wide.csv`** and **`supply_importance_long.csv`**, has percentage contributions that aquatic animals have towards (1) protein consumption and (2) overall food consumption. We define aquatic animals as any animal that resides in an aquatic habitat that is not a marine mammal (e.g., cephalopods, crustaceans, fish). The data leverages both the Aquatic Resource Trade in Species database (Gephart et al. 2024) and Food and Agricultural Organization Food Balance Sheets (FBS; FAO 2023; FAO 2013). With the ARTIS database, we can derive the % consumption contributing different methods (i.e, capture, aquaculture) and habitats (i.e., inland, marine) by country. With the FBS, we can derive the % proportion that aquatic animals represent a country's consumed animal protein and overall food supply. Multiplying these proportions together can produce the % contribution that aquatic animals contribute by method and by habitat towards protein and food consumption (See `01_Analysis.Rmd` for calculations).

## Column names

| Variable name | Explanation |
|------------------------------------|------------------------------------|
| year | calendar year |
| conusmer_iso3c | consuming country (in ISO3 code) |
| region | region the consuming country was in (e.g., North America, Asia, Oceania) |
| habitat | The habitat the consumed seafood was caught from (marine, inland) |
| method | The method the consumed seafood was produced from (capture, aquaculture) |
| consumption_source | The source of production (domestic, foreign) |
| prop_consumption | The proportion of seafood consumption by habitat, method, and consumption source. Adding across these three categories within a country and year will sum to 1 |
| aa_food_supply_kcal_capita_day | Total aquatic animal food supply in calories, per capita, per day |
| aa_protein_supply_g_capita_day | Total aquatic animal protein supply in grams per capita per day |
| animal_food_supply_kcal_capita_day | Total animal food supply in calories, per capita, per day |
| animal_protein_supply_g_capita_day | Total animal protein supply in grams per capita per day |
| prop_aa_food_supply | Proportion that aquatic animals contribute to food supply |
| prop_aa_protein_supply | Proportion that aquatic animals contribute to protein supply |
| prop_aa_contribution_to_animal_daily_calories | proportion contribution that aquatic animals contribute to consumed animal foods |
| prop_aa_contribution_to_animal_protein | proportion contribution that aquatic animals contribute to consumed animal proteins |
| prop_consumption_x_fao_food_supply_kcal_capita_day | \% consumption (by method/habitat/consumption source category) that is devoted to the total aquatic animal (aa) food supplies (different from contribution as this is the direct aa amount and not the prop of aa to total animal foods |
| prop_consumption_x_fao_protein_supply_g_capita_day | \% consumption (by method/habitat/consumption source category) that is devoted to the total aquatic animal (aa) protein supply |

: Columns 1-7 were ARTIS derived, 8-13 were FAO FBS derived, and 14-17 were ARTIS-FAO joined derived. Any derived variable (e.g., columns 6-17) are measured for a given country for a given year (also grouped by method, habitat, and consumption_source).

The **`supply_importance_long.csv`** version consolidates columns 8-17 consolidates the different elements (i.e, food supply, protein supply) into the `Element` variable grouping.

# References

-   FAO. 2013. Food Balances (-2013, old methodology and population). In: FAOSTAT. <https://www.fao.org/faostat/en/#data/FBSH>

-   FAO. 2023. Food Balances (2010-). In: FAOSTAT. Rome. [Cited September 2023]. <https://www.fao.org/faostat/en/#data/FBS>

-   Gephart, J.A., Agrawal Bejarano, R., Gorospe, K. et al. Globalization of wild capture and farmed aquatic foods. Nat Commun 15, 8026 (2024). <https://doi.org/10.1038/s41467-024-51965-8>
