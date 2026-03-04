# Purpose: Translate Model Outputs into Business Impact

setwd("/Users/abhilashsingaru/Documents/r_project_2/logistics-otif-performance-analytics")

library(tidyverse)
library(readr)

# Load engineered KPI dataset
df <- read_csv("data/processed/shipping_kpis.csv", show_col_types = FALSE)

# Refit model to extract coefficients
model <- lm(delivery_time ~ traffic + weather + vehicle + area + agent_age + agent_rating,
            data = df)

coef_table <- broom::tidy(model)

print(coef_table)

# ---------------------------------------------------------
# 1) Impact of improving agent rating by 0.5 points
# ---------------------------------------------------------

rating_coef <- coef_table %>%
  filter(term == "agent_rating") %>%
  pull(estimate)

avg_orders <- nrow(df)

rating_improvement_minutes <- rating_coef * 0.5

total_time_saved_rating <- rating_improvement_minutes * avg_orders

cat("\nImpact of +0.5 increase in agent rating:\n")
cat("Minutes saved per order:", rating_improvement_minutes, "\n")
cat("Total minutes saved across all orders:", total_time_saved_rating, "\n")

# ---------------------------------------------------------
# 2) Impact of reducing Semi-Urban inefficiency
# ---------------------------------------------------------

semi_urban_coef <- coef_table %>%
  filter(term == "areaSemi-Urban") %>%
  pull(estimate)

semi_urban_orders <- df %>%
  filter(area == "Semi-Urban") %>%
  nrow()

semi_urban_time_burden <- semi_urban_coef * semi_urban_orders

cat("\nSemi-Urban structural delay impact:\n")
cat("Extra minutes per Semi-Urban order:", semi_urban_coef, "\n")
cat("Total Semi-Urban delay burden:", semi_urban_time_burden, "\n")

# ---------------------------------------------------------
# 3) Traffic Jam impact
# ---------------------------------------------------------

jam_coef <- coef_table %>%
  filter(term == "trafficJam") %>%
  pull(estimate)

jam_orders <- df %>%
  filter(traffic == "Jam") %>%
  nrow()

jam_total_burden <- jam_coef * jam_orders

cat("\nTraffic Jam impact:\n")
cat("Extra minutes per Jam order:", jam_coef, "\n")
cat("Total Jam delay burden:", jam_total_burden, "\n")

# ---------------------------------------------------------
# Executive Insight Summary
# ---------------------------------------------------------

cat("\nExecutive Summary:\n")
cat("1. Agent rating improvement creates measurable delivery time savings.\n")
cat("2. Semi-Urban routing is the largest structural inefficiency.\n")
cat("3. Traffic congestion contributes heavily to delay burden.\n")