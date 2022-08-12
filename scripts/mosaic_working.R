library(tidyverse)
library(terra)
library(bcmaps)
library(sgsR)
library(sf)
library(ggrepel)

#### setup ----
terraOptions(
  memfrac = 0.75,
  tempdir = "E:\\temp",
  todisk = T,
  progress = 100
)
options(scipen = 999)

source(here::here("scripts", "get_keys.R"))
merged_loc <- here::here("G://", "mosaiced")

dirs <- list.dirs(merged_loc, recursive = F)

#### data rasters ----
vlce <- str_subset(dirs, "VLCE2.0") %>%
  list.files(pattern = ".dat$", full.names = T) %>%
  rast()

bcb <- bc_bound() %>%
  vect()

bcb_rast <- bcb %>%
  rasterize(y = vlce) %>%
  crop(bcb)

vlce <- crop(vlce, bcb_rast, mask = T)

all_rasts_path <- here::here("data", "rasts", "all_rasts.dat")
if (!file.exists(all_rasts_path)) {
  bec_rast <- bec() %>%
    select(ZONE) %>%
    vect() %>%
    rasterize(y = vlce, field = "ZONE") %>%
    crop(vlce) %>%
    mask(bcb_rast)
  
  # adjust rasters to suit my needs
  
  # generate reclassification matrix to select only forests AND retain
  # their land cover class number
  vlce_rcl <- keys$vlce %>%
    mutate(class_name = ifelse(forest == "Forest", class_val, NA)) %>%
    select(class_val, class_name) %>%
    as.matrix(ncol = 2)
  
  forests <- classify(vlce, vlce_rcl)
  
  struct_names <- str_subset(dirs, "structure") %>%
    list.dirs(full.names = F) %>%
    .[-1] # removes first index which is the base folder
  
  structure <- str_subset(dirs, "structure") %>%
    list.files(pattern = ".dat$",
               full.names = T,
               recursive = T) %>%
    map(rast)
  
  names(structure) <- struct_names
  
  structure <- rast(structure)  %>%
    crop(vlce) %>%
    mask(bcb_rast)
  
  dhi_names <- str_subset(dirs, "DHI") %>%
    list.files(pattern = ".tif$") %>%
    str_extract("\\w{3}DHI")
  
  dhi <- str_subset(dirs, "DHI") %>%
    list.files(pattern = ".tif$", full.names = T) %>%
    map(rast)
  
  names(dhi) <- dhi_names
  
  dhi <- rast(dhi) %>%
    crop(vlce) %>%
    mask(bcb_rast)
  
  names(forests) <- "forests"
  names(bec_rast) <- "bec"
  
  all_rasts <- c(forests, bec_rast, structure, dhi)
  
  writeRaster(all_rasts, all_rasts_path,
              filetype = "envi")
}

all_rasts <- rast(all_rasts_path)
forests <- all_rasts$forests
bec_rast <- all_rasts$bec + 1 # adjust bec zones because of saving



#### implement strata building ----
# no change
change <- str_subset(dirs, "change_attribution") %>%
  list.files(pattern = ".dat$", full.names = T) %>%
  rast()

#rcl of high confidence disturbances
change_rcl <- keys$disturbance %>%
  mutate(class_name = ifelse(class_val > 0 &
                               class_val <= 4, 1, NA)) %>%
  select(class_val, class_name) %>%
  as.matrix(ncol = 2)

change_mask <- classify(change, change_rcl)  %>%
  crop(vlce) %>%
  mask(bcb_rast)

# forested (same type?) in surrounding pixels
# function to see if centre pixel is equal to all surrounding pixels
# categorical raster
my_sim_neigh <- function(x) {
  if (length(na.omit(x)) == length(x)) {
    return(all(x == x[(length(x) + 1) / 2]))
  } else {
    return(NA)
  }
}

# covariance < 0.5 in local neighbourhood for all struct values
# function to calculate covariance of each pixel
# numeric rasters

