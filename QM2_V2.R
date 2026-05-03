# --- PIT Data: Filter to 2023 ---
pit_2023 <- pit_raw %>%
  filter(Year == 2023) %>%
  select(
    coc_code = `CoC Number`,
    coc_name = `CoC Name`,
    total_homeless = `Overall Homeless, 2023`,
    sheltered = `Overall Homeless - Sheltered, 2023`,
    unsheltered = `Overall Homeless - Unsheltered, 2023`
  )

cat("PIT 2023:", nrow(pit_2023), "CoCs\n")
install.packages("readxlsb")
library(readxlsb)
read_xlsb("~/Desktop/data raw/2007-2023-PIT-Counts-by-CoC.xlsb")
install.packages("openxlsx2")
library(openxlsx2)
wb <- wb_load("~/Desktop/data raw/2007-2023-PIT-Counts-by-CoC.xlsb")
pit_2023 <- pit_raw %>%
  filter(Year == 2023) %>%
  select(
    coc_code = `CoC Number`,
    coc_name = `CoC Name`,
    total_homeless = `Overall Homeless, 2023`,
    sheltered = `Overall Homeless - Sheltered, 2023`,
    unsheltered = `Overall Homeless - Unsheltered, 2023`
  )
