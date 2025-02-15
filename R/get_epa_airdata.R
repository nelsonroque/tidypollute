#' Download EPA Air Quality Data (EPA AirData Flat Files)
#'
#' @description
#' Downloads and stacks EPA air quality data for specified parameters with progress tracking.
#'
#' @param archive Logical. If `TRUE`, the function retrieves data from the Wayback Machine
#'   (Internet Archive) rather than the live EPA AirData website. Defaults to `FALSE`.
#' @param archive_id Character. The timestamp ID for the archived version of the EPA AirData website
#'   on the Wayback Machine (only used if `archive = TRUE`). Defaults to `"20250126115248"`.
#' @param analyte Character string specifying the EPA analyte code (e.g., "88101" for PM2.5)
#' @param start_year Numeric value for the starting year of data collection
#' @param end_year Numeric value for the ending year of data collection
#' @param freq Character string specifying the frequency of analysis (e.g., "daily", "hourly", "annual")
#' @param prompt_download Boolean indicating whether to prompt user before downloading (default: False)
#' @param output_dir Character string specifying the directory for downloaded files.
#'   Defaults to "data/"
#'
#' @return A data frame containing the stacked EPA air quality data or NULL if no data
#'   is found or download is cancelled
#'
#' @details
#' The function includes interactive confirmation before downloading and displays a
#' progress bar during the download process. It will create the output directory if
#' it doesn't exist.
#'
#' @examples
#' \dontrun{
#' # Download PM2.5 data
#' pm25_data <- get_epa_data(
#'   analyte = "88101",
#'   start_year = 2020,
#'   end_year = 2023,
#'   freq = "daily",
#'   output_dir = "path/to/my/data/"
#' )
#' }
#'
#' @importFrom dplyr filter
#' @importFrom progress progress_bar
#' @importFrom tidypollute download_stack_epa_airdata
#'
#' @export
get_epa_airdata <- function(analyte, start_year, end_year, freq, output_dir = "data/", prompt_download=F, archive=FALSE, archive_id=NULL) {
  `%nin%` <- Negate("%in%")

  if (missing(analyte) || missing(start_year) || missing(end_year) || missing(freq)) {
    stop("All parameters must be specified: analyte, start_year, end_year, and freq")
  }

  if(analyte %nin% tidypollute::epa_analyte_codes$analyte) {
    stop("Invalid analyte code. Please check the available analyte codes by running `tidypollute::epa_analyte_codes$analyte`.")
  }

  # Validate and create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
    message(sprintf("Created output directory: %s", output_dir))
  }

  # Scrape fresh data links instead of using epa_zip_links
  zip_links <- tidypollute::get_epa_airdata_zip_links(archive=archive, archive_id=archive_id)

  # Get the data links for specified analyte and years
  data_links <- zip_links %>%
    filter(.data$analyte == !!analyte,
           .data$unit_of_analysis == !!freq,
           .data$year >= start_year & .data$year <= end_year)

  if (nrow(data_links) == 0) {
    message("No data found for the specified parameters.")
    return(NULL)
  }

  cat("\nPreparing to download:\n")
  cat("Analyte:", analyte, "\n")
  cat("Years:", start_year, "to", end_year, "\n")
  cat("Number of files:", nrow(data_links), "\n")
  cat("Freq of data:", freq, "\n")
  cat("Output directory:", output_dir, "\n\n")

  if(!prompt_download) {
    message("Proceeding with download...")
  } else {
    message("Please review the download details before proceeding.")
    response <- readline(prompt = "Do you want to proceed with the download? (y/n): ")
    if (tolower(response) != "y") {
      message("Download cancelled by user.")
      return(NULL)
    }
  }

  pb <- progress_bar$new(
    format = "Downloading [:bar] :percent eta: :eta",
    total = nrow(data_links),
    clear = FALSE,
    width = 60
  )

  # Download data with progress tracking
  epa_data <- data_links %>%
    tidypollute::download_stack_epa_airdata(download = TRUE,
                                            stack = TRUE,
                                            output_dir = output_dir)

  pb$tick(nrow(data_links))

  message("\nDownload complete!")
  return(epa_data)
}
