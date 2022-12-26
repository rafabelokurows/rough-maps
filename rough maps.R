library(sf)
library(tidyverse)
library(roughsf)
ger <- rnaturalearth::ne_countries(scale = "medium", country = "Portugal", returnclass = "sf")
ger <- st_cast(ger, "POLYGON")
ger$fill <- "#59B366"
ger$stroke <- 2
ger$fillweight <- 0.5
#install.packages("rnaturalearthdata")
ger = ger %>% slice(9)


cities <- data.frame(name = c("Porto", "Lisboa", "Coimbra", "Faro"))
# cities$geometry <- st_sfc(
#   st_point(c(41.157777, -8.628484)), st_point(c(38.722083, -9.139859)),
#   st_point(c(40.203323, -8.410256)), st_point(c(37.019578, -7.929983))
# )

cities$geometry <- st_sfc(
  st_point(c(-8.628484,41.157777)), st_point(c(-9.139859,38.722083)),
  st_point(c( -8.410256,40.203323)), st_point(c(-7.929983,37.019578))
)


cities <- st_sf(cities)
st_crs(cities) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
cities$size <- 15
cities$color <- "#000000"
cities$label <- cities$name
cities$label_pos <- "e"

roughsf::roughsf(list(ger,cities),
                 title = "Sketchy Map of Portugal", 
                 title_font = "20px Pristina", font = "20px Pristina", caption_font = "20px Pristina",
                 roughness = 2, 
                 bowing = 4, simplification = 3,
                 width = 800, height = 1200
)

ch <- rnaturalearth::ne_states(country = c("Portugal"), returnclass = "sf")
ch <- rnaturalearth::ne_states(country = c("United Kingdom", "Ireland"), returnclass = "sf")

xmin <- -2.2214980188385467
xmax <- -0.982789584587327
ymin <- 51.98679086431268
ymax <- 52.66327355170906
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
          "#ffed6f")
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
ch2
centros <- ch2 %>% 
  st_centroid() %>% 
  #st_intersection(bbox_sf) %>% 
  mutate(label = name, 
         size = 0)
cntr = cntr %>% filter(!name %in% c("Azores","Madeira") )
centros = centros %>% filter(!name %in% c("Azores","Madeira") )
roughsf::roughsf(list(centros,ger,cntr),
                 title = "Sketchy Map of Portugal", 
                 title_font = "20px Pristina", font = "20px Pristina", caption_font = "20px Pristina",
                 roughness = 2, 
                 bowing = 4, simplification = 3,
                 width = 800, height = 1200
)