mycov <- function(x) {
  if (length(na.omit(x)) == length(x)) {
    return(sd(x) / mean(x))
  } else {
    return(NA)
  }
}

#### sampling ----

samples_loc <- here::here("data", "shp", "samples.shp")

if (!file.exists(samples_loc)) {
  grid_ncol <- 5
  grid_nrow <- 5
  
  # make tiles to grab samples from
  grid <-
    rast(ncol = grid_ncol,
         nrow = grid_ncol,
         ext = ext(forests))
  
  tiles_loc <- here::here("scratch", "tiles")
  
  dir.create(tiles_loc, recursive = T, showWarnings = F)
  
  b_files <- list.files(here::here("scratch", "tiles"),
                        pattern = "^b.*\\.dat$",
                        full.names = T)
  
  max_tile <- str_extract(b_files, "[0-9]{1,2}.dat$") %>%
    str_extract("[0-9]{1,2}") %>%
    as.numeric() %>%
    max()
  
  if (max_tile != (grid_ncol * grid_nrow)) {
    file.remove(list.files(here::here("scratch", "tiles"), full.names = T))
    
    b_files <- terra::makeTiles(
      x = bec_rast,
      y = grid,
      here::here("scratch", "tiles", "b-tile_.dat"),
      na.rm = TRUE,
      overwrite = TRUE,
      filetype = "ENVI"
    )
  }
  
  
  
  # make first to allow for rbinding
  samples <- st_sf(st_sfc()) %>%
    st_set_crs(3005)
  
  freqs <- tibble()
  
  suit_dir <- here::here("scratch", "suit")
  dir.create(suit_dir, showWarnings = F)
  
  for (i in b_files) {
    base_sample_per_tile = 10000
    # if the entire tile is forested land, take 10000 samples from said tile
    suit_save_loc <-
      here::here(suit_dir, paste0("suit-", basename(i)))
    
    start_time <- Sys.time()
    print("Suitability for tile")
    print(i)
    
    if (!file.exists(suit_save_loc)) {
      b_rast <- rast(i)
      names(b_rast) <- "strata"
      
      extended <- extend(b_rast, 1)
      
      # suitability
      
      # surrounded by same forest type
      forests <- all_rasts$forests %>%
        crop(b_rast)
      
      tile_forests <- all_rasts$forests %>%
        crop(extended) %>%
        focal(w = 3, fun = my_sim_neigh) %>%
        crop(b_rast)
      
      # change
      tile_change <- change_mask %>%
        crop(b_rast)
      
      # covariance height and cover
      tile_cover <- all_rasts$percentage_first_returns_above_2m %>%
        crop(extended) %>%
        focal(w = 3, fun = mycov) %>%
        crop(b_rast)
      
      
      tile_height <- all_rasts$loreys_height %>%
        crop(extended) %>%
        focal(w = 3, fun = mycov) %>%
        crop(b_rast)
      
      suit <- b_rast %>%
        mask(tile_forests, maskvalues = c(0, NA)) %>%
        mask(tile_change, maskvalues = 1) %>%
        mask(tile_cover < 0.5, maskvalues = c(0, NA)) %>%
        mask(tile_height < 0.5, maskvalues = c(0, NA))
      
      writeRaster(suit, suit_save_loc,
                  filetype = "envi")
      print("Time to generate and save suitability raster")
      print(Sys.time() - start_time)
    }
    
    print("Making freak table")
    suit <- rast(suit_save_loc)
    plot(suit, main = suit_save_loc)
    freqtab <- freq(suit) %>%
      as.data.frame() %>%
      tibble() %>%
      mutate(tile = suit_save_loc)
    
    if (!nrow(freqtab) == 0) {
      freqs <- bind_rows(freqs, freqtab)
    }
    #Sys.sleep(5)
    
  }
  
  suit_tiles <-
    list.files(suit_dir, pattern = ".dat$", full.names = T)
  
  n = 1000 # total number of samples estimated using semPower
  # see here::here("scripts", "semPowerN.R")
  
  freq_weights <- freqs %>%
    select(!layer) %>%
    mutate(tileno = as.numeric(str_extract(tile, "\\d+"))) %>%
    group_by(value) %>%
    mutate(per_bec = count / sum(count),
           samples = ceiling(n * per_bec)) %>%
    group_by(tileno) %>%
    mutate(weights = samples / sum(samples)) %>%
    ungroup()
  
  
  for (suit_save_loc in suit_tiles) {
    print("Loaded suitability raster from save")
    print(suit_save_loc)
    suit <- rast(suit_save_loc)
    
    plot(suit, main = suit_save_loc)
    
    tile_obj <- as.numeric(str_extract(suit_save_loc, "\\d+"))
    
    tile_freq <- freq_weights %>%
      filter(tileno == tile_obj)
    
    nSamples <- tile_freq %>%
      pull(samples) %>%
      sum()
    
    weights <- tile_freq %>%
      pull(weights)
    
    if (nrow(tile_freq) != 0) {
      sample <- sample_strat(
        sraster = suit,
        nSamp = nSamples,
        allocation = "manual",
        weights = weights,
        mindist = 1000
      )
      plot(sample %>% st_geometry(), add = T)
      samples <- rbind(samples, sample)
      
      #Sys.sleep(5)
    }
  }
  st_write(samples, here::here("data", "shp", "samples.shp"), append = F)
  write_csv(freqs, here::here("data", "freqs.csv"))
}

