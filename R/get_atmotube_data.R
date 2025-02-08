#' Validate Atmotube API parameters
#'
#' Internal function to validate input parameters before making API requests.
#'
#' @param mac A string representing the MAC address of the Atmotube device (format: "aa:bb:cc:dd:ee:ff").
#' @param order A string indicating sorting order, either "asc" (ascending) or "desc" (descending).
#' @param format A string specifying the response format, either "json" or "csv".
#' @param offset A non-negative integer specifying the starting index for pagination.
#' @param limit An integer (1-1440) defining the number of records per request.
#' @param start_date A string representing the start date (optional, format: "YYYY-MM-DD").
#' @param end_date A string representing the end date (optional, format: "YYYY-MM-DD").
#' @noRd
validate_atmotube_params <- function(mac, order, format, offset, limit, start_date = NULL, end_date = NULL) {

  if (!order %in% c("asc", "desc")) stop("Invalid 'order' parameter. Must be 'asc' or 'desc'.")
  if (!format %in% c("json", "csv")) stop("Invalid 'format' parameter. Must be 'json' or 'csv'.")
  if (!is.numeric(offset) || offset < 0) stop("Invalid 'offset' parameter. Must be a non-negative integer.")
  if (!is.numeric(limit) || limit < 1 || limit > 1440) stop("Invalid 'limit' parameter. Must be between 1 and 1440.")
  if (!grepl("^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$", mac)) stop("Invalid 'mac' parameter. Must be in format 'aa:bb:cc:dd:ee:ff'.")

  if (!is.null(start_date) && !is.null(end_date)) {
    if (!grepl("^\\d{4}-\\d{2}-\\d{2}$", start_date) || !grepl("^\\d{4}-\\d{2}-\\d{2}$", end_date)) {
      stop("Invalid date format. Use 'YYYY-MM-DD'.")
    }
    start_date <- as.Date(start_date)
    end_date <- as.Date(end_date)
    if (end_date < start_date) stop("End date must be after start date.")
  }
}

#' Fetch Atmotube Data from the API
#'
#' Internal function to send a request to the Atmotube API and return data.
#'
#' @param api_key A string containing the user's API key (required).
#' @param mac A string representing the MAC address of the Atmotube device.
#' @param start_date A string representing the start date (format: "YYYY-MM-DD").
#' @param end_date A string representing the end date (format: "YYYY-MM-DD").
#' @param order Sorting order: either "asc" (ascending) or "desc" (descending).
#' @param format Response format: "json" or "csv".
#' @param offset The starting index for pagination.
#' @param limit The number of records to retrieve per request.
#' @param separator CSV separator (if format is "csv").
#' @param base_url API endpoint URL.
#' @return A JSON list (if `format="json"`) or raw CSV data (if `format="csv"`).
#' @noRd
fetch_atmotube_data <- function(api_key, mac, start_date, end_date, order, format, offset, limit, separator, base_url) {

  validate_atmotube_params(mac, order, format, offset, limit, start_date, end_date)

  # Construct the request
  req <- httr2::request(base_url) %>%
    httr2::req_url_query(
      api_key = api_key, mac = mac, order = order, format = format,
      offset = offset, limit = limit, start_date = start_date, end_date = end_date, separator = separator
    ) %>%
    httr2::req_headers("accept" = "application/json")

  # Perform the request
  resp <- httr2::req_perform(req)

  # Handle API errors
  if (httr2::resp_status(resp) >= 400) {
    stop("API request failed with status ", httr2::resp_status(resp), ": ", httr2::resp_body_string(resp))
  }

  # Return JSON or raw CSV
  if (format == "json") {
    return(httr2::resp_body_json(resp))
  } else {
    return(httr2::resp_body_string(resp))
  }
}

#' Retrieve Atmotube Data from the API (Single or Multi-Day)
#'
#' Fetches Atmotube air quality data from the Atmotube Cloud API.
#' Automatically switches to **batch mode** if the requested date range exceeds 7 days,
#' ensuring compliance with API limits while preserving a **one-day overlap**.
#'
#' @param api_key A string containing the user's API key (required).
#' @param mac A string representing the MAC address of the Atmotube device (format: "aa:bb:cc:dd:ee:ff").
#' @param start_date A string representing the start date (format: "YYYY-MM-DD").
#' @param end_date A string representing the end date (format: "YYYY-MM-DD").
#' @param order A string indicating sorting order, either "asc" (ascending) or "desc" (descending). Default is "asc".
#' @param format A string specifying the response format, either "json" or "csv". Default is "json".
#' @param offset A non-negative integer specifying the starting index for pagination. Default is 0.
#' @param limit An integer (1-1440) defining the number of records per request. Default is 1440.
#' @param separator A string indicating the CSV separator when `format="csv"`. Default is ",".
#' @param base_url A string representing the API base URL (default: `"https://api.atmotube.com/api/v1/data"`).
#'
#' @return A list (if `format="json"`) or a concatenated CSV string (if `format="csv"`).
#' @export
#'
#' @examples
#' \dontrun{
#' api_key <- "your_api_key_here"
#' mac <- "aa:bb:cc:dd:ee:ff"
#' start_date <- "2024-06-01"
#' end_date <- "2024-06-15"
#' data <- get_atmotube_data(api_key, mac, start_date, end_date)
#' print(data)
#' }
get_atmotube_data <- function(api_key, mac, start_date, end_date, order = "asc",
                              format = "json", offset = 0, limit = 1440, separator = ",",
                              base_url = "https://api.atmotube.com/api/v1/data") {

  # Validate input parameters
  validate_atmotube_params(mac, order, format, offset, limit, start_date, end_date)

  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)

  # If the date range is within 7 days, make a single request
  if (as.numeric(end_date - start_date) <= 7) {
    return(fetch_atmotube_data(api_key, mac, as.character(start_date), as.character(end_date),
                               order, format, offset, limit, separator, base_url))
  }

  # Otherwise, process in 7-day chunks with 1-day overlap
  results <- if (format == "json") list() else c()

  current_start <- start_date
  while (current_start <= end_date) {
    current_end <- min(current_start + 6, end_date)  # Fetch up to 7 days

    data <- fetch_atmotube_data(api_key, mac, as.character(current_start), as.character(current_end),
                                order, format, offset, limit, separator, base_url)

    if (format == "json") {
      results <- append(results, list(data))
    } else {
      results <- c(results, data)
    }

    # Move to the next chunk, ensuring 1-day overlap
    current_start <- current_end
  }

  # Return merged results
  if (format == "json") {
    return(results)
  } else {
    return(paste(results, collapse = "\n"))
  }
}
