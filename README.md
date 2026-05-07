# Does Housing Capacity Reduce Homelessness?
## Evidence from HUD Continuum of Care Data, 2023

A cross-sectional OLS exercise using HUD Point-in-Time and Housing Inventory Count data, completed for POL 682 Quantitative Methods II (Spring 2026), University of Arizona.

This repository contains all data, code, and outputs supporting Thompson, "Housing Capacity and Homelessness: A Cross-Sectional Exercise in OLS."

---

## Summary of Findings

This study estimates three nested OLS regression models examining whether the per capita capacity of three federally funded housing intervention types (Permanent Supportive Housing, Rapid Re-Housing, and Emergency Shelter) is associated with community-level rates of homelessness across 373 U.S. Continuums of Care (CoCs) in 2023.

**None of the three theoretical hypotheses are supported by the empirical results.** The PSH coefficient is positive in the bivariate model and statistically indistinguishable from zero in the full model. The RRH coefficient is positive and significant. The ES coefficient is large, positive, and dominates the model, despite the prediction that ES would have no significant effect.

The results are consistent with the reverse causality concern raised at the design stage: CoCs facing higher levels of homelessness receive more federal resources and consequently develop more beds. This study is best understood as a methods exercise rather than a contribution to homelessness scholarship. Its central value is in demonstrating how publicly available administrative data, applied through OLS without a credible identification strategy, cannot answer the substantive policy question motivating the project.

A panel specification with CoC fixed effects, drawn from the same publicly available data, would be a stronger next step.

---

## Research Question

Does the per capita availability of HUD-funded housing beds (PSH, RRH, ES) correspond to lower rates of homelessness across U.S. Continuums of Care?

---

## Theory

**Housing First** posits that stable housing is a prerequisite for addressing other challenges (mental health, substance use, employment) that contribute to chronic homelessness. Permanent Supportive Housing operationalizes this theory by combining long-term housing subsidies with wraparound services.

If Housing First is correct, communities with greater PSH capacity should have lower rates of homelessness because PSH removes people from homelessness permanently, targets the chronically homeless who cycle repeatedly through shelters, and frees emergency shelter capacity for newly homeless individuals.

---

## Hypotheses and Results

| Hypothesis | Prediction | Result | Supported? |
|---|---|---|---|
| H1 | PSH negatively associated with homelessness | Positive in Models 1 and 2; near-zero, not significant in Model 3 | No |
| H2 | ES has no significant association | Large, positive, highly significant | No |
| H3 | RRH negatively associated, weaker than PSH | Positive and significant in Models 2 and 3 | No |

The empirical tests do not match theoretical expectations. The discussion in the article argues that this mismatch is itself the substantive finding: it demonstrates the limits of cross-sectional inference when the independent variables are endogenous to the outcome.

---

## Glossary

| Acronym | Definition |
|---|---|
| CoC | Continuum of Care, the local planning body for HUD homeless services |
| HIC | Housing Inventory Count, annual inventory of beds dedicated to homeless services |
| PIT | Point-in-Time count, single-night count of sheltered and unsheltered homelessness |
| PSH | Permanent Supportive Housing, long-term subsidized housing with wraparound services |
| RRH | Rapid Re-Housing, short-to-medium-term rental assistance with light case management |
| ES | Emergency Shelter, temporary nightly accommodation |

---

## Data

**Unit of analysis:** Continuum of Care (CoC)
**Year:** 2023 (cross-sectional)
**Analytic sample:** 373 CoCs after listwise deletion of missing population values

