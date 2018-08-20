pathGeoJson <- function(filename) {
  
  ## Load required libraries
  library(jsonlite)
  
  ## Get the raw data
  data <- fromJSON(filename)
  
  ## Extract the coordinates
  raw_coords <- data$features$geometry$coordinates
  
  ## Create a dataframe with the coordinates
  path_coords_df <- data.frame(V1 = double(), V2 = double())
  for (i in 1:length(raw_coords)) {
    if (data$features$geometry$type[i] == 'LineString') { # Append only LineString objects
      path_coords_df <- rbind(path_coords_df, as.data.frame(raw_coords[i][[1]]))
    }
  }
  colnames(path_coords_df) <- c('lon', 'lat')
  
  return(path_coords_df)
}