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
dem2015.pop.vlist<-data.frame(acs.lookup(endyear=2015, span=5, table.number = "B01003")@results)
dem2015.sexbyage.vlist<-data.frame(acs.lookup(endyear=2015, span=5, table.number = "B01001")@results)
dem2015.race.vlist<-data.frame(acs.lookup(endyear=2015, span=5, table.number = "B02001")@results)
dem2015.hisp.vlist<-data.frame(acs.lookup(endyear=2015, span=5, table.number = "B03003")@results)
#-->use same labels to pull 2010 acs

#-->use 2010 data for 2005

#https://www.socialexplorer.com/data/C2000/metadata/?ds=SF1
#P1 	Total Population
#P7 	Race
#P11 	Hispanic Or Latino
#P12 	Sex By Age
dem2000.pop.vlist<-data.frame(acs.lookup(endyear=2000, dataset="sf1", table.number = "P1")@results)
dem2000.race.vlist<-data.frame(acs.lookup(endyear=2000, dataset="sf1", table.number = "P7")@results)
dem2000.hisp.vlist<-data.frame(acs.lookup(endyear=2000, dataset="sf1", table.number = "P11")@results)
dem2000.sexbyage.vlist<-data.frame(acs.lookup(endyear=2000, dataset="sf1", table.number = "P12")@results)

#-->use 2000 data for 1995

#pull data
#2015 census variables----
dem2015.varlist <- c("B01003_001","B01001_002","B01001_026","B02001_002","B02001_003","B03003_003")
dem2015.colnames <- c("total.pop","total.male","total.female","race.white","race.black","hispanic")
dem2015.county <- acs.fetch(endyear=2015, dataset="acs", span=5, variable=dem2015.varlist, geography = geo_counties)

age2015.county <- acs.fetch(endyear=2015, dataset="acs", span=5, table.number = "B01001", geography = geo_counties)

#2010 census variables---- (same vars as 2015)
dem2010.county <- acs.fetch(endyear=2010, dataset="acs", span=5, variable=dem2015.varlist, geography = geo_counties)
dem2010.colnames <- dem2015.colnames

age2010.county <- acs.fetch(endyear=2010, dataset="acs", span=5, table.number = "B01001", geography = geo_counties)

#2005 census variables---- (use 2010 data, or avg 2000 + 2010)

#2000 census variables----
dem2000.varlist <- c("P001001","P012002","P012026","P007002","P007003","P011001")
dem2000.colnames <- c("total.pop","total.male","total.female","race.white","race.black","hispanic")
dem2000.county <- acs.fetch(endyear=2000, dataset="sf1", variable=dem2000.varlist, geography = geo_counties)

age2000.county <- acs.fetch(endyear=2000, dataset="sf1", table.number="P12", geography = geo_counties)

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

age2015.county.extract <- data.table(age2015.county@geography[,2:3],age2015.county@estimate)
age2010.county.extract <- data.table(age2010.county@geography[,2:3],age2010.county@estimate)
age2000.county.extract <- data.table(age2000.county@geography[,2:3],age2000.county@estimate)

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
    summarise_at(c("total.pop","total.male","total.female","race.white","race.black","hispanic","age.18under", "age.1824", "age.2534", "age.3554", "age.5584", "age.85over"),funs(sum))
  return(state)
}

#define age group functions

#acs data (2010 + 2015)
sumagegroups.acs <- function(x,y){
  dt <- x
  dt$age.18under <- dt %>%
    mutate(sum = rowSums(.[,c("B01001_003","B01001_004","B01001_005","B01001_006","B01001_027","B01001_028","B01001_029","B01001_030")])) %>%
    .$sum
  dt$age.1824 <- dt %>%
    mutate(sum = rowSums(.[,c("B01001_007","B01001_008","B01001_009","B01001_010","B01001_031","B01001_032","B01001_033","B01001_034")])) %>%
    .$sum
  dt$age.2534 <- dt %>%
    mutate(sum = rowSums(.[,c("B01001_011","B01001_012","B01001_035","B01001_036")])) %>%
    .$sum
  dt$age.3554 <- dt %>%
    mutate(sum = rowSums(.[,c("B01001_013","B01001_014","B01001_015","B01001_016","B01001_037","B01001_038","B01001_039","B01001_040")])) %>%
    .$sum
  dt$age.5584 <- dt %>%
    mutate(sum = rowSums(.[,c("B01001_017","B01001_018","B01001_019","B01001_020","B01001_021","B01001_022","B01001_023","B01001_024","B01001_041","B01001_042","B01001_043","B01001_044","B01001_045","B01001_046","B01001_047","B01001_048")])) %>%
    .$sum
  dt$age.85over <- dt %>%
    mutate(sum = rowSums(.[,c("B01001_025","B01001_049")])) %>%
    .$sum
  dt$age.total <- dt %>%
    mutate(sum = rowSums(.[,c("B01001_002","B01001_026")])) %>%
    .$sum
  dt <- dt %>% select(c("state","county"),starts_with("age")) %>%
    mutate(year = y) %>%
    mutate(stateFIPS = str_pad(state,2,side=c("left"),pad="0")) %>%
    mutate(countyFIPS = paste0(stateFIPS,county))
  return(data.table(dt)[, c("state","county") := NULL])
}

