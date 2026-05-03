# =========================================================
# 05_diagnostics.R
# Purpose: Test the nine OLS assumptions listed in the paper.
#          Focus diagnostics on Model 3 (the full model).
# Run order: AFTER 04_regression.R
# =========================================================

source(here::here("scripts", "00_setup.R"))
models   <- readRDS(here::here("data_processed", "fitted_models.rds"))
analysis <- readRDS(here::here("data_processed", "analysis_2023.rds"))
m3 <- models[["Model 3: Full"]]

# ---- 1. Linearity: residuals vs fitted ----
png(here::here("figures", "diag1_resid_vs_fitted.png"),
    width = 6, height = 5, units = "in", res = 300)
plot(m3, which = 1)
dev.off()

# ---- 4. Homoskedasticity: Breusch-Pagan ----
bp <- lmtest::bptest(m3)
ncv <- car::ncvTest(m3)   # alternative

# ---- 5. Normality: Shapiro-Wilk + Q-Q ----
sw <- shapiro.test(residuals(m3))

png(here::here("figures", "diag2_qq.png"),
    width = 6, height = 5, units = "in", res = 300)
plot(m3, which = 2)
dev.off()

# ---- 7. Variation in X ----
x_var <- analysis |>
  select(psh_beds_pc, rrh_beds_pc, es_beds_pc) |>
  summarise(across(everything(), list(var = var, range = ~ diff(range(.x)))))

# ---- 8. Specification: Ramsey RESET ----
reset <- lmtest::resettest(m3, power = 2:3, type = "fitted")

# ---- 9. Multicollinearity: VIF ----
vif_vals <- car::vif(m3)

# ---- Influential observations (bonus) ----
png(here::here("figures", "diag3_cooks.png"),
    width = 6, height = 5, units = "in", res = 300)
plot(m3, which = 4)
dev.off()

# ---- Collect results into one table ----
diag_summary <- tibble::tribble(
  ~assumption,           ~test,              ~statistic,         ~p_value,
  "Homoskedasticity",    "Breusch-Pagan",    unname(bp$statistic),  bp$p.value,
  "Homoskedasticity",    "NCV (Cook-Weisb.)",ncv$ChiSquare,         ncv$p,
  "Normality",           "Shapiro-Wilk",     unname(sw$statistic),  sw$p.value,
  "Specification",       "Ramsey RESET",     unname(reset$statistic), reset$p.value
)
write_csv(diag_summary, here::here("output", "diagnostic_tests.csv"))

vif_df <- tibble::tibble(variable = names(vif_vals), VIF = vif_vals)
write_csv(vif_df, here::here("output", "vif.csv"))

# ---- If heteroskedasticity flagged, refit with robust SEs ----
robust_se <- lmtest::coeftest(m3, vcov = sandwich::vcovHC(m3, type = "HC3"))
capture.output(robust_se,
               file = here::here("output", "robust_se_m3.txt"))

cat("Diagnostics complete.\n")
cat("BP p =", round(bp$p.value, 4),
    "| Shapiro p =", round(sw$p.value, 4),
    "| RESET p =", round(reset$p.value, 4), "\n")
print(vif_df)
