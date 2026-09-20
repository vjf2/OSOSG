##################################
#OSOS-G Module 8
#Branch and Batch Data Processing
##################################

#Read in and clean each file separately

#############
#Nat Geo Data
#############
nat_geo <- read.csv('raw_data/nat_geo_data.csv', row.names = 1)

head(nat_geo)

#Check if date already in default format and define/convert
nat_geo$Date <- as.Date(nat_geo$Date)

#Look at range of coordinate values
summary(nat_geo$Longitude)
nat_geo[which(nat_geo$Longitude >= 0), ]

#Three points appear to have the lat long numbers switched
#These can either be removed or swapped
swap <- nat_geo[which(nat_geo$Longitude >= 0), ]

nat_geo$Latitude[which(nat_geo$Longitude >= 0)] <- swap$Longitude
nat_geo$Longitude[which(nat_geo$Longitude >= 0)] <- swap$Latitude

#############
#GW Data
#############

gw <- read.csv('raw_data/gw_data.csv', row.names = 1)

#Check if date already in default format and define/convert
gw$Date <- as.Date(gw$Date, format = "%d-%b-%y")

#Convert longitude to decimal minutes
long1 <- unlist(lapply(strsplit(gw$Longitude, "°"), "[[", 1))
long1 <- as.numeric(long1) *-1
long2 <- unlist(lapply(strsplit(gw$Longitude, "°"), "[[", 2))
long2 <- gsub("'W", "", long2)
long2 <- as.numeric(long2)
long2 <- long2 / 60

gw$long <- long1 - round(long2, 5)

#Convert latitude to decimal minutes
lat1 <- unlist(lapply(strsplit(gw$Latitude, "°"), "[[", 1))
lat1 <- as.numeric(lat1)
lat2 <- unlist(lapply(strsplit(gw$Latitude, "°"), "[[", 2))
lat2 <- gsub("'N", "", lat2)
lat2 <- as.numeric(lat2)
lat2 <- lat2 / 60

gw$lat <- lat1 + round(lat2, 5)

#Maybe we want to write our own function

#Example function
my_function <- function() { 
  print("Hello World!")
}

my_function()

#Functions take arguments

my_function <- function(name) { 
  print(paste("Hello", name))
}

my_function("Vivienne")

#Arguments can take default values
my_function <- function(name = "You") { 
  print(paste("Hello", name))
}

#Example with multiple arguments
greeting <- function(name = "You", time = "morning") { 
  if(time == "morning"){
  print(paste("Good morning", name))}
  else if( time == "afternoon"){
    print(paste("Good afternoon", name))}
  else if( time == "night"){
    print(paste("Good night", name))}
}

greeting()
greeting("Vivienne", "morning")
greeting("afternoon", "Vivienne") # doesn't work 
greeting(time = "afternoon", name = "Vivienne") # works 

#Function to convert decimal minutes to decimal degrees
min_to_dec_deg <- function(coords){
  coord1 <- unlist(lapply(strsplit(coords, "°"), "[[", 1))
  coord2 <- unlist(lapply(strsplit(coords, "°"), "[[", 2))
  direction <- substr(coord2, nchar(coord2), nchar(coord2))
  num_dir <- ifelse(direction %in% c("S", "W"), -1, 1)
  coord2 <- gsub("'[W|N|S|E]", "", coord2)
  coord2 <- as.numeric(coord2)
  coord1 <- as.numeric(coord1) * num_dir
  coord2 <- coord2 / 60 * num_dir
  
  dec_deg <- coord1+coord2
  
return(dec_deg)
  
  }

gw$long <- min_to_dec_deg(gw$Longitude)
gw$lat <- min_to_dec_deg(gw$Latitude)

gw <- gw[, c("long", "lat", "Date", "Survey_Type")]
names(gw)[1:2] <- c("Longitude", "Latitude")

#############
#audubon Data
#############

audubon <- read.csv('raw_data/audubon_data.csv', row.names = 1)

audubon$Date <- as.Date(audubon$Date, format = "%m/%d/%y")

#Replace N/W with +/-
audubon$Longitude <- gsub("W", "-", audubon$Longitude)
audubon$Latitude <- gsub("N", "", audubon$Latitude)

#############
#Combine data
#############

all_data <- rbind(nat_geo, gw, audubon)

#Select transects
all_data <- all_data[grepl("transect", all_data$Survey_Type, ignore.case = TRUE), ]
all_data <- all_data[!grepl("nontransect", all_data$Survey_Type), ]

#Select dates after Jan 1, 2010
all_data <- all_data[all_data$Date >= "2010-01-01", ]

#Write file
write.csv(all_data, "output/my_clean_data.csv")

#Style code 

#show styler 
install.packages("styler")
library(styler)

styler::style_file()

