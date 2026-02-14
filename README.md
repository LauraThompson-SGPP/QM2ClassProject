# QM2ClassProject
# Does Housing Capacity Reduce Homelessness? Evidence from HUD Continuum of Care Data

## Research Question

**Does the availability of Permanent Supportive Housing (PSH) beds reduce community homelessness rates?**

## Theory

**Housing First Theory** posits that stable housing is a prerequisite for addressing other challenges (mental health, substance use, employment) that contribute to chronic homelessness. Permanent Supportive Housing (PSH) operationalizes this theory by combining long-term housing subsidies with wraparound services.

If Housing First theory is correct, communities with greater PSH capacity should have lower rates of homelessness because PSH removes people from homelessness permanently, targets the chronically homeless who cycle repeatedly through shelters, and frees emergency shelter capacity for newly homeless individuals.

## Hypotheses

- **H1:** PSH bed capacity is negatively associated with community homelessness rates
- **H2:** Emergency Shelter bed capacity has no significant association with homelessness rates
- **H3:** Rapid Re-Housing bed capacity is negatively associated with homelessness rates, but weaker than PSH

## Data

**Unit of Analysis:** Continuum of Care (CoC)

**Year:** 2023 (cross-sectional)

**Sources:**

| Data | Source |
|------|--------|
| PIT Counts by CoC | [HUD USER AHAR 2023](https://www.huduser.gov/portal/datasets/ahar/2023-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html) |
| Housing Inventory Count by CoC | [HUD USER AHAR 2023](https://www.huduser.gov/portal/datasets/ahar/2023-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html) |

### Data Download Instructions

1. Go to: https://www.huduser.gov/portal/datasets/ahar/2023-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html
2. Download:
   - `2007-2023-PIT-Counts-by-CoC.xlsb`
   - `2007-2023-HIC-Counts-by-CoC.xlsx`
3. Place both files in the `data/raw/` folder

## Variables

### Dependent Variable (Continuous)

| Variable | Description | Calculation |
|----------|-------------|-------------|
| `homeless_rate` | Homelessness rate per 10,000 population | (Total PIT Count ÷ CoC Population) × 10,000 |

### Independent Variables (Continuous)

| Variable | Description | Expected Sign |
|----------|-------------|---------------|
| `psh_beds_pc` | PSH beds per 10,000 population | Negative (−) |
| `rrh_beds_pc` | RRH beds per 10,000 population | Negative (−) |
| `es_beds_pc` | Emergency Shelter beds per 10,000 population | Null (0) |
