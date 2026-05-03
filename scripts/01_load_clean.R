# =========================================================
# 01_load_clean.R
# Purpose: Load 2023 HIC and 2023 PIT (both .xlsx),
#          clean headers, pull needed columns.
# Run order: AFTER 00_setup.R
# =========================================================

source(here::here("scripts", "00_setup.R"))

# ---- Paths to raw files ----
hic_path <- here::here("data_raw", "20072023HICCountsbyCoC.xlsx")
pit_path <- here::here("data_raw", "20072023PITCountsbyCoC.xlsx")

# ---------------------------------------------------------
# HIC 2023
# Row 1 has merged category headers ("Emergency Shelter (ES)", etc.).
# Real column headers are on row 2 — skip the first row.
# Several column names repeat across program-type blocks (e.g.
# "Total Year-Round Beds (ES)" appears in both the summary and the
# ES-detail block), so we select by column POSITION, not name.
# ---------------------------------------------------------
hic_2023_raw <- read_excel(hic_path, sheet = "2023", skip = 1,
                           .name_repair = "minimal")

hic_2023 <- hic_2023_raw |>
  select(
    coc_number = 1,    # "CoC Number"
    es_beds    = 6,    # "Total Year-Round Beds (ES)"
    rrh_beds   = 47,   # "Total Year-Round Beds (RRH)"
    psh_beds   = 57    # "Total Year-Round Beds (PSH)"
  ) |>
  mutate(across(c(es_beds, rrh_beds, psh_beds),
                ~ as.numeric(.x) |> replace_na(0)))

# ---------------------------------------------------------
# PIT 2023 (.xlsx after offline conversion from .xlsb)
# ---------------------------------------------------------
pit_2023_raw <- read_excel(pit_path, sheet = "2023")

pit_2023 <- pit_2023_raw |>
  select(
    coc_number     = `CoC Number`,
    coc_name       = `CoC Name`,
    coc_category   = `CoC Category`,
    total_homeless = `Overall Homeless`
  ) |>
  mutate(total_homeless = as.numeric(total_homeless))

# ---------------------------------------------------------
# POPULATION (Byrne HUD-CoC crosswalk; 2011-2016 ACS @ 2017 CoC bounds)
# Expected columns: coc_number, population
# ---------------------------------------------------------
pop_path <- here::here("data_raw", "coc_population_2023.csv")
if (file.exists(pop_path)) {
  coc_pop <- read_csv(pop_path, show_col_types = FALSE) |>
    select(coc_number = 1, population = 2) |>
    mutate(population = as.numeric(population))
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
