# Logistics OTIF Performance Analytics (R)

run
install.packages("renv")
renv::restore()

## Overview
This project analyzes last-mile delivery performance using an Amazon delivery dataset from Kaggle.  
It measures SLA (On-Time) compliance, identifies key drivers of delivery time, and translates model results into operational impact.

## Business Problem
Last-mile logistics teams face service failures due to congestion, area-level constraints, vehicle allocation, and agent performance differences.
This project provides a structured analytics workflow to quantify performance and prioritize improvement levers.

## Key Outputs
- SLA KPIs (on-time rate, late orders, average delivery time, delay minutes)
- Segment performance breakdown (traffic, weather, vehicle, area)
- Regression driver model to quantify delivery time impacts
- Business impact simulation (time savings and delay burden)
- Exported charts and final HTML report

## Project Structure
- `data/raw/` Raw dataset (not committed to GitHub)
- `data/processed/` Cleaned datasets and exported summary tables
- `R/` Analysis scripts (end-to-end pipeline)
- `outputs/figures/` Exported visualizations (PNG)
- `reports/` Final report (HTML)

## How to Run (Order Matters)
1. Open the project in RStudio
2. Run scripts in order:
   - `R/01_data_loading.R`
   - `R/02_otif_kpis.R`
   - `R/03_driver_model.R`
   - `R/04_business_impact_summary.R`
   - `R/05_visualizations.R`
   - `R/06_exports.R`
3. Render the report:
   - `rmarkdown::render("reports/final_report.Rmd")`

## Key Files Generated
- `data/processed/raw_cleaned.csv`
- `data/processed/shipping_kpis.csv`
- `data/processed/model_coefficients.csv`
- `data/processed/model_fit_summary.csv`
- `data/processed/impact_summary.csv`
- `data/processed/segment_performance.csv`
- `outputs/figures/*.png`
- `reports/final_report.html`

## Notes on SLA Definition
The dataset does not include a promised delivery date/time.
To measure service performance, SLA is defined using business rules (traffic/weather-adjusted thresholds).
This mirrors real operations where SLA is often policy-based.

## Skills Demonstrated
- Data cleaning and feature engineering in R
- KPI design for logistics service performance
- Regression modeling and driver quantification
- Business impact translation (minutes saved, delay burden)
- Exporting outputs for reporting and stakeholder communication