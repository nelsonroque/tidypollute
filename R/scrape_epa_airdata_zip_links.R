#' Scrape EPA AirData ZIP File Links and Metadata
#'
#' This function scrapes the EPA AirData website for downloadable ZIP file links,
#' extracts relevant metadata from filenames (such as year, unit of analysis, and analyte),
#' and returns a tidy tibble with structured information.
#'
#' @param archive Logical. If `TRUE`, the function retrieves data from the Wayback Machine
#'   (Internet Archive) rather than the live EPA AirData website. Defaults to `FALSE`.
#' @param archive_id Character. The timestamp ID for the archived version of the EPA AirData website
#'   on the Wayback Machine (only used if `archive = TRUE`). Defaults to `"20250126115248"`.
#'
#' @return A tibble with the following columns:
#'   - `year`: Year extracted from the filename (if present).
#'   - `unit_of_analysis`: Type of data aggregation (e.g., "daily", "hourly", "annual").
#'   - `analyte`: The pollutant or air quality measure extracted from the filename.
#'   - `url`: The full URL to download the ZIP file.
#'   - `analyte_description`: A human-readable description of the analyte.
#'
#' @details
#' The function scrapes the live EPA AirData website (`https://aqs.epa.gov/aqsweb/airdata/download_files.html`)
#' unless `archive = TRUE`, in which case it retrieves an archived version from the Wayback Machine.
#'
#' Filenames are parsed to extract metadata based on naming conventions used by EPA.
#'
#' @examples
#' \dontrun{
#' # Scrape live EPA AirData ZIP links
#' epa_links <- scrape_epa_airdata_zip_links()
#'
#' # Scrape from an archived version (useful if the live site is down)
#' archived_links <- scrape_epa_airdata_zip_links(archive = TRUE, archive_id = "20240101000000")
#' }
#'
#' @import httr rvest dplyr stringr tibble glue
#' @export
scrape_epa_airdata_zip_links <- function(archive = FALSE, archive_id = "20250126115248") {

  # Define base URL and page URL
  if (archive) {
    url <- glue("https://web.archive.org/web/{archive_id}/https://aqs.epa.gov/aqsweb/airdata/download_files.html")
    base_url <- glue("https://web.archive.org/web/{archive_id}/https://aqs.epa.gov/aqsweb/airdata/")
  } else {
    url <- "https://aqs.epa.gov/aqsweb/airdata/download_files.html"
    base_url <- "https://aqs.epa.gov/aqsweb/airdata/"
  }

  # Fetch page content
  response <- httr::GET(url, encode = "utf-8")
  page_content <- content(response, as = "text")
  html <- read_html(page_content)

  # Extract all ZIP file links
  zip_links <- html %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    grep("\\.zip$", ., value = TRUE)

  # Convert relative URLs to absolute URLs
  zip_links <- paste0(base_url, zip_links)

  # Parse ZIP file metadata
  zip_links_tbl <- tibble(url = zip_links) %>%
    mutate(
      filename = basename(url),
      year = str_extract(filename, "_(\\d{4})\\.zip$") %>% str_remove_all("_|\\.zip"),
      category = str_remove(filename, "_\\d{4}\\.zip$") %>% str_remove("\\.zip$"),
      category = str_remove(category, "_\\d{4}$"),  # Remove trailing 4-digit year if present
      unit_of_analysis = case_when(
        str_detect(category, "daily") ~ "daily",
        str_detect(category, "blanks") ~ "blanks",
        str_detect(category, "8hour") ~ "8hour",
        str_detect(category, "hourly") ~ "hourly",
        str_detect(category, "annual") ~ "annual",
        str_detect(category, "aqs") ~ "aqs",
        TRUE ~ "unknown"
      ),
      analyte = str_remove(str_remove(category, "daily|blanks|8hour|hourly|annual|aqs"), "_")
    ) %>%
    select(year, unit_of_analysis, analyte, url) %>%
    # Match analytes with their descriptions
    mutate(analyte_description = case_when(
      analyte == "sites" ~ "Monitoring sites metadata",
      analyte == "monitors" ~ "Air quality monitors metadata",
      analyte == "conc_by_monitor" ~ "Annual concentration by monitor",
      analyte == "aqi_by_cbsa" ~ "Annual AQI by Core-Based Statistical Area (CBSA)",
      analyte == "aqi_by_county" ~ "Annual AQI by county",
      analyte == "44201" ~ "Ozone (O₃)",
      analyte == "42401" ~ "Sulfur Dioxide (SO₂)",
      analyte == "42101" ~ "Carbon Monoxide (CO)",
      analyte == "42602" ~ "Nitrogen Dioxide (NO₂)",
      analyte == "88101" ~ "PM2.5 (Fine Particulate Matter)",
      analyte == "88502" ~ "PM2.5 (Other Method)",
      analyte == "81102" ~ "PM10 (Coarse Particulate Matter)",
      analyte == "86101" ~ "Lead (Pb)",
      analyte == "SPEC" ~ "Speciated PM2.5 data",
      analyte == "PM10SPEC" ~ "Speciated PM10 data",
      analyte == "WIND" ~ "Wind speed and direction",
      analyte == "TEMP" ~ "Temperature",
      analyte == "PRESS" ~ "Barometric pressure",
      analyte == "RH_DP" ~ "Relative Humidity and Dew Point",
      analyte == "HAPS" ~ "Hazardous Air Pollutants (HAPs)",
      analyte == "VOCS" ~ "Volatile Organic Compounds (VOCs)",
      analyte == "NONOxNOy" ~ "Non-Methane Oxides of Nitrogen",
      analyte == "LEAD" ~ "Lead (Pb) monitoring",
      analyte == "all" ~ "All available air quality data",
      TRUE ~ "Unknown analyte"
    )) %>%
    mutate(year = case_when(
      is.na(year) ~ "all",
      TRUE ~ year
    ))

  # Update archive URLs if using Wayback Machine
  if (archive) {
    zip_links_tbl$url <- str_replace(
      zip_links_tbl$url,
      "https://aqs.epa.gov/aqsweb/airdata/",
      glue("https://web.archive.org/web/{archive_id}/https://aqs.epa.gov/aqsweb/airdata/")
    )
  }

  return(zip_links_tbl)
}
