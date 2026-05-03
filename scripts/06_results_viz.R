# =========================================================
# 06_results_viz.R
# Purpose: Publication-quality results graphics:
#          coefficient plot, marginal-effects plot, map-ready CSV.
# Run order: AFTER 04_regression.R
# =========================================================

source(here::here("scripts", "00_setup.R"))
models   <- readRDS(here::here("data_processed", "fitted_models.rds"))
analysis <- readRDS(here::here("data_processed", "analysis_2023.rds"))

# ---- Coefficient plot across the three models ----
coef_df <- map_dfr(models, broom::tidy, conf.int = TRUE, .id = "model") |>
  filter(term != "(Intercept)")

p_coef <- ggplot(coef_df,
                 aes(x = estimate, y = term, color = model)) +
  geom_vline(xintercept = 0, linetype = 2, color = "gray40") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high),
                  position = position_dodge(width = 0.5)) +
  labs(title = "OLS coefficients with 95% CIs",
       subtitle = "Outcome: Homeless per 10,000 population (2023)",
       x = "Estimate", y = NULL, color = NULL) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "top")
ggsave(here::here("figures", "fig4_coef_plot.png"),
       p_coef, width = 8, height = 5, dpi = 300)

# ---- Marginal effect of PSH from Model 3 ----
m3 <- models[["Model 3: Full"]]
pred_grid <- tibble(
  psh_beds_pc = seq(min(analysis$psh_beds_pc, na.rm = TRUE),
                    quantile(analysis$psh_beds_pc, 0.99, na.rm = TRUE),
                    length.out = 100),
  rrh_beds_pc = mean(analysis$rrh_beds_pc, na.rm = TRUE),
  es_beds_pc  = mean(analysis$es_beds_pc,  na.rm = TRUE)
)
pred <- predict(m3, newdata = pred_grid, interval = "confidence") |>
  as_tibble() |>
  bind_cols(pred_grid)

p_marg <- ggplot(pred, aes(psh_beds_pc, fit)) +
  geom_ribbon(aes(ymin = lwr, ymax = upr), fill = "steelblue", alpha = .2) +
  geom_line(color = "steelblue", linewidth = 1) +
  geom_point(data = analysis,
             aes(psh_beds_pc, homeless_rate),
             inherit.aes = FALSE,
             alpha = 0.25, size = 1) +
  labs(title = "Predicted homelessness rate by PSH capacity (Model 3)",
       subtitle = "RRH and ES held at their means",
       x = "PSH beds per 10,000 population",
       y = "Predicted homeless per 10,000") +
  theme_minimal(base_size = 11)
ggsave(here::here("figures", "fig5_marginal_psh.png"),
       p_marg, width = 8, height = 5, dpi = 300)

# ---- Top / bottom 10 CoCs by homeless rate (table) ----
top_bottom <- bind_rows(
  analysis |> arrange(desc(homeless_rate)) |> slice_head(n = 10) |>
    mutate(group = "Highest rate"),
  analysis |> arrange(homeless_rate) |> slice_head(n = 10) |>
    mutate(group = "Lowest rate")
) |>
  select(group, coc_number, coc_name,
         homeless_rate, psh_beds_pc, rrh_beds_pc, es_beds_pc)
write_csv(top_bottom, here::here("output", "top_bottom_cocs.csv"))

cat("Results visualizations saved to /figures.\n")
