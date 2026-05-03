# =========================================================
# run_all.R
# Purpose: Reproduce the entire analysis end-to-end.
# Usage:   Open the .Rproj, then: source("scripts/run_all.R")
# =========================================================

scripts <- c(
  "scripts/00_setup.R",
  "scripts/01_load_clean.R",
  "scripts/02_merge.R",
  "scripts/03_eda.R",
  "scripts/04_regression.R",
  "scripts/05_diagnostics.R",
  "scripts/06_results_viz.R"
)
for (s in scripts) {
  cat("\n--- Running", s, "---\n")
  source(here::here(s))
}
cat("\nAll scripts complete.\n")
