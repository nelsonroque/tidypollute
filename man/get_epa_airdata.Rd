% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_epa_airdata.R
\name{get_epa_airdata}
\alias{get_epa_airdata}
\title{Download EPA Air Quality Data (EPA AirData Flat Files)}
\usage{
get_epa_airdata(
  analyte,
  start_year,
  end_year,
  freq,
  output_dir = "data/",
  prompt_download = F,
  archive = FALSE,
  archive_id = NULL
)
}
\arguments{
\item{analyte}{Character string specifying the EPA analyte code (e.g., "88101" for PM2.5)}

\item{start_year}{Numeric value for the starting year of data collection}

\item{end_year}{Numeric value for the ending year of data collection}

\item{freq}{Character string specifying the frequency of analysis (e.g., "daily", "hourly", "annual")}

\item{output_dir}{Character string specifying the directory for downloaded files.
Defaults to "data/"}

\item{prompt_download}{Boolean indicating whether to prompt user before downloading (default: False)}

\item{archive}{Logical. If \code{TRUE}, the function retrieves data from the Wayback Machine
(Internet Archive) rather than the live EPA AirData website. Defaults to \code{FALSE}.}

\item{archive_id}{Character. The timestamp ID for the archived version of the EPA AirData website
on the Wayback Machine (only used if \code{archive = TRUE}). Defaults to \code{"20250126115248"}.}
}
\value{
A data frame containing the stacked EPA air quality data or NULL if no data
is found or download is cancelled
}
\description{
Downloads and stacks EPA air quality data for specified parameters with progress tracking.
}
\details{
The function includes interactive confirmation before downloading and displays a
progress bar during the download process. It will create the output directory if
it doesn't exist.
}
\examples{
\dontrun{
# Download PM2.5 data
pm25_data <- get_epa_data(
  analyte = "88101",
  start_year = 2020,
  end_year = 2023,
  freq = "daily",
  output_dir = "path/to/my/data/"
)
}

}
