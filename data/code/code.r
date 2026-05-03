Code/01_data_import.R
library(readxl)
library(readxlsb)
library(dplyr)

hic <- read_excel("2007-2023-HIC-Counts-by-CoC.xlsx")

pit <- read_xlsb(
  "2007-2023-PIT-Counts-by-CoC.xlsb",
  sheet = 1
)
