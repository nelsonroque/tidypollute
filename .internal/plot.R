
# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(patchwork)
library(viridis)
library(hrbrthemes)
library(extrafont)
library(lubridate)  # For handling dates

# Ensure Helvetica or Arial is available
loadfonts(device = "win")
theme_set(theme_minimal(base_family = "Helvetica"))  # Use Arial if Helvetica isn't available

# ---- Data Preparation ----

# Convert date_local to Date format
ozone_f <- ozone %>%
  mutate(date_local = as.Date(date_local),
         day_of_week = wday(date_local, label = TRUE, abbr = FALSE),
         week_of_year = isoweek(date_local),
         year = year(date_local)) %>%
  filter(year == 1992) %>%
  full_join(state_data)
# full_join(expand.grid(date_local = seq.Date(from = as.Date("1991-01-01"), to = as.Date("1991-12-31"), by = "day"),
#              hour = 0:23), by = c("date_local", "hour"))

# Aggregate mean ozone levels per day
ozone_summary <- ozone_f %>%
  group_by(date_local, state_region) %>%
  summarise(mean_ozone = mean(arithmetic_mean, na.rm = TRUE))

# Prepare heatmap data
ozone_heatmap <- ozone_f %>%
  mutate(hour = as.numeric(x1st_max_hour))

# Define WHO Ozone Air Quality Guideline Thresholds (in ppm)
who_thresholds <- tibble(
  threshold = c(0.051, 0.061, 0.071),
  label = c("Moderate (51 ppb)", "Unhealthy for Sensitive Groups (61 ppb)", "Unhealthy (71 ppb)")
)

# Define key holidays
holidays <- tibble(
  date_local = as.Date(c("1991-07-04", "1991-12-01", "1992-07-04", "1992-12-01")),
  holiday = c("July 4", "Dec 1", "July 4", "Dec 1")
)

# ---- Panel 1: Heatmap ----

heatmap_plot <- ggplot(ozone_heatmap, aes(x = date_local, y = hour, fill = x1st_max_value)) +
  geom_tile() +
  scale_fill_viridis(option = "magma", name = "Ozone Level", direction = -1) +
  labs(
    title = "Hour of Worst (Max) Ozone Concentrations",
    x = "Date",
    y = "Hour of Day"
  ) +
  theme_minimal(base_family = "Helvetica") +
  theme(
    plot.title = element_text(size = 18, face = "bold", margin = margin(b = 10)),
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    legend.position = "right"
  )

# ---- Panel 2: Time Series with WHO Thresholds ----

time_series_plot <- ggplot(ozone_summary, aes(x = date_local, y = mean_ozone)) +
  #geom_line(color = "#0072B2", size = 1.2, alpha = 0.8) +
  geom_jitter(color = "#D55E00", size = 2, alpha = 0.4) +
  geom_hline(data = who_thresholds, aes(yintercept = threshold, linetype = label), color = "gray50") +
  geom_vline(data = holidays, aes(xintercept = as.numeric(date_local)), linetype = "dashed", color = "red", size = 0.8) +
  labs(
    title = "Daily Average Ozone Levels",
    x = "Date",
    y = "Ozone (ppm)"
  ) +
  theme_minimal(base_family = "Helvetica") +
  theme(
    plot.title = element_text(size = 18, face = "bold", margin = margin(b = 10)),
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 10),
    plot.caption = element_text(size = 10, face = "italic", hjust = 1),
    legend.position = "bottom"
  ) +
  facet_grid(.~ state_region)

# ---- Panel 3: Variability by Week & Day of the Week ----

variability_plot <- ggplot(ozone, aes(x = week_of_year, y = arithmetic_mean, group = week_of_year)) +
  geom_boxplot(fill = "#0072B2", alpha = 0.5) +
  facet_wrap(~ day_of_week, scales = "free_y") +
  labs(
    title = "Ozone Variability by Week & Day",
    x = "Week of Year",
    y = "Ozone (ppm)"
  ) +
  theme_minimal(base_family = "Helvetica") +
  theme(
    plot.title = element_text(size = 18, face = "bold", margin = margin(b = 10)),
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    strip.text = element_text(size = 12, face = "bold")
  )

# ---- Combine Plots Using Patchwork ----

final_plot <- (heatmap_plot / time_series_plot / variability_plot) +
  plot_annotation(
    title = "Ozone Levels Over Time",
    subtitle = "Hourly Concentrations, Daily Trends with WHO Guidelines, and Weekly Variability",
    caption = "Data Source: EPA AirData (https://aqs.epa.gov/aqsweb/airdata/download_files.html)",
    theme = theme(
      plot.title = element_text(size = 22, face = "bold", margin = margin(b = 12)),
      plot.subtitle = element_text(size = 16, margin = margin(b = 8)),
      plot.caption = element_text(size = 12, face = "italic", hjust = 1)
    )
  )

# Display final plot
print(final_plot)
