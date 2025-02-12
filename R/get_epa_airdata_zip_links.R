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
#' @return A tibble with structured metadata of available ZIP files.
#' @import httr rvest dplyr stringr tibble glue rlang
#' @export
get_epa_airdata_zip_links <- function(archive = FALSE, archive_id = "20250126115248") {

  # Define URLs
  base_url <- "https://aqs.epa.gov/aqsweb/airdata/"
  if (archive) {
    url <- glue("https://web.archive.org/web/{archive_id}/{base_url}download_files.html")
    base_url <- glue("https://web.archive.org/web/{archive_id}/{base_url}")
  } else {
    url <- glue("{base_url}download_files.html")
  }

  # Fetch and parse HTML
  response <- httr::GET(url, encode = "utf-8")
  page_content <- content(response, as = "text")
  html <- read_html(page_content)

  # Extract ZIP file links
  # zip_links <- html %>%
  #   html_nodes("a") %>%
  #   html_attr("href") %>%
  #   grep("\\.zip$", ., value = TRUE)

  zip_links <- html %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    as_tibble() %>%
    filter(grepl("\\.zip$", value)) %>%
    pull(value)


  # Parse ZIP metadata
  zip_links_tbl <- tibble(url = zip_links) %>%
    mutate(
      filename = basename(.data$url),
      year = str_extract(.data$filename, "_(\\d{4})\\.zip$") %>% str_remove_all("_|\\.zip"),
      category = str_remove(.data$filename, "_\\d{4}\\.zip$") %>% str_remove("\\.zip$") %>%
        str_remove("_\\d{4}$"),
      unit_of_analysis = case_when(
        str_detect(.data$category, "daily") ~ "daily",
        str_detect(.data$category, "blanks") ~ "blanks",
        str_detect(.data$category, "8hour") ~ "8hour",
        str_detect(.data$category, "hourly") ~ "hourly",
        str_detect(.data$category, "annual") ~ "annual",
        str_detect(.data$category, "aqs") ~ "aqs",
        TRUE ~ "unknown"
      ),
      analyte = str_remove(.data$category, "daily|blanks|8hour|hourly|annual|aqs") %>% str_remove("_"),
      analyte_description = case_when(
        .data$analyte == "sites" ~ "Monitoring sites metadata",
        .data$analyte == "monitors" ~ "Air quality monitors metadata",
        .data$analyte == "conc_by_monitor" ~ "Annual concentration by monitor",
        .data$analyte == "aqi_by_cbsa" ~ "Annual AQI by Core-Based Statistical Area (CBSA)",
        .data$analyte == "aqi_by_county" ~ "Annual AQI by county",
        .data$analyte == "44201" ~ "Ozone (O\u2083)",
        .data$analyte == "42401" ~ "Sulfur Dioxide (SO\u2082)",
        .data$analyte == "42101" ~ "Carbon Monoxide (CO)",
        .data$analyte == "42602" ~ "Nitrogen Dioxide (NO\u2082)",
        .data$analyte == "88101" ~ "PM2.5 (Fine Particulate Matter)",
        .data$analyte == "88502" ~ "PM2.5 (Other Method)",
        .data$analyte == "81102" ~ "PM10 (Coarse Particulate Matter)",
        .data$analyte == "86101" ~ "Lead (Pb)",
        .data$analyte == "SPEC" ~ "Speciated PM2.5 data",
        .data$analyte == "PM10SPEC" ~ "Speciated PM10 data",
        .data$analyte == "WIND" ~ "Wind speed and direction",
        .data$analyte == "TEMP" ~ "Temperature",
        .data$analyte == "PRESS" ~ "Barometric pressure",
        .data$analyte == "RH_DP" ~ "Relative Humidity and Dew Point",
        .data$analyte == "HAPS" ~ "Hazardous Air Pollutants (HAPs)",
        .data$analyte == "VOCS" ~ "Volatile Organic Compounds (VOCs)",
        .data$analyte == "NONOxNOy" ~ "Non-Methane Oxides of Nitrogen",
        .data$analyte == "LEAD" ~ "Lead (Pb) monitoring",
        .data$analyte == "all" ~ "All available air quality data",
        TRUE ~ "Unknown analyte"
      ),
      year = if_else(is.na(.data$year), "all", .data$year)
    ) %>%
    select(.data$year, .data$unit_of_analysis, .data$analyte, .data$url, .data$analyte_description)

  return(zip_links_tbl)
}
