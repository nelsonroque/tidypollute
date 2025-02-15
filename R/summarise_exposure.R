#' Compute Air Pollutant Exposure for Given Time Windows
#'
#' This function calculates the mean exposure to an air pollutant for each participant
#' based on their recorded start and end dates.
#'
#' @param participants_df A dataframe containing participant information, including start and end dates.
#' @param air_quality_df A dataframe containing air quality measurements, with date and pollutant values.
#' @param date_col A string specifying the column name in `air_quality_df` that contains date values.
#' @param pollutant_col A string specifying the column name in `air_quality_df` that contains pollutant values.
#' @param start_col A string specifying the column name in `participants_df` that contains the start date.
#' @param end_col A string specifying the column name in `participants_df` that contains the end date.
#' @param county_name A string specifying the column name in `participants_df` and `air_quality_df` that contains county names.
#' @param state_name A string specifying the column name in `participants_df` and `air_quality_df` that contains state names.
#' @param group_vars A character vector of additional grouping variables from `participants_df` (e.g., participant ID, age, smoking status). Default is `NULL`.
#' @import dplyr
#' @importFrom stats median sd
#' @importFrom glue glue
#' @return A tibble containing the mean exposure for each participant during their study period.
#' @export
#'
#' @examples
#' library(tidyverse)
#'
#' # Example air quality data (PM2.5 levels)
#' air_quality_df <- tibble(
#'   date = seq(as.Date("2000-01-01"), as.Date("2020-12-31"), by = "day"),
#'   pm25_level = runif(length(date), min = 5, max = 80),
#'   county = rep(c("CountyA", "CountyB", "CountyC"), length.out = length(date)),
#'   state = rep(c("StateX", "StateY", "StateZ"), length.out = length(date))
#' )
#'
#' # Example participants data
#' participants_df <- tibble(
#'   participant_id = 1:5,
#'   start_date = as.Date(c("2005-06-01", "2010-01-01", "2015-03-15", "2008-07-10", "2012-09-20")),
#'   end_date = as.Date(c("2005-12-31", "2010-12-31", "2015-09-30", "2009-05-20", "2013-06-15")),
#'   age = c(65, 72, 50, 60, 58),
#'   county = c("CountyA", "CountyB", "CountyC", "CountyA", "CountyB"),
#'   state = c("StateX", "StateY", "StateZ", "StateX", "StateY"),
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
#'   county_name = "county",
#'   state_name = "state",
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

  if (!(county_name %in% names(air_quality_df))) {
    stop(glue::glue("Column `{county_name}` not found in `air_quality_df`."))
  }

  if (!(state_name %in% names(air_quality_df))) {
    stop(glue::glue("Column `{state_name}` not found in `air_quality_df`."))
  }

  # Rename air quality date column to avoid conflicts
  air_quality_df <- air_quality_df %>%
    rename(air_quality_date = !!sym(date_col))

  # Compute exposure per participant
  exposure_df <- participants_df %>%
    rowwise() %>%
    mutate(
      participant_county = .data[[county_name]],
      participant_state = .data[[state_name]]) %>%
    mutate(
      exposure_data = list(
        {
          filtered_data <- air_quality_df %>%
            filter(air_quality_date >= cur_data()[[start_col]] & air_quality_date <= cur_data()[[end_col]]) %>%
            filter(.data[[county_name]] == participant_county & .data[[state_name]] == participant_state) %>%
            pull(!!sym(pollutant_col))

          if (length(filtered_data) == 0) NA_real_ else filtered_data
        }
      )
    )
    mutate(
      mean_exposure = ifelse(length(exposure_data) > 0, mean(exposure_data, na.rm = TRUE), NA_real_),
      median_exposure = ifelse(length(exposure_data) > 0, stats::median(exposure_data, na.rm = TRUE), NA_real_),
      sd_exposure = ifelse(length(exposure_data) > 0, stats::sd(exposure_data, na.rm = TRUE), NA_real_),
      n_exposure_records = ifelse(length(exposure_data) > 0, sum(is.finite(exposure_data), na.rm = TRUE), 0)
    ) %>%
    select(!!!syms(group_vars), mean_exposure, median_exposure, sd_exposure, n_exposure_records) %>%
    ungroup()

  return(exposure_df)
}
