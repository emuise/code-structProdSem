library(tidyverse)
library(terra)
library(bcmaps)
library(sgsR)

terraOptions(memfrac = 0.75,
             tempdir = "E:\\temp",
             todisk = T,
             progress = 100)

source(here::here("scripts", "get_keys.R"))

# all analysis done on year 2015 unless otherwise stated
# dhis are another story, i need to look at code / ask elena how it works

merged_loc <- here::here("G://", "Merged")

# load in and align all rasters
# origin and crs are the same, so it is safe to use crop on the dhi rasters

vlce <- rast(here::here(merged_loc, "vlce", "BC-vlce-2015.tif"))

bcb_rast <- bc_bound() %>%
  mutate(rasterize = "BC") %>%
  vect() %>%
  rasterize(y = vlce)

vlce <- mask(vlce, bcb_rast)

agb <- rast(here::here(merged_loc, "total_biomass", "BC-total_biomass-2015.tif"))
height <- rast(here::here(merged_loc, "loreys_height", "BC-loreys_height-2015.tif"))
cover <- rast(here::here(merged_loc, "percentage_first_returns_above_2m", "BC-percentage_first_returns_above_2m-2015.tif"))

dhi_rasts <- here::here(merged_loc, "DHI") %>%
  list.files(full.names = T) %>%
  str_subset(pattern = "BC") %>%
  map(rast) %>%
  rast() %>%
  crop(vlce)

names(dhi_rasts) <- c("cum", "min", "var")

structure_rasts <- c(agb, height, cover)

# generate reclassification matrix to select only forests AND retain
# their land cover class number

rcl <- keys$vlce %>%
  mutate(class_name = ifelse(forest == "Forest", class_val, NA)) %>%
  select(class_val, class_name) %>%
  as.matrix(ncol = 2)

forests <- classify(vlce, rcl)
names(forests) <- "strata"

#masked_all <- mask(all_rasts, bcb_rast)

# locate stratified samapling points within each forest type

all_rasts <- c(forests, dhi_rasts, structure_rasts)

sample <- spatSample(forests,
                     1000,
                     method = "stratified",
                     na.rm = T,
                     as.df = T,
                     xy = T)

bec_rast <- rast(here::here(merged_loc, "bec_singles", "zones.tif"))

bec_rast[bec_rast == 12] = NA

bec_join <- cats(bec_rast)[[1]] %>%
  tibble() %>%
  filter(!is.na(zone)) %>%
  rename(bec_value = value,
         zone_name = zone)

forest_join <- keys$vlce %>%
  filter(forest == "Forest") %>%
  select(class_val, class_name)

key_table <- crossing(bec_value = bec_join$bec_value, 
                      class_val =  forest_join$class_val) %>%
  left_join(bec_join) %>%
  left_join(forest_join) %>%
  mutate(rast_num = bec_value * 1000 + class_val)

both_rast <- bec_rast * 1000 + forests

both_uniques <- unique(both_rast) %>% 
  tibble()

full_join(both_uniques, key_table, by = c("strata" = "rast_num")) %>% view()


sample <- spatSample(both_rast, 
           10000,
           method = "stratified",
           as.df = T,
           xy = T)
