# =========================================================
# 03_eda.R
# Purpose: Descriptive statistics, distributions, scatter plots,
#          correlation matrix. Saves figures to /figures.
# Run order: AFTER 02_merge.R
# =========================================================

source(here::here("scripts", "00_setup.R"))
analysis <- readRDS(here::here("data_processed", "analysis_2023.rds"))

# ---- Descriptive table ----
desc_tbl <- analysis |>
  select(homeless_rate, psh_beds_pc, rrh_beds_pc, es_beds_pc) |>
  pivot_longer(everything(), names_to = "var", values_to = "val") |>
  group_by(var) |>
  summarise(
    n    = sum(!is.na(val)),
    mean = mean(val, na.rm = TRUE),
    sd   = sd(val,   na.rm = TRUE),
    min  = min(val,  na.rm = TRUE),
    p25  = quantile(val, .25, na.rm = TRUE),
    median = median(val, na.rm = TRUE),
    p75  = quantile(val, .75, na.rm = TRUE),
    max  = max(val,  na.rm = TRUE)
  )
write_csv(desc_tbl, here::here("output", "descriptive_stats.csv"))

# ---- Histograms of each variable ----
hist_df <- analysis |>
  select(homeless_rate, psh_beds_pc, rrh_beds_pc, es_beds_pc) |>
  pivot_longer(everything(), names_to = "var", values_to = "val")

p_hist <- ggplot(hist_df, aes(val)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  facet_wrap(~var, scales = "free") +
  labs(title = "Distribution of key variables (per 10,000 population)",
       x = NULL, y = "Count") +
  theme_minimal(base_size = 11)
ggsave(here::here("figures", "fig1_histograms.png"),
       p_hist, width = 8, height = 6, dpi = 300)

# ---- Scatter plots: each IV vs DV ----
scatter_df <- analysis |>
  select(homeless_rate, psh_beds_pc, rrh_beds_pc, es_beds_pc) |>
  pivot_longer(-homeless_rate, names_to = "bed_type", values_to = "bed_pc")

p_scatter <- ggplot(scatter_df, aes(bed_pc, homeless_rate)) +
  geom_point(alpha = 0.4, color = "steelblue") +
  geom_smooth(method = "lm", se = TRUE, color = "darkred") +
  facet_wrap(~bed_type, scales = "free_x") +
  labs(title = "Homelessness rate vs. bed capacity, per 10,000 pop",
       x = "Beds per 10,000 population",
       y = "Homeless per 10,000 population") +
  theme_minimal(base_size = 11)
ggsave(here::here("figures", "fig2_scatter.png"),
       p_scatter, width = 9, height = 6, dpi = 300)

# ---- Correlation matrix ----
cor_mat <- analysis |>
  select(homeless_rate, psh_beds_pc, rrh_beds_pc, es_beds_pc) |>
  cor(use = "pairwise.complete.obs")
png(here::here("figures", "fig3_corrplot.png"),
    width = 6, height = 5, units = "in", res = 300)
corrplot::corrplot(cor_mat, method = "color",
                   addCoef.col = "black", type = "upper",
                   tl.col = "black")
dev.off()
write_csv(as.data.frame(cor_mat) |> rownames_to_column("var"),
          here::here("output", "correlation_matrix.csv"))

cat("EDA complete. See /figures and /output.\n")