samples <- st_read(samples_loc)
freqs <- read_csv(here::here("data", "freqs.csv"))

#extracted <- extract_metrics(mraster = all_rasts, existing = samples, data.frame = T)

extracted_loc <- here::here("data", "extracted.csv")

if (!file.exists(extracted_loc)) {
  extracted <- terra::extract(all_rasts, vect(samples)) %>%
    tibble()
  
  write_csv(extracted, extracted_loc)
}

extracted <- read_csv(extracted_loc) %>%
  filter(!is.na(forests))

invalid_zones <- c("BAFA", "IMA", "CMA", "BG")

extracted_clean <- extracted %>%
  select(forests:varDHI) %>%
  mutate(
    bec = bec + 1,
    across(basal_area:varDHI, scale, .names = "{.col}.scale"),
    across(ends_with("scale"), as.numeric)
  ) %>%
  left_join(keys$bec, by = c("bec" = "order")) %>%
  select(!zone_nm & !forests) %>%
  relocate(zone) %>%
  filter(!(zone %in% invalid_zones))

extracted_split <- extracted_clean %>%
  group_by(zone) %>%
  group_split()

extracted_sub <- extracted_clean %>%
  group_by(zone) %>%
  slice(sample(n(), min(855, n())))

extracted_split <- extracted_sub %>%
  select(zone, ends_with("scale")) %>%
  rename_with(~ str_remove(., ".scale")) %>%
  group_split()

zonal_prod <- extracted_sub %>%
  select(zone, cumDHI, minDHI, varDHI) %>%
  group_by(zone) %>%
  summarize(
    cum_mean = mean(cumDHI, na.rm = T),
    min_mean = mean(minDHI, na.rm = T),
    var_mean = mean(varDHI, na.rm = T)
  )

#### structural equation modelling ----

library(lavaan)
library(tidySEM)
library(effectsize)
library(semPlot)

var_order <- c("cumDHI", "varDHI", "minDHI")

# Vertical ----

models_v <-
  paste0(
    var_order,
    " ~ elev_stddev  + loreys_height + total_biomass
  elev_stddev  ~ loreys_height
  total_biomass ~ loreys_height
"
  )

sem_extract <- function(split_df, model) {
  zone <- split_df %>%
    pull(zone) %>%
    unique()
  
  var <- str_split(model, pattern = " ")[[1]][1]
  fit <- sem(model = model, data = split_df)
  summary <- summary(fit)
  
  fits <-
    fitmeasures(fit, c("chisq", "df", "pvalue", "cfi", "rmsea"))
  pars <- parameterestimates(fit) %>%
    tibble() %>%
    mutate(zone = zone, var = var)
  
  fits <- tibble(fit = names(fits), value = as.numeric(fits)) %>%
    pivot_wider(names_from = fit, values_from = value) %>%
    mutate(zone = zone,
           var = var)
  
  return(list(
    fit = fit,
    fitmeasures = fits,
    parameters = pars
  ))
}

