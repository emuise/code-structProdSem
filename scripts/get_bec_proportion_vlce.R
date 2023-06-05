unique_bec <- bec_normal %>%
  pull(bec) %>%
  unique()

bec_prop_vlce_loc <- here::here("data", "bec_prop_vlce.csv")

if (!file.exists(bec_prop_vlce_loc)) {
  zonal_freq <- function(bec) {
    single_bec <- subst(bec_rast, bec, 1, others = NA)
    
    mask(vlce, single_bec) %>%
      freq() %>%
      tibble() %>%
      mutate(bec = bec)
  }
  
  zonal_prop <- map(unique_bec, zonal_freq, .progress = T) %>%
    list_rbind()
  
  write_csv(zonal_prop, bec_prop_vlce_loc)
}

zonal_prop <- read_csv(bec_prop_vlce_loc)

per_con_for <- zonal_prop %>%
  left_join(keys$vlce, by = c("value" = "name_clean")) %>%
  filter(forest == "Forest") %>%
  group_by(bec) %>%
  mutate(per_con = count / sum(count)) %>%
  filter(value == "Coniferous") %>%
  select(bec, value, per_con)

per_con_total <- zonal_prop %>%
  left_join(keys$vlce, by = c("value" = "name_clean")) %>%
  #filter(forest == "Forest") %>%
  group_by(bec) %>%
  mutate(per_tot = count / sum(count)) %>%
  filter(value == "Coniferous") %>%
  select(bec, value, per_tot)

per_cons <- left_join(per_con_for, per_con_total)

rm(unique_bec, bec_prop_vlce_loc, zonal_prop, per_con_for, per_con_total)
