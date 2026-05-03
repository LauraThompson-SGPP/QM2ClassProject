# =========================================================
# 00_setup.R
# Purpose: Install/load packages, set paths, define helpers
# Run order: FIRST
# =========================================================

# ---- Packages ----
pkgs <- c(
  "tidyverse",   # dplyr, ggplot2, tidyr, readr, stringr
  "readxl",      # .xlsx
  "readxlsb",    # .xlsb (HUD PIT file)
  "janitor",     # clean_names()
  "here",        # project-relative paths
  "car",         # vif(), ncvTest()
  "lmtest",      # bptest(), resettest()
  "sandwich",    # robust SEs
  "broom",       # tidy model output
  "modelsummary",# regression tables
  "corrplot",    # correlation heatmap
  "ggthemes"     # clean plot themes
)
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install)
invisible(lapply(pkgs, library, character.only = TRUE))

# ---- Paths (relative to project root via here::here()) ----
# Expected folder structure:
# project_root/
#   scripts/      <- R scripts (this file lives here)
#   data_raw/     <- original HUD files (NEVER edit)
#   data_processed/
#   output/       <- tables
#   figures/      <- plots
dir.create(here::here("data_processed"), showWarnings = FALSE)
dir.create(here::here("output"),         showWarnings = FALSE)
dir.create(here::here("figures"),        showWarnings = FALSE)

# ---- Session info for reproducibility ----
writeLines(capture.output(sessionInfo()),
           here::here("output", "session_info.txt"))

cat("Setup complete.\n")
