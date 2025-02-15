#' Compute Air Pollutant Exposure for Given Time Windows
#'
#' This function calculates the mean, median, and standard deviation of exposure
#' to an air pollutant for each participant based on their recorded start and end dates.
#'
#' @param participants_df A dataframe containing participant information, including start and end dates.
#' @param air_quality_df A dataframe containing air quality measurements, with date and pollutant values.
#' @param date_col A string specifying the column name in `air_quality_df` that contains date values.
#' @param pollutant_col A string specifying the column name in `air_quality_df` that contains pollutant values.
#' @param start_col A string specifying the column name in `participants_df` that contains the start date.
#' @param end_col A string specifying the column name in `participants_df` that contains the end date.
#' @param county_name A string specifying the column name in `participants_df` and `air_quality_df` that contains county names.
#' @param state_name A string specifying the column name in `participants_df` and `air_quality_df` that contains state names.
#' @param group_vars A character vector of additional grouping variables from `participants_df`
#'   (e.g., participant ID, age, smoking status). Default is `NULL`.
#'
#' @import dplyr
#' @importFrom purrr map
#' @importFrom glue glue
#' @importFrom stats median sd
#'
#' @return A tibble containing the mean, median, and standard deviation of exposure for each
#'   participant during their study period, along with the number of valid exposure records.
#' @export
#'
#' @examples
#' library(tidyverse)
#'
#' # Example air quality data (PM2.5 levels)
#' air_quality_df <- tibble(
#'   date = seq(as.Date("2000-01-01"), as.Date("2020-12-31"), by = "day"),
#'   pm25_level = runif(length(date), min = 5, max = 80),
#'   county_name = rep(c("CountyA", "CountyB", "CountyC"), length.out = length(date)),
#'   state_name = rep(c("StateX", "StateY", "StateZ"), length.out = length(date))
#' )
#'
#' # Example participants data
#' participants_df <- tibble(
#'   participant_id = 1:5,
#'   start_date = as.Date(c("2005-06-01", "2010-01-01", "2015-03-15", "2008-07-10", "2012-09-20")),
#'   end_date = as.Date(c("2005-12-31", "2010-12-31", "2015-09-30", "2009-05-20", "2013-06-15")),
#'   age = c(65, 72, 50, 60, 58),
#'   county_name = c("CountyA", "CountyB", "CountyC", "CountyA", "CountyB"),
#'   state_name = c("StateX", "StateY", "StateZ", "StateX", "StateY"),
#'   smoking_status = c("Never", "Former", "Current", "Never", "Former")
#' )
#'
#' # Compute exposure
#' exposure_results <- summarise_exposure(
#'   participants_df = participants_df,
#'   air_quality_df = air_quality_df,
#'   date_col = "date",
#'   pollutant_col = "pm25_level",
#'   start_col = "start_date",
#'   end_col = "end_date",
#'   county_name = "county_name",
#'   state_name = "state_name",
#'   group_vars = c("participant_id", "age", "smoking_status")
#' )
#'
#' print(exposure_results)

summarise_exposure <- function(participants_df,
                               air_quality_df,
                               date_col,
                               pollutant_col,
                               start_col,
                               end_col,
                               county_name = "county",
                               state_name = "state",
                               group_vars = NULL) {

  # Ensure necessary columns exist
  required_cols <- c(start_col, end_col, county_name, state_name)
  missing_cols <- setdiff(required_cols, names(participants_df))
  if (length(missing_cols) > 0) {
    stop(glue("Missing columns in `participants_df`: {paste(missing_cols, collapse = ', ')}"))
  }

  required_air_cols <- c(date_col, pollutant_col, county_name, state_name)
  missing_air_cols <- setdiff(required_air_cols, names(air_quality_df))
  if (length(missing_air_cols) > 0) {
    stop(glue("Missing columns in `air_quality_df`: {paste(missing_air_cols, collapse = ', ')}"))
  }

  # Convert columns to Date format
  participants_df <- participants_df %>%
    mutate(across(all_of(c(start_col, end_col)), as.Date))

  air_quality_df <- air_quality_df %>%
    mutate(air_quality_date = as.Date(.data[[date_col]]))

  # Merge and filter by date range efficiently
  exposure_df <- participants_df %>%
    left_join(air_quality_df, by = c(county_name, state_name)) %>%
    filter(air_quality_date >= .data[[start_col]] & air_quality_date <= .data[[end_col]]) %>%
    group_by(across(all_of(group_vars))) %>%
    summarise(
      mean_exposure = mean(.data[[pollutant_col]], na.rm = TRUE),
      median_exposure = median(.data[[pollutant_col]], na.rm = TRUE),
      sd_exposure = sd(.data[[pollutant_col]], na.rm = TRUE),
      n_exposure_records = sum(!is.na(.data[[pollutant_col]])),
      .groups = "drop"
    )

  return(exposure_df)
}
