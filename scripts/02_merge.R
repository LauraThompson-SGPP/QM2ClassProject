# =========================================================
# 02_merge.R
# Purpose: Merge HIC + PIT + population into one CoC-level
#          analysis dataset. Compute per-capita variables.
# Run order: AFTER 01_load_clean.R
# =========================================================

source(here::here("scripts", "00_setup.R"))

hic_2023 <- readRDS(here::here("data_processed", "hic_2023.rds"))
pit_2023 <- readRDS(here::here("data_processed", "pit_2023.rds"))
coc_pop  <- readRDS(here::here("data_processed", "coc_pop_2023.rds"))

analysis <- pit_2023 |>
  inner_join(hic_2023, by = "coc_number") |>
  inner_join(coc_pop,  by = "coc_number") |>
  filter(population > 0, !is.na(total_homeless)) |>
  mutate(
    # Rates per 10,000 population
    homeless_rate = (total_homeless / population) * 10000,
    psh_beds_pc   = (psh_beds      / population) * 10000,
    rrh_beds_pc   = (rrh_beds      / population) * 10000,
    es_beds_pc    = (es_beds       / population) * 10000
  )

# Sanity checks
stopifnot(nrow(analysis) > 300)   # expect ~380 CoCs
stopifnot(all(analysis$homeless_rate >= 0))

saveRDS(analysis, here::here("data_processed", "analysis_2023.rds"))
write_csv(analysis, here::here("data_processed", "analysis_2023.csv"))

cat("Final analysis n =", nrow(analysis), "CoCs\n")
print(summary(analysis |>
                select(homeless_rate, psh_beds_pc, rrh_beds_pc, es_beds_pc)))
