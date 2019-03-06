### Load libraries and read in data

The data are from the Census Bureau's 2013-2017 American Community Survey (Five-Year Estimates), table B03002, [HISPANIC OR LATINO ORIGIN BY RACE](https://factfinder.census.gov/bkmk/table/1.0/en/ACS/17_5YR/B03002/1600000US0651182). The numbers represent estimates over the five year period.

``` r
library('tidyverse')
library('knitr')
newport.beach <- read_csv('input/newport_beach.csv')
```

### Create race/ethnicity categories

Rename the race/ethnicity variables we want to keep into more intuitive names; e.g., "white" for non-Hispanic white, "black" for non-Hispanic black, etc. The "other" category includes non-Hispanic American Indian and Alaskan Native, Native Hawaiian and Other Pacific Islander, Some other race alone, and Two or more races.

``` r
# v17 <- load_variables(2017, "acs5", cache = TRUE) # view variable names

newport.beach <- newport.beach %>% select(-summary_moe) %>%
  mutate(cat = case_when(
    variable == 'B03002_003' ~ "white",
    variable == 'B03002_004' ~ "black",
    variable == 'B03002_005' | variable == 'B03002_007' | variable == 'B03002_008' | variable == 'B03002_009' ~ "other",
    variable == 'B03002_006' ~ "asian",
    variable == 'B03002_012' ~ "hisp")) 
```

### Filter out unwanted categories and summarize the data by the newly-created categories

``` r
newport.beach <- newport.beach %>% 
  filter(!is.na(cat)) %>% 
  group_by(GEOID, NAME, cat, summary_est) %>% 
  summarise(estimate = sum(estimate))
```

### Calculate each category's percentage of total population and sort categories by percentage, from highest to lowest

We use the `kable()` function from the `knitr` package to render a formatted table.

``` r
newport.beach <- newport.beach %>% 
  mutate(perc = estimate/summary_est * 100) %>% 
  arrange(desc(perc))

kable(newport.beach) # formatted table
```

| GEOID   | NAME                           | cat   |  summary\_est|  estimate|        perc|
|:--------|:-------------------------------|:------|-------------:|---------:|-----------:|
| 0651182 | Newport Beach city, California | white |         86793|     70471|  81.1943359|
| 0651182 | Newport Beach city, California | hisp  |         86793|      6915|   7.9672324|
| 0651182 | Newport Beach city, California | asian |         86793|      6604|   7.6089086|
| 0651182 | Newport Beach city, California | other |         86793|      2267|   2.6119618|
| 0651182 | Newport Beach city, California | black |         86793|       536|   0.6175613|

### Write to a CSV

``` r
write_csv(newport.beach, 'output/newport_beach_cleaned.csv')
```
