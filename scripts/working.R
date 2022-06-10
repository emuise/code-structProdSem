library(tidyverse)
library(terra)
library(bcmaps)
library(sgsR)
library(sf)

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

# generate reclassification matrix to select only forests AND retain
# their land cover class number

rcl <- keys$vlce %>%
  mutate(class_name = ifelse(forest == "Forest", class_val, NA)) %>%
  select(class_val, class_name) %>%
  as.matrix(ncol = 2)

forests <- classify(vlce, rcl)
names(forests) <- "strata"

bec_rast <- rast(here::here(merged_loc, "bec_singles", "zones.tif"))

names(bec_rast) <- "strata"

#masked_all <- mask(all_rasts, bcb_rast)

# locate stratified samapling points within each forest type

grid <- rast(ncol = 5, nrow = 5, ext = ext(forests))

tiles_loc <- here::here("scratch", "tiles")

dir.create(tiles_loc, recursive = T, showWarnings = F)

terra::makeTiles(x = forests, y = grid, 
                 here::here("scratch", "tiles", "f-tile_.tif"), 
                 na.rm=TRUE, overwrite = TRUE)

terra::makeTiles(x = bec_rast, y = grid, 
                 here::here("scratch", "tiles", "b-tile_.tif"), 
                 na.rm=TRUE, overwrite = TRUE)

b_files <- list.files(tiles_loc, pattern = "^b.*.tif$") %>%
  here::here(tiles_loc, .)
f_files <- list.files(tiles_loc, pattern = "^f.*.tif$") %>%
  here::here(tiles_loc, .)


if(length(b_files) != length(f_files)){
  print("files not same length, loop will break")
}



#--- make first to allow for rbinding ---#

samples <- st_sf(st_sfc()) %>%
  st_set_crs(3005)

lookups <- tibble()

for(i in 1:length(b_files)){
  b_rast <- rast(b_files[[i]])
  f_rast <- rast(f_files[[i]])
  
  names(b_rast) <- "strata"
  names(f_rast) <- "strata"
  
  strat <- strat_map(b_rast,
                     f_rast,
                     details = T)
  
  sample <- sample_strat(strat$outRaster,
               50, 
               allocation = "equal",
               mindist = 1000)
 
  samples <- rbind(samples, sample)
  
  lookups <- bind_rows(lookups, strat$lookUp)
   
}


st_write(samples, "Z:/TGood/bud_samples.shp")

# rasters with actual data in them

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


value_rasts <- c(dhi_rasts, structure_rasts)