sem_extract(extracted_split[[1]], models_v[[1]])

cum_mods_v <-
  map(extracted_split, sem_extract, model = models_v[[1]])
var_mods_v <-
  map(extracted_split, sem_extract, model = models_v[[2]])
min_mods_v <-
  map(extracted_split, sem_extract, model = models_v[[3]])

parameters_v <-
  map_df(c(cum_mods_v, var_mods_v, min_mods_v), function(x) {
    x$parameters
  })

fitmeasures_v <-
  map_df(c(cum_mods_v, var_mods_v, min_mods_v), function(x) {
    x$fitmeasures
  })

fits_v <- map(c(cum_mods_v, var_mods_v, min_mods_v), function(x) {
  x$fit
})

var_names <- tibble(lhs = var_order,
                    name = c("Cumulative DHI",
                             "Variation DHI",
                             "Minimum DHI"))


# Horizontal ----

models_h <-
  paste0(
    var_order,
    " ~ percentage_first_returns_above_mean + basal_area + percentage_first_returns_above_2m
  percentage_first_returns_above_mean ~ percentage_first_returns_above_2m
  basal_area ~ percentage_first_returns_above_2m
"
  )

cum_mods_h <-
  map(extracted_split, sem_extract, model = models_h[[1]])
var_mods_h <-
  map(extracted_split, sem_extract, model = models_h[[2]])
min_mods_h <-
  map(extracted_split, sem_extract, model = models_h[[3]])

parameters_h <-
  map_df(c(cum_mods_h, var_mods_h, min_mods_h), function(x) {
    x$parameters
  })

fitmeasures_h <-
  map_df(c(cum_mods_h, var_mods_h, min_mods_h), function(x) {
    x$fitmeasures
  })

fits_h <- map(c(cum_mods_h, var_mods_h, min_mods_h), function(x) {
  x$fit
})

# path diagram plotting ----

text <- tibble(
  x = c(0, .5, .5, 1.025),
  y = c(0,-0.525, .525, 0),
  index = c("a",
            "b",
            "c",
            "dhi")
)

lines <- tibble(
  x = c(0, 0, 0, 0.5, 0.5),
  y = c(0, 0, 0, 0.5,-0.5),
  xend = c(0.5, 0.5, 1, 1, 1),
  yend = c(0.5,-0.5, 0, 0, 0),
  eq_index = c("c ~ a",
               "b ~ a",
               "dhi ~ a",
               "dhi ~ c",
               "dhi ~ b")
)

vert_ind <- tibble(
  name = c("loreys_height",
           "elev_stddev",
           "total_biomass"),
  index = c("a",
            "b",
            "c")
)

hor_ind <- tibble(
  name = c(
    "percentage_first_returns_above_2m",
    "percentage_first_returns_above_mean",
    "basal_area"
  ),
  index = c("a",
            "b",
            "c")
)

clean_sigs_v <- parameters_v %>%
  filter(op == "~") %>%
  mutate(eq = paste(lhs, op, rhs),
         sig = pvalue < 0.05) %>%
  group_by(lhs, rhs, var, sig) %>%
  summarize(sig_count = sum(sig),
            est = mean(est)) %>%
  filter(sig) %>%
  left_join(vert_ind, by = c("rhs" = "name")) %>%
  rename(rhs_i = index) %>%
  left_join(vert_ind, by = c("lhs" = "name")) %>%
  rename(lhs_i = index) %>%
  mutate(lhs_i = ifelse(is.na(lhs_i), "dhi", lhs_i)) %>%
  mutate(eq_index = paste0(lhs_i, " ~ ", rhs_i))

