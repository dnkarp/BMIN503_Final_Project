load<-function(){
  county_crime_census_00_12_final <- read_csv("data/crime/county_crime_census_00_12_final.csv")

crime.2012.import <- county_crime_census_00_12_final[county_crime_census_00_12_final$year==2012,c("year","fips5","murder","rape","robbery","burglary","larceny","auto_theft","total_crime","tot_pop")]

data.frame(str(crime.2012.import))

crime <<- crime.2012.import %>%
  mutate(fips5=str_pad(fips5,5,side=c("left"),pad = "0")) %>%
  mutate(crime.2012.rt = total_crime / tot_pop) %>%
  mutate(murder.2012.rt = murder / tot_pop) %>%
  mutate(rape.2012.rt = rape / tot_pop) %>%
  mutate(robbery.2012.rt = robbery / tot_pop) %>%
  mutate(burglary.2012.rt = burglary / tot_pop) %>%
  mutate(larceny.2012.rt = larceny / tot_pop) %>%
  mutate(autotheft.2012.rt = auto_theft / tot_pop)
  
}
load()
saveRDS(crime,file="data/crime/crime.RDa")

