# ============================================
# File: R/06_exports.R
# Purpose: Export key tables and summaries for reporting and README
# Inputs:
#   - data/processed/shipping_kpis.csv
# Outputs:
#   - data/processed/model_coefficients.csv
#   - data/processed/model_fit_summary.csv
#   - data/processed/impact_summary.csv
#   - data/processed/segment_performance.csv
# ============================================

setwd("/Users/abhilashsingaru/Documents/r_project_2/logistics-otif-performance-analytics")

library(tidyverse)
library(readr)
library(broom)

if (!dir.exists("data/processed")) {
  dir.create("data/processed", recursive = TRUE)
}

df <- read_csv("data/processed/shipping_kpis.csv", show_col_types = FALSE)

# Fit model
model <- lm(
  delivery_time ~ traffic + weather + vehicle + area + agent_age + agent_rating,
  data = df
)

# 1) Export model coefficients
coef_table <- broom::tidy(model) %>%
  arrange(desc(abs(estimate)))

write_csv(coef_table, "data/processed/model_coefficients.csv")

# 2) Export model fit summary
fit_summary <- broom::glance(model) %>%
  select(r.squared, adj.r.squared, sigma, statistic, p.value, df, nobs)

write_csv(fit_summary, "data/processed/model_fit_summary.csv")

# 3) Export business impact summary (same assumptions as File 04)
rating_coef <- coef_table %>% filter(term == "agent_rating") %>% pull(estimate)
semi_urban_coef <- coef_table %>% filter(term == "areaSemi-Urban") %>% pull(estimate)
jam_coef <- coef_table %>% filter(term == "trafficJam") %>% pull(estimate)

n_orders <- nrow(df)

semi_urban_orders <- df %>% filter(area == "Semi-Urban") %>% nrow()
jam_orders <- df %>% filter(traffic == "Jam") %>% nrow()

rating_improvement_points <- 0.5
minutes_saved_per_order_from_rating <- rating_coef * rating_improvement_points
total_minutes_saved_from_rating <- minutes_saved_per_order_from_rating * n_orders

impact_summary <- tibble(
  metric = c(
    "orders_total",
    "rating_coef_minutes_per_point",
    "rating_improvement_assumed_points",
    "minutes_saved_per_order_from_rating",
    "total_minutes_saved_from_rating",
    "semi_urban_coef_extra_minutes_per_order",
    "semi_urban_orders",
    "semi_urban_total_minutes_burden",
    "jam_coef_extra_minutes_per_order",
    "jam_orders",
    "jam_total_minutes_burden"
  ),
  value = c(
    n_orders,
    rating_coef,
    rating_improvement_points,
    minutes_saved_per_order_from_rating,
    total_minutes_saved_from_rating,
    semi_urban_coef,
    semi_urban_orders,
    semi_urban_coef * semi_urban_orders,
    jam_coef,
    jam_orders,
    jam_coef * jam_orders
  )
)

write_csv(impact_summary, "data/processed/impact_summary.csv")

# 4) Segment performance export
segment_performance <- bind_rows(
  df %>%
    group_by(segment = "traffic", segment_value = traffic) %>%
    summarise(
      orders = n(),
      on_time_rate = mean(on_time, na.rm = TRUE),
      avg_delivery_time = mean(delivery_time, na.rm = TRUE),
      avg_delay_minutes = mean(delay_minutes, na.rm = TRUE),
      .groups = "drop"
    ),
  df %>%
    group_by(segment = "weather", segment_value = weather) %>%
    summarise(
      orders = n(),
      on_time_rate = mean(on_time, na.rm = TRUE),
      avg_delivery_time = mean(delivery_time, na.rm = TRUE),
      avg_delay_minutes = mean(delay_minutes, na.rm = TRUE),
      .groups = "drop"
    ),
  df %>%
    group_by(segment = "vehicle", segment_value = vehicle) %>%
    summarise(
      orders = n(),
      on_time_rate = mean(on_time, na.rm = TRUE),
      avg_delivery_time = mean(delivery_time, na.rm = TRUE),
      avg_delay_minutes = mean(delay_minutes, na.rm = TRUE),
      .groups = "drop"
    ),
  df %>%
    group_by(segment = "area", segment_value = area) %>%
    summarise(
      orders = n(),
      on_time_rate = mean(on_time, na.rm = TRUE),
      avg_delivery_time = mean(delivery_time, na.rm = TRUE),
      avg_delay_minutes = mean(delay_minutes, na.rm = TRUE),
      .groups = "drop"
    )
) %>%
  arrange(segment, on_time_rate)

write_csv(segment_performance, "data/processed/segment_performance.csv")

cat("Exports created in data/processed:\n")
cat("- model_coefficients.csv\n")
cat("- model_fit_summary.csv\n")
cat("- impact_summary.csv\n")
cat("- segment_performance.csv\n")