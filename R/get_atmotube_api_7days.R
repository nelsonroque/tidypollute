#' Retrieve Atmotube Data from the API
#'
#' Fetches air quality data from the Atmotube Cloud API based on user-defined parameters.
#'
#' @param api_key A string containing the user's API key (required).
#' @param mac A string representing the MAC address of the Atmotube device (format: "aa:bb:cc:dd:ee:ff").
#' @param start_date A string representing the start date (format: "YYYY-MM-DD").
#' @param end_date A string representing the end date (format: "YYYY-MM-DD").
#' @param order A string indicating sorting order, either "asc" (ascending) or "desc" (descending). Default is "asc".
#' @param format A string specifying the response format, either "json" or "csv". Default is "json".
#' @param offset A non-negative integer specifying the starting index for pagination. Default is 0.
#' @param limit An integer (1-1440) defining the number of records to retrieve. Default is 1440.
#' @param separator A string indicating the CSV separator when `format="csv"`. Default is "semicolon".
#'
#' @return A list (if `format="json"`) or a raw CSV response (if `format="csv"`).
#' @export
#'
#' @examples
#' \dontrun{
#' api_key <- "your_api_key_here"
#' mac <- "aa:bb:cc:dd:ee:ff"
#' start_date <- "2024-07-17"
#' end_date <- "2024-07-17"
#' data <- get_atmotube_data(api_key, mac, start_date, end_date)
#' print(data)
#' }
get_atmotube_data <- function(api_key, mac, start_date, end_date, order = "asc",
                              format = "json", offset = 0, limit = 1440, separator = "semicolon") {

  # Validate 'order' parameter
  if (!order %in% c("asc", "desc")) {
    stop("Invalid 'order' parameter. Must be 'asc' or 'desc'.")
  }

  # Validate 'format' parameter
  if (!format %in% c("json", "csv")) {
    stop("Invalid 'format' parameter. Must be 'json' or 'csv'.")
  }

  # Validate 'offset' parameter
  if (!is.numeric(offset) || offset < 0) {
    stop("Invalid 'offset' parameter. Must be a non-negative integer.")
  }

  # Validate 'limit' parameter
  if (!is.numeric(limit) || limit < 1 || limit > 1440) {
    stop("Invalid 'limit' parameter. Must be between 1 and 1440.")
  }

  # Validate 'mac' address format
  if (!grepl("^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$", mac)) {
    stop("Invalid 'mac' parameter. Must be in format 'aa:bb:cc:dd:ee:ff'.")
  }

  base_url <- "https://api.atmotube.com/api/v1/data"

  # Construct the request
  req <- request(base_url) %>%
    req_url_query(
      api_key = api_key,
      mac = mac,
      order = order,
      format = format,
      offset = offset,
      limit = limit,
      start_date = start_date,
      end_date = end_date,
      separator = separator
    ) %>%
    req_headers("accept" = "application/json")

  # Perform the request
  resp <- req_perform(req)

  # Return JSON or raw CSV
  if (format == "json") {
    return(resp_body_json(resp))
  } else {
    return(resp_body_string(resp))
  }
}
