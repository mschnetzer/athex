# athex

Experimental hexagon map for districts in Austria

## Example

    library(tidyverse)
    library(sf)
    library(wesanderson)

    map <- st_read("https://raw.githubusercontent.com/mschnetzer/hex_austria/main/data/athex.geojson")

    map <- map %>% group_by(iso) %>% 
    mutate(indicator = rnorm(1, mean = 0, sd = 1))

    ggplot(map) +
    geom_sf(aes(fill = indicator), size = 0.2) +
    geom_sf(fill = NA, size = 0.5, color = "black",
            data = . %>% group_by(iso) %>% summarise()) +
    scale_fill_gradientn(guide = guide_colorbar(barheight = 10, barwidth = 0.3),
            name = NULL, colors = wes_palette("Zissou1", 100, type = "continuous")) +
    theme_void()

![Hexagon map of districts in Austria](https://github.com/mschnetzer/athex/blob/main/example.png?raw=true)

## Caveat

Due to the hexagon size (15km), two districts (Rust and Waidhofen an der Ybbs) are not included in the  map. You can modify the hexagon size in the code file to get your custom hexagon map.

## Credits

The original idea and code can be found here: https://rpubs.com/dieghernan/beautifulmaps_I