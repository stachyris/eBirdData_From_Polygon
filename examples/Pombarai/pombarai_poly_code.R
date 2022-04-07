library(sf)
library(auk)
library(dplyr)
setwd("D:/IISER_Tirupati/Pombarai bird list")
poly <- read_sf("Pombarai-polygon.shp")
f_out <- ("pombarai.txt")
auk_ebd("ebd_IN-TN-DI_prv_relFeb-2022/ebd_IN-TN-DI_prv_relFeb-2022.txt") %>%
  auk_bbox(poly) %>%
  auk_complete() %>%
  auk_filter(f_out)
ebd <- read_ebd("pombarai.txt")
ebd_sf <- ebd %>%
  select(longitude, latitude) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
poly_ll <- st_transform(poly, crs = st_crs(ebd_sf))
in_poly <- st_within(ebd_sf, poly_ll, sparse = FALSE)
ebd_in_poly <- ebd[in_poly[, 1], ]

#visualize the points clipped 
par(mar = c(0,0,0,0))
plot(poly %>% st_geometry(), col ="yellow", border = NA)
plot(ebd_sf, col = "black", pch = 19, cex = 0.5, add = TRUE)
plot(ebd_sf[in_poly[, 1], ],
     col = "red", pch = 19, cex = 0.5, 
     add = TRUE)