clean_sigs_h <- parameters_h %>%
  filter(op == "~") %>%
  mutate(eq = paste(lhs, op, rhs),
         sig = pvalue < 0.05) %>%
  group_by(lhs, rhs, var, sig) %>%
  summarize(sig_count = sum(sig),
            est = mean(est)) %>%
  filter(sig) %>%
  left_join(hor_ind, by = c("rhs" = "name")) %>%
  rename(rhs_i = index) %>%
  left_join(hor_ind, by = c("lhs" = "name")) %>%
  rename(lhs_i = index) %>%
  mutate(lhs_i = ifelse(is.na(lhs_i), "dhi", lhs_i)) %>%
  mutate(eq_index = paste0(lhs_i, " ~ ", rhs_i))

text_h <- text %>%
  bind_cols(tibble(label = c(
    "Canopy Cover",
    "Overstorey Cover",
    "Basal Area",
    "DHI"
  ))) %>%
  crossing(lhs = var_order) %>%
  left_join(var_names) %>%
  rename(var = lhs) %>%
  mutate(label = ifelse(label == "DHI", name, label)) %>%
  mutate(model = "Horizontal")

text_v <- text %>%
  bind_cols(tibble(
    label = c(
      "Canopy Height",
      "Elevation Standard Deviation",
      "Total Biomass",
      "DHI"
    )
  )) %>%
  crossing(lhs = var_order) %>%
  left_join(var_names) %>%
  rename(var = lhs) %>%
  mutate(label = ifelse(label == "DHI", name, label)) %>%
  mutate(model = "Vertical")



lines_v <- lines %>%
  left_join(clean_sigs_v) %>%
  mutate(model = "Vertical")

lines_h <- lines %>%
  left_join(clean_sigs_h) %>%
  mutate(model = "Horizontal")

text_all <- bind_rows(text_v, text_h)
lines_all <- bind_rows(lines_h, lines_v)


all_paths <- lines_all %>%
  left_join(var_names, by = c("var" = "lhs")) %>%
  ggplot(aes(x = x, y = y)) +
  geom_segment(aes(
    xend = xend,
    yend = yend,
    size = sig_count / 12,
    #alpha = abs(est),
    colour = est
  ),
  arrow = arrow(length = unit(0.5, "cm"))) +
  theme_void() +
  geom_label(data = text_all, aes(label = label)) +
  facet_grid(rows = vars(name),
             cols = vars(model),
             switch = "y") +
  theme(legend.position = "bottom",
        legend.box = "vertical") +
  labs(colour = "Standardized Estimate",
       size = "Proportion Significant") +
  lims(x = c(-.12, 1.2),
       y = c(-.6, .6)) +
  #scale_colour_manual(values = c("#6a098f", "#f15403")) +
  scico::scale_colour_scico(palette = "vikO",
                            midpoint = 0,
                            limits = c(-1, 1))


ggsave(
  here::here("outputs", "all_paths.png"),
  plot = all_paths,
  height = 10,
  width = 10
)


# all models to pngs
path_dir <- here::here("outputs", "path_diagrams")

if (!dir.exists(path_dir)) {
  dir.create(path_dir)
}

