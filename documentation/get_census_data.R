library('tidycensus')
library('tidyverse')

## More on tidycensus here: https://walkerke.github.io/tidycensus/articles/basic-usage.html

# census_api_key("YOUR API KEY GOES HERE")

ca <- get_acs("place", 
              table = "B03002", 
              summary_var = "B03002_001",
              state = "CA", 
              year = 2017
              )

newport.beach <- ca %>% 
  filter(NAME == 'Newport Beach city, California')

write_csv(newport.beach, '../input/newport_beach.csv')