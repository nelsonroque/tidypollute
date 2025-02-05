#' US States Data
#'
#' A dataset containing geographical and regional information for US states.
#'
#' @format A tibble with 50 rows and 7 variables:
#' \describe{
#'   \item{state_name}{Character. The full name of the US state (e.g., "Alabama").}
#'   \item{state_abbreviation}{Character. The two-letter postal abbreviation (e.g., "AL").}
#'   \item{state_area}{Numeric. The total land area of the state in square miles.}
#'   \item{state_center_x}{Numeric. The x-coordinate (longitude) of the geographic center of the state.}
#'   \item{state_center_y}{Numeric. The y-coordinate (latitude) of the geographic center of the state.}
#'   \item{state_division}{Factor. The US Census Bureau division classification (e.g., "South Atlantic").}
#'   \item{state_region}{Factor. The US Census Bureau region classification (e.g., "South").}
#' }
#'
#' @details
#' The dataset provides basic geographic and classification information about each US state.
#' It includes area measurements, geographic center coordinates, and census region classifications.
#'
#' @source
#' Data sourced from base R datasets: \code{state.name}, \code{state.abb}, \code{state.area}, \code{state.center}, \code{state.division}, and \code{state.region}.
#'
#' @examples
#' data(us_states)
#' head(us_states)
#'
#' @keywords datasets
"us_states"