# census data (2000)
sumagegroups.census <- function(x,y){
  dt <- x
  dt$age.18under <- dt %>%
    mutate(sum = rowSums(.[,c("P012003","P012004","P012005","P012006","P012027","P012028","P012029","P012030")])) %>%
    .$sum
  dt$age.1824 <- dt %>%
    mutate(sum = rowSums(.[,c("P012007","P012008","P012009","P012010","P012031","P012032","P012033","P012034")])) %>%
    .$sum
  dt$age.2534 <- dt %>%
    mutate(sum = rowSums(.[,c("P012011","P012012","P012035","P012036")])) %>%
    .$sum
  dt$age.3554 <- dt %>%
    mutate(sum = rowSums(.[,c("P012013","P012014","P012015","P012016","P012037","P012038","P012039","P012040")])) %>%
    .$sum
  dt$age.5584 <- dt %>%
    mutate(sum = rowSums(.[,c("P012017","P012018","P012019","P012020","P012021","P012022","P012023","P012024","P012041","P012042","P012043","P012044","P012045","P012046","P012047","P012048")])) %>%
    .$sum
  dt$age.85over <- dt %>%
    mutate(sum = rowSums(.[,c("P012025","P012049")])) %>%
    .$sum
  dt$age.total <- dt %>%
    mutate(sum = rowSums(.[,c("P012002","P012026")])) %>%
    .$sum
  dt <- dt %>% select(c("state","county"),starts_with("age")) %>%
    mutate(year = y) %>%
    mutate(stateFIPS = str_pad(state,2,side=c("left"),pad="0")) %>%
    mutate(countyFIPS = paste0(stateFIPS,county))
  return(data.table(dt)[, c("state","county") := NULL])
  }

#run clean on county data
dem2015.county.clean <- clean.census(dem2015.county.extract, 2015)
dem2010.county.clean <- clean.census(dem2010.county.extract, 2010)
dem2000.county.clean <- clean.census(dem2000.county.extract, 2000)

dem2005.county.clean <- clean.census(dem2010.county.extract, 2005) #set up 2005 dataset using 2010 data
dem1995.county.clean <- clean.census(dem2000.county.extract, 1995) #set up 1995 dataset using 2000 data

age2015.county.clean <- sumagegroups.acs(age2015.county.extract, 2015)
age2010.county.clean <- sumagegroups.acs(age2010.county.extract, 2010)
age2000.county.clean <- sumagegroups.census(age2000.county.extract, 2000)

age2005.county.clean <- sumagegroups.acs(age2010.county.extract, 2005) #set up 2005 dataset using 2010 data
age1995.county.clean <- sumagegroups.census(age2000.county.extract, 1995) #set up 1995 dataset using 2000 data

#merge dem with age datasets
dem2015.county.full <- merge(dem2015.county.clean, age2015.county.clean[, c("year","stateFIPS","age.total") := NULL], by="countyFIPS")
dem2010.county.full <- merge(dem2010.county.clean, age2010.county.clean[, c("year","stateFIPS","age.total") := NULL], by="countyFIPS")
dem2000.county.full <- merge(dem2000.county.clean, age2000.county.clean[, c("year","stateFIPS","age.total") := NULL], by="countyFIPS")

dem2005.county.full <- merge(dem2005.county.clean, age2005.county.clean[, c("year","stateFIPS","age.total") := NULL], by="countyFIPS")
dem1995.county.full <- merge(dem1995.county.clean, age1995.county.clean[, c("year","stateFIPS","age.total") := NULL], by="countyFIPS")

#append all data
dem.county.allyears <- rbind(dem2015.county.full
                             ,dem2010.county.full 
                             ,dem2005.county.full
                             ,dem2000.county.full
                             ,dem1995.county.full)

#run state collapse
dem.state.allyears <- state.census(dem.county.allyears)

#save/export data
saveRDS(dem.county.allyears, file="censusapi/census_95-15_countydemographics.RDa")
saveRDS(dem.state.allyears, file="censusapi/census_95-15_statedemographics.RDa")
saveRDS(dem2015.county.full, file="censusapi/census_2015_countydemographics.RDa")
saveRDS(dem2010.county.full, file="censusapi/census_2010_countydemographics.RDa")
saveRDS(dem2005.county.full, file="censusapi/census_2005_countydemographics.RDa")
saveRDS(dem2000.county.full, file="censusapi/census_2000_countydemographics.RDa")
saveRDS(dem1995.county.full, file="censusapi/census_1995_countydemographics.RDa")

#save environment
save.image("~/Dropbox/courses/fall-2017/EPID-600/final_project/data/censusapi/pull_census_vars_120417.RData")


