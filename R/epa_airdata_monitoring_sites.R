#' EPA Air Quality Monitoring Sites Metadata
#'
#' This dataset contains metadata for air quality monitoring sites in the United States.
#' It includes site location details, land use classification, elevation, operational
#' dates, and other relevant attributes.
#'
#' @format A tibble with the following columns:
#' \describe{
#'   \item{State Code}{FIPS code representing the U.S. state.}
#'   \item{County Code}{FIPS code representing the county within the state.}
#'   \item{Site Number}{Unique identifier for the monitoring site within the county.}
#'   \item{Latitude}{Latitude of the monitoring site in decimal degrees.}
#'   \item{Longitude}{Longitude of the monitoring site in decimal degrees.}
#'   \item{Datum}{Geodetic datum used for latitude/longitude coordinates (e.g., "WGS84").}
#'   \item{Elevation}{Elevation of the site in meters above sea level.}
#'   \item{Land Use}{Classification of land use surrounding the site (e.g., "RESIDENTIAL", "AGRICULTURAL").}
#'   \item{Location Setting}{General setting of the site (e.g., "URBAN AND CENTER CITY", "RURAL").}
#'   \item{Site Established Date}{Date when the monitoring site was established.}
#'   \item{Site Closed Date}{Date when the site ceased operation (if applicable).}
#'   \item{Met Site State Code}{FIPS code of the meteorological site, if applicable.}
#'   \item{Met Site County Code}{FIPS code of the county where the meteorological site is located, if applicable.}
#'   \item{Met Site Site Number}{Unique identifier of the associated meteorological site, if applicable.}
#'   \item{Met Site Type}{Type of meteorological site, if applicable.}
#'   \item{Met Site Distance}{Distance from the monitoring site to the associated meteorological site, in kilometers.}
#'   \item{Met Site Direction}{Cardinal direction from the monitoring site to the meteorological site.}
#'   \item{GMT Offset}{Offset from GMT (Greenwich Mean Time) in hours.}
#'   \item{Owning Agency}{Agency responsible for maintaining the monitoring site.}
#'   \item{Local Site Name}{Locally assigned name of the monitoring site.}
#'   \item{Address}{Physical address of the monitoring site.}
#'   \item{Zip Code}{ZIP code where the monitoring site is located.}
#'   \item{State Name}{Full name of the state where the site is located.}
#'   \item{County Name}{Full name of the county where the site is located.}
#'   \item{City Name}{City where the monitoring site is located, if applicable.}
#'   \item{CBSA Name}{Core-Based Statistical Area (CBSA) associated with the site, if applicable.}
#'   \item{Tribe Name}{Name of the Native American tribe associated with the site, if applicable.}
#'   \item{Extraction Date}{Date when this data was extracted.}
#' }
#' @source \url{https://www.epa.gov/outdoor-air-quality-data}
#' @examples
#' data(epa_airdata_monitoring_sites)
#' head(epa_airdata_monitoring_sites)
"epa_airdata_monitoring_sites"
