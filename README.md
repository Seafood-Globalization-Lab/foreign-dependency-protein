# foreign-dependency-protein

This is a repository for my first chapter, where I am analyzing trends in foreign dependency for seafood consumption with respect to consumed animal proteins

------------------------------------------------------------------------

# Outputs

The final data in the output folder **`supply_importance_wide.csv`** and **`supply_importance_long.csv`**, has percentage contributions that aquatic animals have towards (1) protein consumption and (2) overall food consumption. We define aquatic animals as any animal that resides in an aquatic habitat that is not a marine mammal (e.g., cephalopods, crustaceans, fish). The data leverages both the Aquatic Resource Trade in Species database (Gephart et al. 2024) and Food and Agricultural Organization Food Balance Sheets (FBS; FAO 2023; FAO 2013). With the ARTIS database, we can derive the % consumption contributing different methods (i.e, capture, aquaculture) and habitats (i.e., inland, marine) by country. With the FBS, we can derive the % proportion that aquatic animals represent a country's consumed animal protein and overall food supply. Multiplying these proportions together can produce the % contribution that aquatic animals contribute by method and by habitat towards protein and food consumption (See `01_Analysis.Rmd` for calculations).

## Column names

| **Column Name**         | **R Data Type** | **Description / Values** |
|-------------------------|-----------------|---------------------------|
| `year`                  | int             | Year in which seafood was consumed. |
| `iso3c`                 | character       | Consuming country ISO3 code. |
| `data_source`           | character       | Data source that reliance data is derived from:<br>• `Old FBS` – Old FAO Food Balance Sheets<br>• `New FBS` – New FAO Food Balance Sheets |
| `food_group`            | character       | Origin that seafood/reliance is coming from:<br>• `Aquatic` – aquatic animal protein sources<br>• `Terrestrial` – terrestrial animal protein sources |
| `consumption_source`    | character       | Type of consumption source:<br>• `domestic` – domestic consumption<br>• `foreign` – foreign consumption |
| `habitat`               | character       | Habitat in which the species/species group was produced:<br>• `marine` – marine organism<br>• `inland` – freshwater organism<br>• `unknown` – unknown habitat |
| `protein_consumed_t`    | int             | The direct tonnage consumed from aquatic and terrestrial sources. For *aquatic* sources, this will be separated by `aquatic_source_prop` (i.e., adding `protein_consumed_t` across all sourcing material would create the total aquatic consumed protein in tons). For *terrestrial* sources, it is just the total gotten from FAO-FBS. |
| `method`                | character       | Method of production:<br>• `aquaculture` – produced via aquaculture<br>• `capture` – wild caught<br>• `unknown` – unknown production method |
| `prop_aquatic_source`   | int             | The proportion of seafood consumption, separated by `consumption_source`, `habitat`, and `method` for *aquatic* protein consumption. |
| `prop_animal_protein`   | int             | The reliance (measured in proportion) toward aquatic/terrestrial animal proteins. For *aquatic* proteins, this is the reliance separated by sourcing, and for *terrestrial* proteins, this is obtained from FAO-FBS. |

**Note:** *Terrestrial* protein values are included in this data. For every value of `food_group` that is `terrestrial`, the columns `consumption_source`, `habitat`, `method`, and `aquatic_source_prop` will be `NA` since these only apply to aquatic products.

# References

-   FAO. 2013. Food Balances (-2013, old methodology and population). In: FAOSTAT. <https://www.fao.org/faostat/en/#data/FBSH>

-   FAO. 2023. Food Balances (2010-). In: FAOSTAT. Rome. [Cited September 2023]. <https://www.fao.org/faostat/en/#data/FBS>

-   Gephart, J.A., Agrawal Bejarano, R., Gorospe, K. et al. Globalization of wild capture and farmed aquatic foods. Nat Commun 15, 8026 (2024). <https://doi.org/10.1038/s41467-024-51965-8>
