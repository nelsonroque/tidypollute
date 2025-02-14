#' Retrieve Unique Analyte Codes from Package Dataset
#'
#' This function extracts unique analyte codes from the available EPA AirData ZIP file links, as stored within the package.
#'
#' @return A tibble containing a single column `analyte` containing unique analyte codes.
#' @export
#'
#' @examples
#' analyte_codes <- get_epa_airdata_analyte_tibble()
#' print(analyte_codes)
get_epa_airdata_analyte_tibble <- function() {
  # Extract distinct analyte codes from the dataset
  return(epa_analyte_codes)
}