for (index in 1:length(cum_mods_h)) {
  zone_short <- cum_mods_h[[index]]$parameters %>%
    pull(zone) %>%
    unique()
  
  zone_title <- keys$bec %>%
    filter(zone == zone_short) %>%
    pull(zone_nm) %>%
    unique()
  
  print(zone_title)
  
  h <- bind_rows(cum_mods_h[[index]]$parameters,
                 var_mods_h[[index]]$parameters,
                 min_mods_h[[index]]$parameters) %>%
    mutate(model = "Horizontal")
  v <- bind_rows(cum_mods_v[[index]]$parameters,
                 var_mods_v[[index]]$parameters,
                 min_mods_v[[index]]$parameters) %>%
    mutate(model = "Vertical")
  
  clean_h <- h %>%
    filter(op == "~") %>%
    mutate(eq = paste(lhs, op, rhs),
           sig = pvalue < 0.05) %>%
    left_join(hor_ind, by = c("rhs" = "name")) %>%
    rename(rhs_i = index) %>%
    left_join(hor_ind, by = c("lhs" = "name")) %>%
    rename(lhs_i = index) %>%
    mutate(lhs_i = ifelse(is.na(lhs_i), "dhi", lhs_i)) %>%
    mutate(eq_index = paste0(lhs_i, " ~ ", rhs_i))
  
  clean_v <- v %>%
    filter(op == "~") %>%
    mutate(eq = paste(lhs, op, rhs),
           sig = pvalue < 0.05) %>%
    left_join(vert_ind, by = c("rhs" = "name")) %>%
    rename(rhs_i = index) %>%
    left_join(vert_ind, by = c("lhs" = "name")) %>%
    rename(lhs_i = index) %>%
    mutate(lhs_i = ifelse(is.na(lhs_i), "dhi", lhs_i)) %>%
    mutate(eq_index = paste0(lhs_i, " ~ ", rhs_i))
  
  lines_h <- lines %>%
    left_join(clean_h)
  
  lines_v <- lines %>%
    left_join(clean_v)
  
  lines_all_loop <- bind_rows(lines_h, lines_v)
  
  plot <- lines_all_loop %>%
    left_join(var_names, by = c("var" = "lhs")) %>%
    mutate(
      text_x_pos = (x + xend) / 2,
      text_y_pos = (y + yend) / 2,
      label = paste("P:", round(pvalue, digits = 2), "\nest:", round(est, digits = 2))
    ) %>%
    ggplot(aes(x = x, y = y)) +
    geom_segment(
      aes(
        xend = xend,
        yend = yend,
        #size = sig_count / 12,
        #alpha = abs(est),
        colour = est,
        lty = sig
      ),
      arrow = arrow(length = unit(0.5, "cm")),
      size = 2
    ) +
    geom_text(aes(x = text_x_pos, y = text_y_pos, label = label)) +
    theme_void() +
    geom_label(data = text_all, aes(label = label)) +
    facet_grid(rows = vars(name),
               cols = vars(model),
               switch = "y") +
    theme(
      legend.position = "bottom",
      legend.box = "vertical",
      plot.background = element_rect(fill = "white", colour = "white")
    ) +
    labs(colour = "Standardized Estimate",
         lty = "Significant?",
         title = zone_title) +
    lims(x = c(-.12, 1.2),
         y = c(-.6, .6)) +
    scico::scale_colour_scico(palette = "vikO", limits = c(-1, 1))
  
  
  ggsave(
    here::here(path_dir, paste0(zone_short, "_path.png")),
    plot = plot,
    device = "png",
    height = 10,
    width = 10
  )
}

lines_all %>%
  left_join(var_names, by = c("var" = "lhs")) %>%
  filter(name == "Cumulative DHI") %>%
  ggplot(aes(x = x, y = y)) +
  geom_segment(aes(
    xend = xend,
    yend = yend,
    #size = sig_count / 12,
    #alpha = abs(est),
    #colour = est
  ),
  arrow = arrow(length = unit(0.5, "cm")),
  size = 2) +
  theme_void() +
  geom_label(data = text_all %>%
               filter(name == "Cumulative DHI") %>%
               mutate(label = ifelse(endsWith(label, "DHI"), "3x DHI", label)), aes(label = label)) +
  facet_grid(#rows = vars(name),
             cols = vars(model),
             switch = "y") +
  theme(legend.position = "bottom",
        legend.box = "vertical") +
  labs(colour = "Standardized Estimate",
       size = "Proportion Significant") +
  lims(x = c(-.12, 1.2),
       y = c(-.6, .6)) +
  #scale_colour_manual(values = c("#6a098f", "#f15403")) +
  scico::scale_colour_scico(palette = "vikO",
                            midpoint = 0,
                            limits = c(-1, 1))

ggsave(here::here("outputs", "paths.png"))

text_all %>%
  filter(name == "Cumulative DHI") %>%
  mutate(label = ifelse(endsWith(label, "DHI"), "3x DHI", label))
