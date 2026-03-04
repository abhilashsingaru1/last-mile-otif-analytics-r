# ============================================
# File: R/01_data_loading.R
# Project: Logistics OTIF Performance Analytics
# Purpose: Set project working directory, load raw dataset, and inspect structure
# Dataset file: data/raw/amazon_delivery.csv
# ============================================

# 1) Force project root so relative paths work
project_root <- "/Users/abhilashsingaru/Documents/r_project_2/logistics-otif-performance-analytics"
setwd(project_root)

# 2) Load libraries
library(tidyverse)
library(lubridate)
library(janitor)
library(skimr)
library(readr)

# 3) Confirm working directory
cat("Project root:\n")
cat(getwd(), "\n\n")

# 4) List files available in data/raw
cat("Files in data/raw:\n")
raw_files <- list.files("data/raw")
print(raw_files)
cat("\n")

# 5) Define dataset path
file_name <- "amazon_delivery.csv"
data_path <- file.path("data", "raw", file_name)

cat("Reading dataset from:\n")
cat(normalizePath(data_path, winslash = "/", mustWork = FALSE), "\n\n")

# 6) Stop early if the file is missing
if (!file.exists(data_path)) {
  stop(
    paste0(
      "Dataset not found.\n",
      "Expected: ", data_path, "\n",
      "But data/raw contains: ", paste(raw_files, collapse = ", "), "\n",
      "Fix: move/rename the CSV into data/raw and match file_name."
    )
  )
}

# 7) Read dataset and standardize column names
df_raw <- readr::read_csv(data_path, show_col_types = FALSE) %>%
  janitor::clean_names()

# 8) Basic inspection
cat("Dataset loaded successfully\n")
cat("Rows: ", nrow(df_raw), "\n")
cat("Columns: ", ncol(df_raw), "\n\n")

cat("Column names:\n")
print(names(df_raw))
cat("\n")

cat("First 10 rows:\n")
print(head(df_raw, 10))
cat("\n")

cat("Skim summary:\n")
print(skimr::skim(df_raw))
cat("\n")

# 9) Save a standardized copy into data/processed
processed_path <- file.path("data", "processed", "raw_cleaned.csv")
readr::write_csv(df_raw, processed_path)

cat("Saved standardized copy to:\n")
cat(normalizePath(processed_path, winslash = "/", mustWork = FALSE), "\n")