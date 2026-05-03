# =========================================================
# 01_load_clean.R
# Purpose: Load 2023 HIC (.xlsx) and 2023 PIT (.xlsb),
#          clean headers, pull needed columns.
# Run order: AFTER 00_setup.R
# =========================================================

source(here::here("scripts", "00_setup.R"))

# ---- Paths to raw files ----
hic_path <- here::here("data_raw", "20072023HICCountsbyCoC.xlsx")
pit_path <- here::here("data_raw", "20072023PITCountsbyCoC.xlsb")

# ---------------------------------------------------------
# HIC 2023
# Note: Row 1 has merged category headers ("Emergency Shelter (ES)", etc.)
# Real column headers are on row 2. Skip the first row.
# ---------------------------------------------------------
hic_2023_raw <- read_excel(hic_path, sheet = "2023", skip = 1)

# Keep: CoC Number + total year-round beds for ES, RRH, PSH.
# Column names are duplicated across ES/TH/SH blocks, so select by position
# after verifying once with: names(hic_2023_raw)
hic_2023 <- hic_2023_raw |>
  select(
    coc_number     = `CoC Number`,
    es_beds        = `Total Year-Round Beds (ES)...14`,  # ES block
    rrh_beds       = `Total Year-Round Beds (RRH)`,
    psh_beds       = `Total Year-Round Beds (PSH)`
  ) |>
  mutate(across(c(es_beds, rrh_beds, psh_beds),
                ~ as.numeric(.x) |> replace_na(0)))

# If the suffixed name above ("...14") doesn't match in your file,
# inspect with: names(hic_2023_raw) and adjust. Position 5 in the skipped
# df is the first "Total Year-Round Beds (ES)".

# ---------------------------------------------------------
# PIT 2023
# readxlsb handles the .xlsb format. Headers on row 1.
# ---------------------------------------------------------
pit_2023_raw <- readxlsb::read_xlsb(pit_path, sheet = "2023")

pit_2023 <- pit_2023_raw |>
  select(
    coc_number   = `CoC Number`,
    coc_name     = `CoC Name`,
    coc_category = `CoC Category`,
    total_homeless = `Overall Homeless`
  ) |>
  mutate(total_homeless = as.numeric(total_homeless))

# ---------------------------------------------------------
# POPULATION (MISSING from both HUD files — see README)
# Option A: load a CoC population file you download separately:
#   pop <- read_csv(here::here("data_raw", "coc_population_2023.csv"))
# Option B (temporary): placeholder so the pipeline runs.
# Replace this before reporting any results.
# ---------------------------------------------------------
pop_path <- here::here("data_raw", "coc_population_2023.csv")
if (file.exists(pop_path)) {
  coc_pop <- read_csv(pop_path, show_col_types = FALSE) |>
    rename(coc_number = 1, population = 2)
} else {
  warning("No population file found. Using PLACEHOLDER (100,000 per CoC). ",
          "Replace with real data before running regressions.")
  coc_pop <- pit_2023 |>
    transmute(coc_number, population = 100000)
}

# ---- Save cleaned intermediate datasets ----
saveRDS(hic_2023, here::here("data_processed", "hic_2023.rds"))
saveRDS(pit_2023, here::here("data_processed", "pit_2023.rds"))
saveRDS(coc_pop,  here::here("data_processed", "coc_pop_2023.rds"))

cat("HIC rows:", nrow(hic_2023),
    "| PIT rows:", nrow(pit_2023),
    "| Pop rows:", nrow(coc_pop), "\n")
