## Assignment 1 Map Plotting Template

library(sf)

clean_data <- read.csv("output/my_clean_data.csv")

plotting_data <- st_as_sf(clean_data, coords = c("Longitude", "Latitude"), crs = 4326)

# Map of DC neighborhoods from maps2.dcgis.dc.gov
dc <- st_read("raw_data/Neighborhood_Clusters-shp", "Neighborhood_Clusters")

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

plot(
  plotting_data$geometry,
  add = TRUE,
  pch = 16,
  cex = 0.25
)

# Save your plot

#Plot by color
bird_int <- st_join(plotting_data, dc, join = st_intersects)

table(bird_int$NBH_NAMES) |> View()

plot(
  bird_int$geometry,
  add = TRUE,
  pch = 16,
  col = hcl.colors(n = 15)[as.factor(bird_int$NAME)],
  cex = 0.25
)

