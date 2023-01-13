library(sf)
library(tidyverse)
library(roughsf)

ch <- rnaturalearth::ne_states(country = c("Spain"), returnclass = "sf")
#ch <- rnaturalearth::ne_states(country = c("United Kingdom", "Ireland"), returnclass = "sf")
#-10.371094,35.924645,4.504395,43.882057
xmin <- -10.371094
xmax <- 4.504395
ymin <- 35.924645
ymax <- 43.882057
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
# group_by(name) %>% dplyr::slice(1)

ch2 = ch2 %>% filter(!name %in% c("Las Palmas","Santa Cruz de Tenerife") )
centros = centros %>%
  filter((!str_detect(row.names(centros),"[.]")|str_detect(row.names(centros),"4543.2|4541.1|2871.2"))&
           !row.names(centros) %in% c("4543","4541","2871"))


cities <- data.frame(name = c("Madrid (Ciudad)", "Barcelona"))#, "Coimbra", "Faro"))
# cities$geometry <- st_sfc(
#   st_point(c(41.157777, -8.628484)), st_point(c(38.722083, -9.139859)),
#   st_point(c(40.203323, -8.410256)), st_point(c(37.019578, -7.929983))
# )

cities$geometry <- st_sfc(
  st_point(c(-3.6548902,40.3724978)), st_point(c(2.1657791,41.3820478)))
#st_point(c( -8.410256,40.203323)), st_point(c(-7.929983,37.019578)))


cities <- st_sf(cities)
st_crs(cities) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
cities$size <- 10
cities$color <- "#000000"
cities$label <- ""#cities$name
cities$label_pos <- c("s","e")

ch2$size <- 0.1
ch2$stroke <- 0.5
ch2$fillweight <- 0.5
ch2$fillstlye <- "hachure"

centros$size <- NA
centros$stroke <- 0.5
centros$fillweight <- 0.5
centros$fillstlye <- "hachure"


roughsf::roughsf(list(ch2,centros,cities ),
                 roughness = 1,
                 bowing = 2,
                 simplification =3,
                 width = 1050,
                 height = 780,
                 font = c("15px Arial"),
                 caption = "Viz: @rafabelokurows",
                 caption_font = "16px Palatino Linotype",
                 title_font = "26px Palatino Linotype",
                 title = "Províncias de España"
)
