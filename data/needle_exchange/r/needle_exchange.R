import_csv <- read.csv("~/Dropbox/courses/fall-2017/EPID-600/final_project/data/needle_exchange/output/bulk_output.txt", sep="\n", header=FALSE, stringsAsFactors=FALSE)
x<-import_csv
head(import_csv)

x$location<-ifelse(grepl("Get directions", x$V1) == TRUE, sapply(strsplit(sapply(strsplit(x$V1, "1="), "[",2), ">"), "[",1), sapply(strsplit(x$V1, "lead>"), "[",2))
x$noaddress<-ifelse(grepl("Get directions", x$V1) == TRUE,0,1)
x$place<-ifelse(x$noaddress==1,sapply(strsplit(x$location, ","), "[",1),ifelse(str_count(x$location,",")==2,sapply(strsplit(x$location, ","), "[",2),sapply(strsplit(x$location, ","), "[",3)))
x$state<-ifelse(x$noaddress==0,ifelse(str_count(x$location,",")==2,sapply(strsplit(sapply(strsplit(x$location, ","), "[",3), " "), "[",2),sapply(strsplit(sapply(strsplit(x$location, ","), "[",4), " "), "[",2)), sapply(strsplit(x$location, ","), "[",2))
x$ZIPcode<-ifelse(str_count(x$location,",")==2,substr(sapply(strsplit(sapply(strsplit(x$location, ","), "[",3), " "), "[",3),1,5),substr(sapply(strsplit(sapply(strsplit(x$location, ","), "[",4), " "), "[",3),1,5))
x$PObox<-ifelse(grepl("PO", x$V1) == TRUE,1,0)

#import_csv2 <- read.csv("~/Dropbox/courses/fall-2017/EPID-600/final_project/data/needle_exchange/format_addresses.csv", sep=",", header=TRUE, stringsAsFactors=FALSE)

geo_places<-geo.make(state="*", place = "*")
place_merge<- geo_join(geo_places, x, "name", "place")

us_places <- getCensusApi(sf1_2010_api, key=key, vars=c("P0010001"), region="for=place:*")

geo <- geocode(location = x$location, output="latlon", source="google")

x$lon <- geo$lon
x$lat <- geo$lat

x$no_xy <- is.na(x$lat) 
x$location2 <- ifelse(is.na(x$ZIPcode),paste(x$place, x$state,  sep=","),paste(x$place, x$state, x$ZIPcode, sep=","))
geo2 <- geocode(location = x$location2, output="latlon", source="google")

x$lon2 <- geo2$lon
x$lat2 <- geo2$lat

x$no_xy2 <- is.na(x$lat2) 

x$lon3 <- ifelse(!is.na(x$lon),x$lon,x$lon2)
x$lat3 <- ifelse(!is.na(x$lat),x$lat,x$lat2)

recode <- x[is.na(x$lat3),]
geo <- geocode(location = recode$location2, output="latlon", source="google")

recodelon4 <- geo$lon
recode$lat4 <- geo$lat

geo <- geocode(location = x$location, output="latlon", source="google")

x$lon <- geo$lon
x$lat <- geo$lat

x$no_xy <- is.na(x$lat) 
x$location2 <- ifelse(is.na(x$ZIPcode),paste(x$place, x$state,  sep=","),paste(x$place, x$state, x$ZIPcode, sep=","))
geo2 <- geocode(location = x[x$no_xy,]$location2, output="latlon", source="google")

x2 <- x[x$no_xy,]

x2$lon2 <- geo2$lon
x2$lat2 <- geo2$lat
x2$no_xy2 <- is.na(x2$lat2) 
geo3 <- geocode(location = x2[x2$no_xy2,]$location2, output="latlon", source="google")

x3 <- x2[x2$no_xy2,]

x3$lon3 <- geo3$lon
x3$lat3 <- geo3$lat
x3$no_xy3 <- is.na(x3$lat3) 

x3[x3$no_xy3,]

x3$location3 <- 
  ifelse(is.na(x3$ZIPcode),paste(
    sapply(str_split(x3$location2,","),"[",1),
    sapply(str_split(x3$location2,","),"[",2),sep=","),
    paste( sapply(str_split(x3$location2,","),"[",1),
           sapply(str_split(x3$location2,","),"[",2),
           sapply(str_split(x3$location2,","),"[",3),sep=","))

geo4 <- geocode(location = x3[x3$no_xy3,]$location3, output="latlon", source="google")

x4 <- x3[x3$no_xy3,]

x4$lon4 <- geo4$lon
x4$lat4 <- geo4$lat
x4$no_xy4 <- is.na(x4$lat4) 

geo4 <- geocode(location = x4[x4$no_xy4,]$location3, output="latlon", source="google", override_limit = TRUE)

