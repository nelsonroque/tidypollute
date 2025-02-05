#' Download, Extract, and Optionally Read or Combine CSV Files from EPA AirNow ZIP URLs
#'
#' This function downloads ZIP files from provided URLs (either as a character vector or a data frame column),
#' extracts CSV files, and optionally reads and combines them into a single tibble.
#'
#' @param urls A character vector of URLs or a data frame containing a column named `urls`.
#' @param output_dir A directory path where downloaded and extracted files will be stored. Defaults to a temporary directory.
#' @param download Logical. Whether to download the ZIP files. Defaults to TRUE.
#' @param unzip Logical. Whether to extract the ZIP files. Requires `download = TRUE` or existing ZIPs. Defaults to TRUE.
#' @param read_csvs Logical. Whether to read extracted CSVs into R. Requires `unzip = TRUE` or existing extracted files. Defaults to TRUE.
#' @param stack Logical. Whether to combine extracted CSVs into a single tibble. Requires `read_csvs = TRUE`. Defaults to TRUE.
#' @param clean_names Logical. Whether to clean column names in the final tibble (using janitor::clean_names()). Defaults to TRUE.
#'
#' @return If `read_csvs = TRUE`, returns either a tibble combining all extracted CSV files (`stack = TRUE`)
#' or a list of tibbles (`stack = FALSE`). If `read_csvs = FALSE`, returns a list of file paths to extracted CSVs.
#' Skips URLs that fail to download or extract.
#' @export
#'
#' @importFrom httr GET write_disk
#' @importFrom readr read_csv
#' @importFrom purrr map_dfr map compact
#' @importFrom tools file_path_sans_ext
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' df <- tidypollute::scrape_epa_airdata_zip_links()
#'
#' # Filter dataset and pass a column of URLs
#' filtered_df <- df %>% filter(year == 1991, analyte == "WIND")
#'
#' # Use function with a data frame
#' download_stack_epa_airdata(filtered_df, download = TRUE, stack = TRUE, output_dir = "data/")
#'
#' # Use function with a character vector
#' download_stack_epa_airdata(filtered_df$urls, download = TRUE, stack = TRUE, output_dir = "data/")
#' }
download_stack_epa_airdata <- function(urls,
                                      output_dir = tempdir(),
                                      download = TRUE,
                                      unzip = TRUE,
                                      read_csvs = TRUE,
                                      stack = TRUE,
                                      clean_names=TRUE) {
  # If `urls` is a data frame, extract the correct column
  if (is.data.frame(urls)) {
    if ("url" %in% names(urls)) {
      urls <- urls$url
    } else if ("urls" %in% names(urls)) {
      urls <- urls$urls
    } else {
      stop("The input data frame must contain a column named 'url' or 'urls'.")
    }
  }

  # Ensure the output directory exists
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

  process_zip <- function(url) {
    tryCatch({
      # Define file paths
      zip_file <- file.path(output_dir, basename(url))
      unzip_dir <- file.path(output_dir, tools::file_path_sans_ext(basename(url)))

      # Check dependencies between parameters
      if (!download && !file.exists(zip_file)) {
        message(glue::glue("Skipping {url}: ZIP file not found and download is disabled."))
        return(NULL)
      }

      if (!unzip && !file.exists(zip_file)) {
        message(glue::glue("Skipping {url}: Extraction disabled and ZIP file not found."))
        return(NULL)
      }

      if (!read_csvs && !unzip && !dir.exists(unzip_dir)) {
        message(glue::glue("Skipping {url}: Cannot return CSV paths without unzipping first."))
        return(NULL)
      }

      # Download ZIP file if needed
      if (download) {
        if (!file.exists(zip_file)) {
          message(glue::glue("Downloading {url}..."))
          httr::GET(url, httr::write_disk(zip_file, overwrite = TRUE))
        } else {
          message(glue::glue("Using cached ZIP for {url}"))
        }
      }

      # Extract ZIP files if specified
      if (unzip) {
        if (!dir.exists(unzip_dir)) dir.create(unzip_dir, recursive = TRUE)

        if (!dir.exists(unzip_dir) || length(list.files(unzip_dir, pattern = "\\.csv$")) == 0) {
          message(glue::glue("Extracting {zip_file}..."))
          unzip(zip_file, exdir = unzip_dir)
        } else {
          message(glue::glue("Using cached CSVs for {url}"))
        }
      }

      # Get all CSV file paths in the extracted folder
      csv_files <- list.files(unzip_dir, pattern = "\\.csv$", full.names = TRUE)

      if (!read_csvs) {
        return(csv_files)  # Return file paths if reading is disabled
      }

      # Read CSV files into data frames
      csv_data <- purrr::map(csv_files, readr::read_csv)

      return(csv_data)

    }, error = function(e) {
      message(glue::glue("Error processing {url}: {e$message}"))
      return(NULL)  # Return NULL to skip failed downloads
    })
  }

  # Apply function to all URLs
  all_data <- purrr::map(urls, process_zip, .progress = TRUE)

  # Flatten the list and remove NULLs
  all_data <- purrr::compact(all_data)
  all_data <- unlist(all_data, recursive = FALSE)

  if (!read_csvs) {
    return(all_data)  # Return list of file paths
  }

  if (stack) {
    stacked_df = purrr::map_dfr(all_data, identity)

    if(clean_names) {
      stacked_df <- janitor::clean_names(stacked_df)
    }
    return(stacked_df)  # Stack all CSVs into a single tibble
  } else {
    return(all_data)  # Return as a list of tibbles
  }
}
