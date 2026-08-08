create_map <- function(data = data,
                       fill = "prop_missing",
                       country.col.name,
                       color.scale = TRUE) {
  
  proj_crs <- "+proj=natearth +datum=WGS84"   # Natural Earth projection
  
  ocean <- st_polygon(list(cbind(
    c(seq(-180, 179, length.out = 100), rep(180, 100), seq(179, -180, length.out = 100), rep(-180, 100)),
    c(rep(-90, 100), seq(-89, 89, length.out = 100), rep(90, 100), seq(89, -90, length.out = 100))
  ))) %>%
    st_sfc(crs = "WGS84") %>%
    st_as_sf()
  
  ocean_proj <- st_transform(ocean, crs = proj_crs)
  
  world_map <- ne_countries(scale = "medium", returnclass = "sf") %>%
    mutate(iso_a3 = case_when(
      sovereignt == "Norway" ~ "NOR",
      sovereignt == "France" ~ "FRA",
      TRUE ~ iso_a3
    )) %>%
    left_join(data, by = c("iso_a3" = country.col.name)) %>%
    st_transform(crs = proj_crs) %>%
    filter(sovereignt != "Antarctica")
  
  bbox <- st_bbox(ocean_proj)
  pad <- 0.02 * max(bbox["xmax"] - bbox["xmin"], bbox["ymax"] - bbox["ymin"])
  
  ggplot() +
    geom_sf(data = ocean_proj, fill = "#e0e0e0") +
    geom_sf(data = world_map, aes(fill = !!sym(fill)), color = "grey30", linewidth = 0.05) +
    {if (color.scale) scale_fill_distiller(palette = "OrRd", direction = 1, na.value = "#f2f2f2") else scale_fill_manual(values = "#f2f2f2")} +
    coord_sf(
      crs = proj_crs,
      xlim = c(bbox["xmin"] - pad, bbox["xmax"] + pad),
      ylim = c(bbox["ymin"] - pad, bbox["ymax"] + pad),
      expand = FALSE
    ) +
    theme_void() +
    theme(
      legend.position = "bottom",
      panel.background = element_rect(fill = NA, colour = NA),
      plot.background  = element_rect(fill = NA, colour = NA),
      panel.grid = element_blank()
    )
}