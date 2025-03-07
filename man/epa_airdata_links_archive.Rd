% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/epa_airdata_links_archive.R
\docType{data}
\name{epa_airdata_links_archive}
\alias{epa_airdata_links_archive}
\title{EPA AirData ZIP File Links Metadata}
\format{
A tibble with the following columns:
\describe{
\item{year}{Year extracted from the filename (if present).}
\item{unit_of_analysis}{Type of data aggregation (e.g., "daily", "hourly", "annual").}
\item{analyte}{The pollutant or air quality measure extracted from the filename.}
\item{url}{The full URL to download the ZIP file.}
\item{analyte_description}{A human-readable description of the analyte.}
}
}
\source{
\url{https://web.archive.org/web/20250126115248/https://aqs.epa.gov/aqsweb/airdata/download_files.html}
}
\usage{
epa_airdata_links_archive
}
\description{
This dataset contains metadata for all downloadable ZIP files from the EPA AirData website.
The metadata includes file links, year, unit of analysis, analyte type, and human-readable descriptions.
}
\examples{
data(epa_airdata_links_archive)
head(epa_airdata_links_archive)
}
\keyword{datasets}
