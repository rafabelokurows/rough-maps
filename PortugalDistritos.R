library(sf)
library(tidyverse)
library(roughsf)

ch <- rnaturalearth::ne_states(country = c("Portugal"), returnclass = "sf")
#ch <- rnaturalearth::ne_states(country = c("United Kingdom", "Ireland"), returnclass = "sf")

xmin <- -10.217285
xmax <- -6.075439
ymin <- 36.853252
ymax <- 42.187829
bbox <- st_polygon(list(matrix(c(xmin, ymin,
                                 xmax, ymin,
                                 xmax, ymax,
                                 xmin, ymax,
                                 xmin, ymin), ncol = 2, byrow = TRUE)))
bbox_sf <- st_sfc(bbox, crs = 4326)
cols <- c("#8dd3c7",
          "#ffffb3",
          "#bebada",
          "#fb8072",
          "#80b1d3",
          "#fdb462",
          "#b3de69",
          "#fccde5",
          "#d9d9d9",
          "#bc80bd",
          "#ccebc5",
          "#ffed6f",
          "#6D2E46",
          "#222725",
          "#143109",
          "#62BBC1",
          "#7F7F7F",
          "#21897E")
ch2 <- ch %>%
  #st_intersection(bbox_sf) %>%
  mutate(colx = sample(cols, nrow(.), replace = TRUE),
         # color = colx,
         fill = colx,
         hachureangle = sample(0:180, nrow(.), replace = TRUE),
         stroke = .5) %>%
  st_cast("POLYGON")

# urban2 <- urban %>%
#   st_intersection(bbox_sf)
centros <- ch2 %>%
  st_centroid() %>%
  st_intersection(bbox_sf) %>%
  mutate(label = name,
         size = 0)
#%>%
  #group_by(name) %>% dplyr::slice(1)

centros$size=NA

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

ch2 = ch2 %>% filter(!name %in% c("Azores","Madeira") ) %>% dplyr::slice(c(1:14,16:21))
roughsf::roughsf(list(ch2,centros %>% dplyr::slice(c(1:9,10,12,14,16:21))),
                 roughness = 1,
                 bowing = 4,
                 simplification = 3,
                 width = 490,
                 height = 920,
                 font = "20px Palatino Linotype",
                 caption = "Viz: @rafabelokurows",
                 caption_font = "20px Palatino Linotype",
                 title_font = "26px Palatino Linotype",
                 title = "Distritos de Portugal"
)