| Dataset | Source |
|---|---|
| PIT Counts by CoC, 2007–2023 | [HUD USER AHAR 2023](https://www.huduser.gov/portal/datasets/ahar/2023-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html) |
| Housing Inventory Count by CoC, 2007–2023 | [HUD USER AHAR 2023](https://www.huduser.gov/portal/datasets/ahar/2023-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html) |
| CoC population crosswalk | [Byrne HUD-CoC-Geography-Crosswalk](https://github.com/tomhbyrne/HUD-CoC-Geography-Crosswalk) |

### Vintage limitation

The PIT and HIC files are 2023 vintage. The population crosswalk is built from 2017 HUD CoC boundaries and U.S. Census Bureau ACS 2011–2016 5-Year Estimates. The vintage mismatch is documented as a known limitation. For a publication-grade study, a current crosswalk constructed with `tidycensus` would be required. Because the population denominator appears in both the dependent variable and the per capita independent variables, the measurement error enters both sides of the regression rather than only one. The direction and magnitude of any resulting bias on the per capita coefficients is not formally evaluated.

### Data download instructions

1. Go to: <https://www.huduser.gov/portal/datasets/ahar/2023-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html>
2. Download:
   - `2007-2023-PIT-Counts-by-CoC.xlsb`
   - `2007-2023-HIC-Counts-by-CoC.xlsx`
3. Convert the PIT file from `.xlsb` to `.xlsx` (R does not natively read `.xlsb`)
4. Download the population crosswalk from <https://github.com/tomhbyrne/HUD-CoC-Geography-Crosswalk>
5. Place all three files in the `data/raw/` folder

---

## Variables

### Dependent variable (continuous)

| Variable | Description | Calculation |
|---|---|---|
| `homeless_rate` | Homelessness rate per 10,000 population | (Total PIT count ÷ CoC population) × 10,000 |

### Independent variables (continuous)

| Variable | Description | Expected sign |
|---|---|---|
| `psh_beds_pc` | PSH beds per 10,000 population | Negative |
| `rrh_beds_pc` | RRH beds per 10,000 population | Negative, weaker than PSH |
| `es_beds_pc` | ES beds per 10,000 population | Null |

---

## Models

Three nested OLS specifications:

```
Model 1: homeless_rate = β₀ + β₁·psh_beds_pc + ε
Model 2: homeless_rate = β₀ + β₁·psh_beds_pc + β₂·rrh_beds_pc + ε
Model 3: homeless_rate = β₀ + β₁·psh_beds_pc + β₂·rrh_beds_pc + β₃·es_beds_pc + ε
```

The nested structure allows the PSH coefficient to be tracked across specifications, revealing how omitted housing intervention types affect the estimate.

---

## Diagnostic Tests

| Assumption | Test | Result |
|---|---|---|
| Linearity | Residuals vs. fitted plot | Mostly flat in dense region; curvature at extremes driven by outliers |
| Homoskedasticity | Breusch-Pagan, NCV (Cook-Weisberg) | Rejected (p < 0.001 for both) |
| Normality of residuals | Shapiro-Wilk | Rejected (W = 0.77, p < 0.001) |
| Multicollinearity | VIF | Pass (PSH = 3.00, RRH = 2.53, ES = 1.39) |
| Exogeneity | (not testable in cross-section) | Almost certainly violated; central limitation |
| Specification | (not formally tested) | Acknowledged as misspecified due to omitted confounders |

Heteroskedasticity-consistent (HC3) standard errors are computed for Model 3 as a robustness check. The substantive conclusions on PSH and ES hold under HC3. RRH loses significance under HC3, suggesting its conventional standard error was understated by the heteroskedastic residuals.

---

## Repository Structure

```
.
├── data/
│   ├── raw/                        # Original HUD and Byrne files (excluded from git)
│   └── processed/                  # Cleaned, merged analytic file
├── R/
│   ├── 00_setup.R                  # Load packages, set paths
│   ├── 01_read_raw.R               # Read HIC and PIT (after .xlsb conversion)
│   ├── 02_merge_and_construct.R    # Join population crosswalk; build rate variables
│   ├── 03_descriptives.R           # Summary stats, histograms, correlation matrix
│   ├── 04_regressions.R            # Three nested OLS models; modelsummary table
│   ├── 05_diagnostics.R            # Breusch-Pagan, NCV, Shapiro-Wilk, VIF, HC3
│   ├── 06_graphics.R               # Coefficient plot, marginal effects, scatter panels
│   └── run_all.R                   # Pipeline executor
├── output/
│   ├── tables/                     # CSV regression coefficients, fit stats, diagnostics
│   ├── figures/                    # PNG diagnostic plots and presentation graphics
│   └── article/                    # Final manuscript (Word and Markdown)
└── README.md
```

---

## How to Reproduce

1. Clone this repository
2. Download raw data per the instructions above
3. Open the `.Rproj` file in RStudio
4. Run `R/run_all.R`

All analyses were conducted in R 4.5.2 on macOS. Required packages are listed in `R/00_setup.R`. A full session info dump is saved in `output/session_info.txt`.

---

## Key Limitations

This study is a methods exercise, not a substantive contribution to homelessness scholarship.

1. **Cross-sectional design.** Cannot separate the effect of housing capacity on homelessness from the effect of homelessness on funding allocations. The HIC and PIT files used here actually contain 17 years of annual data (2007–2023). Restricting the analysis to 2023 was a methodological choice driven by the assignment, not a feature of the data.

2. **Reverse causality.** CoCs with higher homelessness receive larger federal awards and develop more beds. The within-year correlation between bed capacity and homelessness reflects the funding response more than any treatment effect. A directed acyclic graph (Figure 6 in the article) visualizes this loop.

3. **Omitted confounders.** Median rent, poverty, climate, and behavioral health system capacity are all known correlates of homelessness and are not included.

4. **Population vintage mismatch.** PIT and HIC are 2023; population denominators are 2011–2016. Documented but not corrected.

5. **No spatial dependence test.** CoCs are administratively distinct units, but spatial dependence between neighboring CoCs is plausible and not tested.

A panel specification with CoC and year fixed effects, using the full 2007–2023 data, would be a substantially stronger next step. A still stronger design would identify a plausibly exogenous source of variation in bed capacity (such as a federal funding rule change or a state policy shift) and use it as an instrument.

---

## Citation

Thompson, Laura J. 2026. *Housing Capacity and Homelessness: A Cross-Sectional Exercise in OLS*. POL 682 Quantitative Methods II, University of Arizona.

---

## AI Disclosure

R scripts in this repository were developed with assistance from Claude Opus 4.7 (Anthropic 2026). The author specified the analytical approach and tests to be run, reviewed all code, verified all outputs, and is responsible for all interpretations and conclusions. AI usage in this project follows the disclosure policy in the course repository (Weber 2026).

---

## Acknowledgments

This project draws on the HUD-CoC geography crosswalk maintained by Thomas H. Byrne, the open-source `tidyverse`, `modelsummary`, `car`, `lmtest`, and `sandwich` packages, and course materials provided by Christopher R. Weber for POL 682 at the University of Arizona.
