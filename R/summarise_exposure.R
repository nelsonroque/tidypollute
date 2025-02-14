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
#' @param group_vars A character vector of additional grouping variables from `participants_df` (e.g., participant ID, age, smoking status). Default is `NULL`.
#'
#' @return A tibble containing the mean exposure for each participant during their study period.
#' @export
#'
#' @examples
#' library(tidyverse)
#'
#' # Example air quality data (PM2.5 levels)
#' air_quality_df <- tibble(
#'   date = seq(as.Date("2000-01-01"), as.Date("2020-12-31"), by = "day"),
#'   pm25_level = runif(length(date), min = 5, max = 80)
#' )
#'
#' # Example participants data
#' participants_df <- tibble(
#'   participant_id = 1:5,
#'   start_date = as.Date(c("2005-06-01", "2010-01-01", "2015-03-15", "2008-07-10", "2012-09-20")),
#'   end_date = as.Date(c("2005-12-31", "2010-12-31", "2015-09-30", "2009-05-20", "2013-06-15")),
#'   age = c(65, 72, 50, 60, 58),
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
                               group_vars = NULL) {
  library(dplyr)

  # Convert column names to symbols
  date_col <- sym(date_col)
  pollutant_col <- sym(pollutant_col)
  start_col <- sym(start_col)
  end_col <- sym(end_col)

  # Ensure group_vars is a character vector
  if (!is.null(group_vars)) {
    group_vars <- syms(group_vars)
  }

  # Rename air quality date column to avoid conflicts
  air_quality_df <- air_quality_df %>%
    rename(air_quality_date = !!date_col)

  # Perform a proper join and filter based on exposure window
  exposure_df <- participants_df %>%
    rowwise() %>% # Ensure filtering happens per participant
    mutate(mean_exposure = mean(
      air_quality_df %>%
        filter(air_quality_date >= !!start_col & air_quality_date <= !!end_col) %>%
        pull(!!pollutant_col),
      na.rm = TRUE
    )) %>%
    mutate(median_exposure = median(
      air_quality_df %>%
        filter(air_quality_date >= !!start_col & air_quality_date <= !!end_col) %>%
        pull(!!pollutant_col),
      na.rm = TRUE
    )) %>%
    mutate(sd_exposure = sd(
      air_quality_df %>%
        filter(air_quality_date >= !!start_col & air_quality_date <= !!end_col) %>%
        pull(!!pollutant_col),
      na.rm = TRUE
    )) %>%
    mutate(n_exposure_records = sum(
      (air_quality_df %>%
        filter(air_quality_date >= !!start_col & air_quality_date <= !!end_col) %>%
        pull(!!pollutant_col)) %>%
        is.finite(),
      na.rm = TRUE
    )) %>%
    ungroup()

  # Select relevant columns
  exposure_df <- exposure_df %>%
    select(!!!group_vars, mean_exposure, median_exposure, sd_exposure, n_exposure_records)

  return(exposure_df)
}
