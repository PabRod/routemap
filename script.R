## Load libraries
rm(list = ls())

library(ggmap)
library(maps)
library(ggplot2)
library(dplyr)

## Get the coordinates
filename <- './data/merged.geojson'
source('pathGeoJson.R')
path_coords <- pathGeoJson(filename)

## Get the cities
cities_db <- filter(world.cities, country.etc == 'Netherlands' | country.etc == 'Belgium')
cities_selection <- filter(cities_db, name %in% c('Amsterdam', 'Brielle', 'Utrecht', 'Alkmaar', 'Middelburg', 'Dordrecht', 'Wageningen', 'Gent', 'Ostend', 'Brugge'))

## Plot the map
map <- get_map(c(4.35, 52), zoom = 7, source = 'stamen', maptype = 'watercolor')               
p <- ggmap(map) 
p <- p + geom_point(data = path_coords, aes(x = lon, y = lat), alpha = 0.5, color = 'red')
p <- p + theme(legend.position = 'right') 
p <- p + labs(x = 'Longitude', y = 'Latitude') 
p <- p + geom_text(data = cities_selection, aes(x=long, y=lat, label=name, family='serif', size=5), check_overlap = TRUE, angle = 30, show.legend = FALSE)

