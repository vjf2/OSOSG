## Module 8 Map Plotting Template

install.packages("sf")
library(sf)

#Read in clean data

#Define the coordinate reference system


#Read in Map of DC neighborhoods from maps2.dcgis.dc.gov
dc <- st_read("raw_data/Neighborhood_Clusters-shp", 
              "Neighborhood_Clusters")

# Plot the map of DC
dev.new()
par(mar = c(1, 1, 1, 1))

plot(
  dc$geometry,
  col = "darkgrey",
  border = "white",
  main = "District of Columbia Bird Sightings"
)

plot(dc[46, "geometry"],
  add = TRUE,
  col = "#718BAE80",
  border = "white"
)

# Add your data


# Assign points to neighborhood and color accordingly 



