## Load libraries
rm(list = ls())

library(jsonlite)
library(ggmap)
library(maps)
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

## Get the cities
nl.cities <- filter(world.cities, country.etc == 'Netherlands')
nl.cities.big <- filter(nl.cities, pop > 200000)
nl.selection <- filter(nl.cities, name %in% c('Amsterdam', 'Rotterdam', 'Utrecht', 'Alkmaar', 'Middelburg', 'Dordrecht', 'Wageningen'))
be.cities <- filter(world.cities, country.etc == 'Belgium')
be.cities.big <- filter(be.cities, pop > 150000)
be.selection <- filter(be.cities, name %in% c('Gent', 'Ostend', 'Brugge'))

## Plot the map
map <- get_map(c(4.35, 52), zoom = 8, source = 'stamen', maptype = 'watercolor')               
p <- ggmap(map) 
p <- p + geom_point(data = coords, aes(x = lon, y = lat), alpha = 0.5, color = 'red')
p <- p + theme(legend.position = 'right') 
p <- p + labs(x = 'Longitude', y = 'Latitude', title = 'Location History') 
p <- p + geom_point(data = nl.selection, aes(x = long, y =lat), alpha = 0.7, show.legend = FALSE)
p <- p + geom_point(data = be.selection, aes(x = long, y =lat), alpha = 0.7, show.legend = FALSE)
p <- p + geom_text(data = nl.selection, aes(x=long, y=lat, label=name, family='serif', size=5), check_overlap = TRUE, angle = 30, show.legend = FALSE)
p <- p + geom_text(data = be.selection, aes(x=long, y=lat, label=name, family='serif', size=5), check_overlap = TRUE, angle = 30, show.legend = FALSE)

##
p

