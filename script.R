## Load libraries
rm(list = ls())

library(jsonlite)
library(ggmap)
library(ggplot2)
library(dplyr)

## Get the coordinates
filename <- './data/merged.geojson'
data <- fromJSON(filename)

raw_coords <- data$features$geometry$coordinates
coords <- as.data.frame(raw_coords[2][[1]])
for (i in 2:length(raw_coords)) {
  new_coords <- as.data.frame(raw_coords[i][[1]])
  if (length(new_coords) == 2) {
    coords <- rbind(coords, new_coords)
  }
}
colnames(coords) <- c('lon', 'lat')

## Plot the map
map <- get_map(c(4, 52), zoom = 8, source = 'stamen', maptype = 'watercolor')               
ggmap(map) + geom_point(data = coords, aes(x = lon, y = lat), alpha = 0.5, color = 'red') + 
  theme(legend.position = 'right') + 
  labs(
    x = 'Longitude', 
    y = 'Latitude', 
    title = 'Location History')
