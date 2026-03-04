# ============================================
# File: R/02_otif_kpis.R
# Purpose: Create SLA, Delay Metrics, and Performance KPIs
# ============================================

setwd("/Users/abhilashsingaru/Documents/r_project_2/logistics-otif-performance-analytics")

library(tidyverse)
library(lubridate)
library(readr)

# Load cleaned dataset
df <- read_csv("data/processed/raw_cleaned.csv", show_col_types = FALSE)

# ----------------------------------------------------
# 1) Create SLA Rule
# Business Assumption:
# Standard delivery SLA = 120 minutes
# High traffic SLA = 150 minutes
# Stormy weather SLA = 180 minutes
# ----------------------------------------------------

df_kpi <- df %>%
  mutate(
    sla_minutes = case_when(
      traffic == "High" ~ 150,
      weather == "Stormy" ~ 180,
      TRUE ~ 120
    ),
    
    on_time = if_else(delivery_time <= sla_minutes, 1, 0),
    
    delay_minutes = if_else(delivery_time > sla_minutes,
                            delivery_time - sla_minutes,
                            0)
  )

# ----------------------------------------------------
# 2) Executive KPIs
# ----------------------------------------------------

exec_kpis <- df_kpi %>%
  summarise(
    total_orders = n(),
    avg_delivery_time = mean(delivery_time),
    on_time_rate = mean(on_time),
    avg_delay_minutes = mean(delay_minutes),
    late_orders = sum(on_time == 0)
  )

print(exec_kpis)

# ----------------------------------------------------
# 3) Performance by Traffic
# ----------------------------------------------------

traffic_perf <- df_kpi %>%
  group_by(traffic) %>%
  summarise(
    orders = n(),
    avg_delivery_time = mean(delivery_time),
    on_time_rate = mean(on_time)
  ) %>%
  arrange(on_time_rate)

print(traffic_perf)

# ----------------------------------------------------
# 4) Performance by Weather
# ----------------------------------------------------

weather_perf <- df_kpi %>%
  group_by(weather) %>%
  summarise(
    orders = n(),
    avg_delivery_time = mean(delivery_time),
    on_time_rate = mean(on_time)
  ) %>%
  arrange(on_time_rate)

print(weather_perf)

# ----------------------------------------------------
# 5) Performance by Vehicle Type
# ----------------------------------------------------

vehicle_perf <- df_kpi %>%
  group_by(vehicle) %>%
  summarise(
    orders = n(),
    avg_delivery_time = mean(delivery_time),
    on_time_rate = mean(on_time)
  ) %>%
  arrange(on_time_rate)

print(vehicle_perf)

# Save KPI dataset
write_csv(df_kpi, "data/processed/shipping_kpis.csv")