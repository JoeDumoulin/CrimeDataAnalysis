Spokane Crime Data
================

This walkthrough shows the steps needed to convert the Spokane Crime Data into a final dataset that is suitable for analysis. The R code is based on the `basecode.R` script by @kmigori.

Raw data files
--------------

The raw data is contained in two .zip archives - Crime.zip and Neighborhood.zip. The files can be downloaded manually using these links:

<https://static.spokanecity.org/download/gistransfer/pubdata/Crime.zip>
<https://static.spokanecity.org/download/gistransfer/pubdata/Neighborhood.zip>

Alternatively, you can enter the following into the R console.

``` r
library(httr)  
crime_url <- "https://static.spokanecity.org/download/gistransfer/pubdata/Crime.zip"  
neighborhood_url <- "https://static.spokanecity.org/download/gistransfer/pubdata/Neighborhood.zip"  

GET(crime_url, write_disk("Data/Crime.zip", overwrite=TRUE))  
GET(neighborhood_url, write_disk("Data/Neighborhood.zip", overwrite=TRUE))  
```

Either way, the .zip files should be saved in the /Data folder in the repository's root directory.

Inspect the .zip archive
------------------------

The resulting .zip archives can be inspected and unzipped manually, or at the R console using this code.

``` r
unzip("Data/Crime.zip", list = TRUE)
unzip("Data/Neighborhood.zip", list = TRUE)

unzip("Data/Crime.zip", exdir = "Data/Crime")
unzip("Data/Neighborhood.zip", exdir = "Data/Neighborhood")
```

            Name   Length                Date
    1  Crime.CPG        5 2016-08-10 15:21:00
    2  Crime.dbf 27908183 2016-08-10 15:21:00
    3 Crime.docx    23962 2016-08-10 15:21:00
    4  Crime.prj      728 2016-08-10 15:19:00
    5  Crime.sbn  1993380 2016-08-10 15:21:00
    6  Crime.sbx    25732 2016-08-10 15:21:00
    7  Crime.shp  6057648 2016-08-10 15:21:00
    8  Crime.shx  1730828 2016-08-10 15:21:00

                   Name Length                Date
    1  Neighborhood.cpg      5 2016-08-10 15:07:00
    2  Neighborhood.dbf   2342 2016-08-10 15:14:00
    3 Neighborhood.docx  20664 2016-08-10 15:21:00
    4  Neighborhood.prj    728 2016-08-10 15:07:00
    5  Neighborhood.sbn    412 2016-08-10 15:07:00
    6  Neighborhood.sbx    148 2016-08-10 15:07:00
    7  Neighborhood.shp 426676 2016-08-10 15:07:00
    8  Neighborhood.shx    324 2016-08-10 15:07:00

Load the data
-------------

This is where Kristian's code comes into play. It has been modified slightly to account for the data files being saved in the /Data directory.

``` r
#this is an R script to import Spokane City crime data, merge it with Neighborhoods, and export it as a flat file
rm(list=ls())
library(rgdal)
library(maptools)

#reading in Crime shapefile
Crime=readOGR(dsn="Data/Crime",layer="Crime")
#reading in Neighborhood shapefile
Neighborhood=readOGR(dsn="Data/Neighborhood",layer="Neighborhood")

#Extracting Neighborhood designation for each point by location
Crime_byNeighborhood=over(Crime,Neighborhood)
#appending rest of data to each point
Crime_byNeighborhood=spCbind(Crime,Crime_byNeighborhood)
#saving resulting dataset as csv
write.csv(file="Data/Spokane_CrimeData_Neighborhood.csv",Crime_byNeighborhood)
```
