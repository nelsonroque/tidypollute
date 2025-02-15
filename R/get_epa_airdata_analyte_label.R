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
