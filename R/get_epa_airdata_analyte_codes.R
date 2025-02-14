#' Scrape Table Headers from EPA AirData Webpage
#'
#' This function extracts all table headers (`<th>` elements) from the EPA AirData download page.
#' It removes the `"Year"` header, which is not needed for analysis, and returns a tibble
#' containing the cleaned list of table headers.
#'
#' @return A tibble with a single column `label` containing unique table headers (excluding `"Year"`).
#' @importFrom rvest read_html html_nodes html_text
#' @importFrom tibble tibble
#' @export
#'
#' @examples
#' table_headers <- get_epa_airdata_analyte_label()
#' print(table_headers)
get_epa_airdata_analyte_label <- function() {
  # Define the URL for the EPA AirData download page
  url <- "https://aqs.epa.gov/aqsweb/airdata/download_files.html"

  # Read the webpage and parse HTML content
  webpage <- rvest::read_html(url)

  # Extract unique table headers from <th> elements
  table_headers <- webpage %>%
    rvest::html_nodes("th") %>%
    rvest::html_text(trim = TRUE) %>%
    unique()

  # Remove the "Year" header from the extracted list
  table_headers_filt <- table_headers[table_headers != "Year"]

  # Convert the filtered headers into a tibble format
  headers_tibble <- tibble::tibble(label = table_headers_filt)

  return(headers_tibble)
}

#' Retrieve Unique Analyte Codes from EPA AirData Archive
#'
#' This function extracts unique analyte codes from the available EPA AirData ZIP file links.
#' These analyte codes serve as identifiers for different air quality measurements in the dataset.
#' The function supports fetching data from either the live website or an archived snapshot.
#'
#' @param archive Logical. If `TRUE`, retrieves analyte codes from an archived version of the dataset.
#' @param archive_id Character. The specific archive snapshot ID to use when `archive = TRUE`.
#'        Default is `"20250126115248"`, referring to the most recent known snapshot at the time of documentation.
#'
#' @return A character vector containing unique analyte codes.
#' @importFrom dplyr select pull
#' @export
#'
#' @examples
#' analyte_codes <- get_epa_airdata_analyte_codes()
#' print(analyte_codes)
get_epa_airdata_analyte_codes <- function(archive = FALSE, archive_id = "20250126115248") {
  # Retrieve ZIP file links containing air quality data
  zip_links <- epa_airdata_links

  # Extract distinct analyte codes from the dataset
  distinct_analytes <- zip_links %>%
    dplyr::select(.data$analyte) %>%
    dplyr::pull(.data$analyte) %>%
    unique()

  return(distinct_analytes)
}
