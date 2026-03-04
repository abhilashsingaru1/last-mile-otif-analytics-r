# ============================================
# File: R/05_visualizations.R
# Purpose: Create and export business-ready visualizations
# Inputs:
#   - data/processed/shipping_kpis.csv
# Outputs:
#   - outputs/figures/*.png
# Notes:
#   - This final version does not parse order_time or pickup_time because
#     the dataset contains malformed time strings that can break strict parsers.
#   - Monthly trends are computed using order_date only, which is sufficient.
# ============================================

setwd("/Users/abhilashsingaru/Documents/r_project_2/logistics-otif-performance-analytics")

library(tidyverse)
library(lubridate)
library(readr)

# Create output folder if it does not exist
if (!dir.exists("outputs/figures")) {
  dir.create("outputs/figures", recursive = TRUE)
}

# Load KPI dataset
df <- read_csv("data/processed/shipping_kpis.csv", show_col_types = FALSE)

# Ensure dates are properly typed
df <- df %>%
  mutate(
    order_date = as.Date(order_date),
    order_month = floor_date(order_date, unit = "month")
  )

# 1) On-time rate by traffic
p_traffic <- df %>%
  group_by(traffic) %>%
  summarise(
    orders = n(),
    on_time_rate = mean(on_time, na.rm = TRUE),
    avg_delivery_time = mean(delivery_time, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = reorder(traffic, on_time_rate), y = on_time_rate)) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "On-Time Rate by Traffic Level",
    x = "Traffic",
    y = "On-Time Rate"
  )

ggsave(
  filename = "outputs/figures/on_time_by_traffic.png",
  plot = p_traffic,
  width = 10,
  height = 6
)

# 2) On-time rate by weather
p_weather <- df %>%
  group_by(weather) %>%
  summarise(
    orders = n(),
    on_time_rate = mean(on_time, na.rm = TRUE),
    avg_delivery_time = mean(delivery_time, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = reorder(weather, on_time_rate), y = on_time_rate)) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "On-Time Rate by Weather",
    x = "Weather",
    y = "On-Time Rate"
  )

ggsave(
  filename = "outputs/figures/on_time_by_weather.png",
  plot = p_weather,
  width = 10,
  height = 6
)

# 3) On-time rate by area
p_area <- df %>%
  group_by(area) %>%
  summarise(
    orders = n(),
    on_time_rate = mean(on_time, na.rm = TRUE),
    avg_delivery_time = mean(delivery_time, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = reorder(area, on_time_rate), y = on_time_rate)) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "On-Time Rate by Area",
    x = "Area",
    y = "On-Time Rate"
  )

ggsave(
  filename = "outputs/figures/on_time_by_area.png",
  plot = p_area,
  width = 10,
  height = 6
)

# 4) On-time rate by vehicle
p_vehicle <- df %>%
  group_by(vehicle) %>%
  summarise(
    orders = n(),
    on_time_rate = mean(on_time, na.rm = TRUE),
    avg_delivery_time = mean(delivery_time, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = reorder(vehicle, on_time_rate), y = on_time_rate)) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "On-Time Rate by Vehicle Type",
    x = "Vehicle",
    y = "On-Time Rate"
  )

ggsave(
  filename = "outputs/figures/on_time_by_vehicle.png",
  plot = p_vehicle,
  width = 10,
  height = 6
)

# 5) Delivery time distribution
p_dist <- df %>%
  filter(!is.na(delivery_time)) %>%
  ggplot(aes(x = delivery_time)) +
  geom_histogram(bins = 40) +
  labs(
    title = "Distribution of Delivery Time (minutes)",
    x = "Delivery Time (minutes)",
    y = "Orders"
  )

ggsave(
  filename = "outputs/figures/delivery_time_distribution.png",
  plot = p_dist,
  width = 10,
  height = 6
)

# 6) Trend: On-time rate over months
# If order_date is missing for many rows, this plot may be sparse. That is expected.
p_trend <- df %>%
  filter(!is.na(order_month)) %>%
  group_by(order_month) %>%
  summarise(
    orders = n(),
    on_time_rate = mean(on_time, na.rm = TRUE),
    avg_delivery_time = mean(delivery_time, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = order_month, y = on_time_rate)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "On-Time Rate Trend Over Time",
    x = "Month",
    y = "On-Time Rate"
  )

ggsave(
  filename = "outputs/figures/on_time_trend.png",
  plot = p_trend,
  width = 10,
  height = 5
)

cat("Visualizations saved to outputs/figures/\n")