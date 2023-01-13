library(sf)
library(tidyverse)
library(roughsf)

ger <- rnaturalearth::ne_countries(scale = "medium", country = "Portugal", returnclass = "sf")
ger <- st_cast(ger, "POLYGON")
ger$fill <- "#59B366"
ger$stroke <- 2
ger$fillweight <- 0.5
#install.packages("rnaturalearthdata")
ger = ger %>% dplyr::slice(9)


cities <- data.frame(name = c("Porto", "Lisboa"))#, "Coimbra", "Faro"))
# cities$geometry <- st_sfc(
#   st_point(c(41.157777, -8.628484)), st_point(c(38.722083, -9.139859)),
#   st_point(c(40.203323, -8.410256)), st_point(c(37.019578, -7.929983))
# )

cities$geometry <- st_sfc(
  st_point(c(-8.628484,41.157777)), st_point(c(-9.139859,38.722083)))
  #st_point(c( -8.410256,40.203323)), st_point(c(-7.929983,37.019578)))


cities <- st_sf(cities)
st_crs(cities) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
cities$size <- 10
cities$color <- "#000000"
cities$label <- cities$name
cities$label_pos <- "e"

roughsf::roughsf(list(ger,cities),
                 title = "Portugal",
                 title_font = "32px Pristina", font = "24px Pristina", caption_font = "20px Pristina",
                 roughness = 2,
                 bowing = 5, simplification = 3,
                 width = 600, height = 900
)
