# data_raw/

Raw files required to reproduce the analysis. These are **not** committed to the repo (see `.gitignore`). Download them and place here.

## Required files

1. `20072023HICCountsbyCoC.xlsx` — HUD Housing Inventory Counts, 2007–2023.
   Source: https://www.huduser.gov/portal/datasets/ahar/2023-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html

2. `20072023PITCountsbyCoC.xlsb` — HUD Point-in-Time Counts, 2007–2023.
   Source: same page as above.

3. `coc_population_2023.csv` — **You must supply this.** The two HUD files above do **not** contain CoC population. Options:
   - Download HUD's CoC-level ACS companion file and extract total population.
   - Pull ACS population via the `tidycensus` R package and merge to CoCs using a county-to-CoC crosswalk (HUD publishes one).
   Expected columns: `coc_number`, `population`.
