#' Scrape Table Headers from EPA AirData Webpage
#'
#' This function scrapes all table headers from the EPA AirData download page, removes the header `"Year"`,
#' and returns a tibble.
#'
#' @return A tibble with a single column `label` containing unique table headers (excluding `"Year"`).
#' @importFrom rvest read_html html_nodes html_text
#' @importFrom tibble tibble
#' @export
#'
#' @examples
#' analyte_codes <- get_epa_airdata_analyte_codes()
#' print(analyte_codes)
get_epa_airdata_analyte_codes <- function() {
  # Define the URL
  url <- "https://aqs.epa.gov/aqsweb/airdata/download_files.html"

  # Read the webpage
  webpage <- rvest::read_html(url)

  # Extract table headers (th elements) and remove duplicates
  table_headers <- webpage %>%
    rvest::html_nodes("th") %>%
    rvest::html_text(trim = TRUE) %>%
    unique()

  # Remove "Year" from the headers
  table_headers_filt <- table_headers[table_headers != "Year"]

  # Convert to a tibble
  headers_tibble <- tibble::tibble(label = table_headers_filt)

  return(headers_tibble)
}
