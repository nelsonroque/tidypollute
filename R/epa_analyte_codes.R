#' EPA AirData Analyte Codes
#'
#' This dataset contains the queryable names for EPA analytes from the EPA AirData website.
#' @format A tibble with the following columns:
#' \describe{
#'   \item{label}{The label for the pollutant or air quality measure extracted from the filename.}
#'   \item{analyte}{The pollutant or air quality measure extracted from the filename.}
#' }
#' @source \url{https://aqs.epa.gov/aqsweb/airdata/download_files.html}
#' @examples
#' data(epa_analyte_codes)
#' epa_analyte_codes
"epa_analyte_codes"
