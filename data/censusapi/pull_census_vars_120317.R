#load libraries
library(data.table)
library(dplyr)
library(tidycensus)
library(purrr)
library(acs)

#set working directory
setwd("~/Dropbox/courses/fall-2017/EPID-600/final_project/data")

#load data
dt.allyears <- readRDS(file="multiple_cause_of_death/mcod_95-15.RDa")

#set api key
census_api_key("e7051ec917473383ba64a0c65d7090fa5cc10cf4")
api.key.install(key="e7051ec917473383ba64a0c65d7090fa5cc10cf4")

#get census geography
geo_counties <- geo.make(state="*", county="*")

#get var lists
#https://www.socialexplorer.com/data/ACS2015_5yr/metadata/?ds=ACS15_5yr
dem2015.pop.vlist<-acs.lookup(endyear=2015, span=5, table.number = "B01003")
dem2015.sexbyage.vlist<-acs.lookup(endyear=2015, span=5, table.number = "B01001")
dem2015.race.vlist<-acs.lookup(endyear=2015, span=5, table.number = "B02001")
dem2015.hisp.vlist<-acs.lookup(endyear=2015, span=5, table.number = "B03003")
#-->use same labels to pull 2010 acs

#-->use 2010 data for 2005

#https://www.socialexplorer.com/data/C2000/metadata/?ds=SF1
#P1 	Total Population
#P7 	Race
#P11 	Hispanic Or Latino
#P12 	Sex By Age
dem2000.pop.vlist<-acs.lookup(endyear=2000, dataset="sf1", table.number = "P1")
dem2000.race.vlist<-acs.lookup(endyear=2000, dataset="sf1", table.number = "P7")
dem2000.hisp.vlist<-acs.lookup(endyear=2000, dataset="sf1", table.number = "P11")
dem2000.sexbyage.vlist<-acs.lookup(endyear=2000, dataset="sf1", table.number = "P12")

#-->use 2000 data for 1995

#pull data
#2015 census variables----
dem2015.varlist <- c("B01003_001","B01001_002","B01001_026","B02001_002","B02001_003","B03003_003")
dem2015.colnames <- c("total.pop","total.male","total.female","race.white","race.black","hispanic")
dem2015.county <- acs.fetch(endyear=2015, dataset="acs", span=5, variable=dem2015.varlist, geography = geo_counties)

#2010 census variables---- (same vars as 2015)
dem2010.county <- acs.fetch(endyear=2010, dataset="acs", span=5, variable=dem2015.varlist, geography = geo_counties)
dem2010.colnames <- dem2015.colnames

#2005 census variables---- (use 2010 data, or avg 2000 + 2010)

#2000 census variables----
dem2000.varlist <- c("P001001","P012002","P012026","P007002","P007003","P011001")
dem2000.colnames <- c("total.pop","total.male","total.female","race.white","race.black","hispanic")
dem2000.county <- acs.fetch(endyear=2000, dataset="sf1", variable=dem2000.varlist, geography = geo_counties)

#1995 census variables---- (use 1990 data)
#dem1990.varlist <- c("P001001")
#dem2000.colnames <- c("total.pop","total.male","total.female","race.white","race.black","hispanic")
#dem1990.county <- acs.fetch(endyear=1990, dataset="sf1", variable=dem1990.varlist, geography = geo_counties)

#1995 census variables---- (use 2000 data, or avg 2000 + 1990)

#clean census data

#view var names & attributes
names(attributes(dem2015.county))
attr(dem2015.county, "acs.colnames")

#extract estimates
dem2015.county.extract <- data.table(dem2015.county@geography[,2:3],dem2015.county@estimate)
dem2010.county.extract <- data.table(dem2010.county@geography[,2:3],dem2010.county@estimate)
dem2000.county.extract <- data.table(dem2000.county@geography[,2:3],dem2000.county@estimate)

#view var names & attributes
names(attributes(dem2015.county.extract))
attr(dem2015.county.extract, "names")

#set col names
colnames(dem2015.county.extract)[3:8] <- dem2015.colnames
colnames(dem2010.county.extract)[3:8] <- dem2010.colnames
colnames(dem2000.county.extract)[3:8] <- dem2000.colnames

#define clean function
clean.census <- function(x, y){
  clean <- x %>%
    mutate(year = y) %>%
    mutate(stateFIPS = str_pad(state,2,side=c("left"),pad="0")) %>%
    mutate(countyFIPS = paste0(stateFIPS,county))
  return(data.table(clean)[, c("state","county") := NULL])
}

#define state group function
state.census <- function(x){
  state <- x %>%
    group_by(stateFIPS,year) %>%
    summarise_at(c("total.pop","total.male","total.female","race.white","race.black","hispanic"),funs(sum))
  return(state)
}

#run clean on county data
dem2015.county.clean <- clean.census(dem2015.county.extract, 2015)
dem2010.county.clean <- clean.census(dem2010.county.extract, 2010)
dem2000.county.clean <- clean.census(dem2000.county.extract, 2000)

dem2005.county.clean <- clean.census(dem2010.county.extract, 2005) #set up 2005 dataset using 2010 data
dem1995.county.clean <- clean.census(dem2000.county.extract, 1995) #set up 1995 dataset using 2000 data

#merge all data
dem.county.allyears <- rbind(dem2015.county.clean
                             ,dem2010.county.clean 
                             ,dem2005.county.clean
                             ,dem2000.county.clean
                             ,dem1995.county.clean)

#run state collapse
dem.state.allyears <- state.census(dem.county.allyears)

#save/export data
saveRDS(dem.county.allyears, file="censusapi/census_95-15_countydemographics.RDa")
saveRDS(dem.state.allyears, file="censusapi/census_95-15_statedemographics.RDa")
saveRDS(dem2015.county.clean, file="censusapi/census_2015_countydemographics.RDa")
saveRDS(dem2010.county.clean, file="censusapi/census_2010_countydemographics.RDa")
saveRDS(dem2005.county.clean, file="censusapi/census_2005_countydemographics.RDa")
saveRDS(dem2000.county.clean, file="censusapi/census_2000_countydemographics.RDa")
saveRDS(dem1995.county.clean, file="censusapi/census_1995_countydemographics.RDa")

#save environment
save.image("~/Dropbox/courses/fall-2017/EPID-600/final_project/data/censusapi/pull_census_vars_120317.RData")


