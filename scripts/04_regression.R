# =========================================================
# 04_regression.R
# Purpose: Estimate the three nested OLS models specified
#          in the paper. Export tidy and formatted tables.
# Run order: AFTER 02_merge.R
# =========================================================

source(here::here("scripts", "00_setup.R"))
analysis <- readRDS(here::here("data_processed", "analysis_2023.rds"))

# ---- Model 1: PSH only ----
m1 <- lm(homeless_rate ~ psh_beds_pc, data = analysis)

# ---- Model 2: PSH + RRH ----
m2 <- lm(homeless_rate ~ psh_beds_pc + rrh_beds_pc, data = analysis)

# ---- Model 3: Full ----
m3 <- lm(homeless_rate ~ psh_beds_pc + rrh_beds_pc + es_beds_pc,
         data = analysis)

models <- list("Model 1: PSH only" = m1,
               "Model 2: PSH + RRH" = m2,
               "Model 3: Full"     = m3)

# ---- Tidy coefficients ----
coef_tbl <- map_dfr(models, broom::tidy, .id = "model")
write_csv(coef_tbl, here::here("output", "regression_coefficients.csv"))

glance_tbl <- map_dfr(models, broom::glance, .id = "model")
write_csv(glance_tbl, here::here("output", "regression_fit_stats.csv"))

# ---- Publication-style table (HTML + text) ----
modelsummary::modelsummary(
  models,
  stars = TRUE,
  gof_omit = "IC|Log|Adj|F|RMSE",
  output = here::here("output", "regression_table.html")
)
modelsummary::modelsummary(
  models, stars = TRUE,
  output = here::here("output", "regression_table.txt")
)

# ---- Save fitted models for diagnostics script ----
saveRDS(models, here::here("data_processed", "fitted_models.rds"))

cat("Regression complete. Tables in /output.\n")
print(summary(m3))
