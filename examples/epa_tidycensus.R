# run tests ----
library(epaR)
library(tidyverse)

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# get table of all possible EPA files -----
epa_zip_links = get_all_epa_zip_links(archive=T)

completed_urls = tibble::tibble(url = list.files("data/", full.names = F)) %>%
  mutate(url = glue::glue("https://web.archive.org/web/20250126115248/https://aqs.epa.gov/aqsweb/airdata/{url}"))

# all links -----
remaining_urls <- epa_zip_links %>%
  filter(!url %in% completed_urls$url)

# filter to query -----
df_1991_2001 = df_all %>%
  filter(unit_of_analysis == "daily") %>%
  filter(year %in% c("1991","2001")) %>%
  filter(analyte %in% c("WIND"))


df_missing <- epa_zip_links %>%
  filter(analyte %in% c("81102"))

# download data -----
epa_df <- download_and_stack_csvs_cache(remaining_urls$url,
                                        download=T,
                                        stack=F,
                                        output_dir = "data/")

epa_df_pp <- epa_df %>%
  janitor::clean_names() %>%
  mutate(dt_month = lubridate::month(date_local),
         dt_wday = lubridate::wday(date_local),
         dt_year = lubridate::year(date_local))

agg_county_state = epa_df_pp %>%
  group_by(dt_year, dt_month, parameter_code, state_name) %>%
  summarize(mean_pollution = mean(arithmetic_mean, na.rm = TRUE),
            sd_pollution = sd(arithmetic_mean, na.rm = TRUE))

ggplot(agg_county_state, aes(dt_year, mean_pollution, group=dt_year))+
  geom_boxplot()

agg_wide = agg_county_state %>%
  pivot_wider(names_from = parameter_code, values_from = c(mean_pollution, sd_pollution))

fit <- lme4::lmer(mean_pollution_61104 ~ dt_year*dt_month + mean_pollution_61103 + (1 | state_name),
                  data = agg_wide)
sjPlot::tab_model(fit)

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# which columns can we transform to uppercase
table(epa_df$`Method Name` %>% str_to_upper())
table(epa_df$`City Name` %>% str_to_upper())
table(epa_df$`State Name` %>% str_to_upper())
table(epa_df$`County Name` %>% str_to_upper())

ggplot(epa_df, aes(x = arithmetic_mean, y = `Method Name`)) +
  geom_boxplot() +
  theme_minimal()

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

library(tidycensus)
library(sf)
library(dplyr)

# Get Census tract demographics (e.g., median income, race)
census_data <- get_acs(
  geography = "tract",
  variables = c(median_income = "B19013_001", pct_black = "B02001_003"),
  state = "PA",  # Adjust for your state
  year = 2020,
  geometry = TRUE
)

# Convert EPA data to spatial format
epa_sf <- st_as_sf(epa_df, coords = c("Longitude", "Latitude"), crs = 4326)

# Ensure Census data has the same CRS as epa_sf
census_data_t <- st_transform(census_data, st_crs(epa_sf))  # Transform to match EPA data

# Perform spatial join
epa_census <- st_join(epa_sf, census_data_t) %>%
  filter(variable == "median_income") %>%
  janitor::clean_names()

# does income predict pollution more in some parts of PA than others? ----
epa_census %>%
  mutate(year = as.factor(lubridate::year(date_local))) %>%
  group_by(geoid, year) %>%
  summarize(mean_pollution = mean(arithmetic_mean, na.rm = TRUE)) %>%
  ggplot(aes(x = year, y = mean_pollution, color = geoid, group = year)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Pollution Trends by Census Tract")

epa_census %>%
  filter(variable == "median_income") %>%
  group_by(cbsa_name, estimate > 40000) %>%  # High-Black vs. Low-Black areas
  summarize(mean_pollution = median(arithmetic_mean, na.rm = TRUE))

cor.test(epa_census$estimate, epa_census$`Arithmetic Mean`, method = "spearman")
fit <- lme4::lmer(arithmetic_mean ~ estimate + (1 | cbsa_name),
                  data = epa_census)

summary(fit)
sjPlot::tab_model(fit)

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
