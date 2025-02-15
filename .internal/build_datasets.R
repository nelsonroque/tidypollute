# Load necessary packages
library(usethis)
library(devtools)
library(digest)
library(lubridate)
library(tidyverse)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Define the URL for the EPA AirData download page
url <- "https://aqs.epa.gov/aqsweb/airdata/download_files.html"

# Read the webpage and parse HTML content
webpage <- rvest::read_html(url)

# TODO: cache webpage!

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Create the tibble
us_states <- tibble(
  state_name = state.name,
  state_abbreviation = state.abb,
  state_area = state.area,
  state_center_x = state.center$x,
  state_center_y = state.center$y,
  state_division = state.division,
  state_region = state.region
)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Prepare EPA SuperFund Site dataset
# epa_superfund_npl_sites <- read_csv("~/Downloads/Superfund_National_Priorities_List_(NPL)_Sites_with_Status_Information.csv") %>%
#   select(-X,-Y,-OBJECTID, -CreationDate, -Creator,-EditDate,-ObjectId2, -Editor) %>%
#   janitor::clean_names()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Generate the dataset
epa_airdata_links <- tidypollute::scrape_epa_airdata_zip_links()

# Generate the dataset
epa_airdata_links_archive <- tidypollute::scrape_epa_airdata_zip_links(archive=T)

# get stations data ----
epa_airdata_monitoring_sites = epa_airdata_links %>%
  filter(analyte == "sites") %>%
  tidypollute::download_stack_epa_airdata(clean_names = F)

epa_analyte_codes = readr::read_csv(".internal/epa_airdata_lookup_table.csv")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Save as an .rda file inside the 'data/' folder
usethis::use_data(us_states, overwrite=TRUE)
usethis::use_data(epa_airdata_links, overwrite = TRUE)
usethis::use_data(epa_airdata_links_archive, overwrite = TRUE)
usethis::use_data(epa_airdata_monitoring_sites, overwrite = TRUE)
usethis::use_data(epa_analyte_codes, overwrite=TRUE)
#usethis::use_data(epa_superfund_npl_sites, overwrite = TRUE)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# compute MD5 hashes for all data -----

# Define the current date
current_date <- Sys.Date()

# Compute MD5 hashes
hashes <- data.frame(
  Date = current_date,
  Variable = c("us_states",
               "epa_airdata_links",
               "epa_airdata_links_archive",
               "epa_airdata_monitoring_sites"),
  Hash = c(
    digest(us_states),
    digest(epa_airdata_links),
    digest(epa_airdata_links_archive),
    digest(epa_airdata_monitoring_sites)
  ),
  stringsAsFactors = FALSE
) %>%
  mutate(Dataset = glue::glue("{Variable}.rda"))

# Define the output file path
hash_file <- ".internal/data_hashes.csv"

# Check if file exists and write accordingly
if (file.exists(hash_file)) {
  write.table(hashes, file = hash_file, sep = ",",
              row.names = FALSE, col.names = FALSE, append = TRUE)
} else {
  write.table(hashes, file = hash_file, sep = ",",
              row.names = FALSE, col.names = TRUE)
}

# Confirm the write operation
print("Hashes written to data_hashes.csv successfully!")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
