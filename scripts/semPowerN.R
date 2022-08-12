library(tidyverse)
library(semPower)

models <-  "cumDHI ~ percentage_first_returns_above_2m + loreys_height + total_biomass
  percentage_first_returns_above_2m ~ loreys_height
  total_biomass ~ loreys_height"

n <- semPower(type = "a-priori", effect = 0.05, effect.measure = "RMSEA", alpha = 0.5, power = 0.8, df = semPower.getDf(models))$requiredN
