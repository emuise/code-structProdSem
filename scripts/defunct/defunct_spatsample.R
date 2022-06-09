#### this is some defunct sampling code that works with categorical rasters
#    as numerics. it doesn't work great. moving to tristan's method

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
