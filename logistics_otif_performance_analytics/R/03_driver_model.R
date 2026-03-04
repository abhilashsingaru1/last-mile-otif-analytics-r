# Purpose: Identify Key Drivers of Delivery Time
# ============================================

setwd("/Users/abhilashsingaru/Documents/r_project_2/logistics-otif-performance-analytics")

library(tidyverse)
library(readr)

df <- read_csv("data/processed/shipping_kpis.csv", show_col_types = FALSE)

# Convert categorical variables to factors
df <- df %>%
  mutate(
    traffic = as.factor(traffic),
    weather = as.factor(weather),
    vehicle = as.factor(vehicle),
    area = as.factor(area),
    category = as.factor(category)
  )

# Linear model to quantify impact on delivery_time
model <- lm(delivery_time ~ traffic + weather + vehicle + area + agent_age + agent_rating,
            data = df)

summary(model)
