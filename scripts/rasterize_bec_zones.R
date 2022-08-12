library(tidyverse)
library(terra)
library(sf)

terraOptions(memfrac = 0.75,
             tempdir = "E:\\temp",
             todisk = T,
             progress = 100)

vect <- read_sf(here::here("E:\\Sync\\Masters\\analysis\\data\\shapefiles\\bc_ppa_bec_hres.shp")) %>%
  select(zone, subzone, NAME_E, IUCN_CA, geometry)


pa_subzone_rast <- vect %>%
  mutate(protected = !is.na(IUCN_CA),
         rasterize = paste0(ifelse(protected, "p", "np"), "-", zone, "_", subzone)) %>%
  vect() %>%
  rasterize(y = rast("G:\\Merged\\harvest_mask\\harvest_mask.tif"), field = "rasterize") %>%
  writeRaster("G:\\Merged\\bec_singles\\pa_subzones.dat",
              filetype = "envi")

subzone_rast <- vect %>%
  mutate(rasterize = paste0(zone, "_", subzone)) %>%
  vect() %>%
  rasterize(y = rast("G:\\Merged\\harvest_mask\\harvest_mask.tif"), field = "rasterize") %>%
  writeRaster("G:\\Merged\\bec_singles\\subzones.dat",
              filetype = "envi")

zone_rast <- vect %>%
  vect() %>%
  rasterize(y = rast("G:\\Merged\\harvest_mask\\harvest_mask.tif"), field = "zone")  %>%
  writeRaster("G:\\Merged\\bec_singles\\zones.dat",
              filetype = "envi")
