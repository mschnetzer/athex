library(tidyverse)
library(sf)

# Source of map: https://github.com/ginseng666/GeoJSON-TopoJSON-Austria/tree/master/2021
map <- st_read("https://raw.githubusercontent.com/ginseng666/GeoJSON-TopoJSON-Austria/master/2021/simplified-99.9/bezirke_999_geo.json") %>%
  mutate(iso = as.numeric(iso),
         iso = ifelse(iso %in% 901:923, 900, iso),
         name = ifelse(iso == 900, "Wien", name)) %>%
  group_by(iso,name) %>% 
  summarise(across(geometry, ~ sf::st_union(.)), .groups = "keep") %>%
  summarise(across(geometry, ~ sf::st_combine(.)))

shape <- map %>% st_transform(3857) %>%
  mutate(index_target = 1:n())

target <- st_geometry(shape)

grid <- st_make_grid(target,
                     cellsize = 15 * 1000, # 15km size
                     crs = st_crs(shape),
                     what = "polygons",
                     square = FALSE)

grid <- st_sf(index = 1:length(lengths(grid)), grid)

cent_grid <- st_centroid(grid)
cent_merge <- st_join(cent_grid, shape, left = FALSE)
grid_new <- inner_join(grid, st_drop_geometry(cent_merge))

athex <- grid_new %>% st_transform(4326)

st_write(athex, "data/athex.geojson", append = F)
save(athex, file = "data/athex.RData")
