#this is an R script to import Spokane City crime data, merge it with Neighborhoods, and export it as a flat file
rm(list=ls())
library(rgdal)
library(maptools)

#reading in Crime shapefile
Crime=readOGR(dsn="Crime",layer="Crime")
#reading in Neighborhood shapefile
Neighborhood=readOGR(dsn="Neighborhood",layer="Neighborhood")

#Extracting Neighborhood designation for each point by location
Crime_byNeighborhood=over(Crime,Neighborhood)
#appending rest of data to each point
Crime_byNeighborhood=spCbind(Crime,Crime_byNeighborhood)
#saving resulting dataset as csv
write.csv(file="/Data/Spokane_CrimeData_Neighborhood.csv",Crime_byNeighborhood)
