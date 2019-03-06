# Load libraries and read in data

library('tidyverse')

newport.beach <- read_csv('input/newport_beach.csv')

# v17 <- load_variables(2017, "acs5", cache = TRUE) # view variable names

# Create race/ethnicity categories

newport.beach <- newport.beach %>% select(-summary_moe) %>%
  mutate(cat = case_when(
    variable == 'B03002_003' ~ "white",
    variable == 'B03002_004' ~ "black",
    variable == 'B03002_005' | variable == 'B03002_007' | variable == 'B03002_008' | variable == 'B03002_009' ~ "other",
    variable == 'B03002_006' ~ "asian",
    variable == 'B03002_012' ~ "hisp")) 

# Filter out unwanted categories and summarize the data by the newly-created categories

newport.beach <- newport.beach %>% 
  filter(!is.na(cat)) %>% 
  group_by(GEOID, NAME, cat, summary_est) %>% 
  summarise(estimate = sum(estimate))

# Calculate each category's percentage of total population and sort categories by percentage, from highest to lowest
newport.beach <- newport.beach %>% 
  mutate(perc = estimate/summary_est * 100) %>% 
  arrange(desc(perc))

newport.beach

# Write to a CSV
write_csv(newport.beach, 'output/newport_beach_cleaned.csv')