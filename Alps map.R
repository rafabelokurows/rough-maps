library(sf)
library(tidyverse)
library(roughsf)

borders = rnaturalearth::ne_countries(country = c("Switzerland","Italy","Austria","Germany","France",
                                                  "Slovenia"), returnclass = "sf")
borders = borders  %>%
  st_cast("POLYGON")
borders = borders %>% filter(row.names(borders) != 55)
borders$fill <- "#1F7A8C"#"#29b0aa"
borders$stroke <- 1
borders$fillweight <- 0.4

#file available remotely inside "data" directory
alps = st_read("C:\\Users\\belokurowsr\\Downloads\\alps.geojson") %>%
  st_cast("POLYGON")
alps$fill <- "#DB222A"#"#E69F00"
alps$stroke <- 1
alps$fillweight <- 1.5

roughsf::roughsf(list(alps,borders),
                 roughness = 2,
                 bowing = 3,
                 simplification =2,
                 width = 670,
                 height = 820,
                 font = c("15px Arial"),
                 caption = "Viz: @rafabelokurows",
                 caption_font = "16px Palatino Linotype",
                 title_font = "26px Palatino Linotype",
                 title = "The extent of the European Alps"
)
