#' EPA AirData Analyte Codes
#'
#' This dataset contains metadata for all downloadable ZIP files from the EPA AirData website.
#' The metadata includes file links, year, unit of analysis, analyte type, and human-readable descriptions.
#'
#' @format A tibble with the following columns:
#' \describe{
#'   \item{analyte}{The pollutant or air quality measure extracted from the filename.}
#' }
#' @source \url{https://aqs.epa.gov/aqsweb/airdata/download_files.html}
#' @examples
#' data(epa_analyte_codes)
#' head(epa_analyte_codes)
"epa_analyte_codes"
