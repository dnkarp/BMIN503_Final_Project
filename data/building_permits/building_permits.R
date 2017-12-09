load<-function(){
  require(dplyr)
  building_permits_allyears <- read_csv("data/building_permits/building_permits_allyears.csv")
  permits.vars<-c("SurveyDate","FIPSState","FIPSCounty","x1ubUnits","x2ubUnits","x34ubUnits","x5pubUnits")
  permits.2014<-building_permits_allyears[building_permits_allyears$SurveyDate==2014,permits.vars]
  permits.2009<-building_permits_allyears[building_permits_allyears$SurveyDate==2009,permits.vars]
  permits.2014$totalunits.2014<-rowSums(permits.2014[,c("x1ubUnits","x2ubUnits","x34ubUnits","x5pubUnits")])
  permits.2014<-permits.2014 %>% mutate(StCnty=paste0(FIPSState,FIPSCounty))
  permits.2009$totalunits.2009<-rowSums(permits.2009[,c("x1ubUnits","x2ubUnits","x34ubUnits","x5pubUnits")])
  permits.2009<-permits.2009 %>% mutate(StCnty=paste0(FIPSState,FIPSCounty))
  permits.2014<-merge(permits.2014[,c("StCnty","totalunits.2014")],permits.2009[,c("StCnty","totalunits.2009")],by="StCnty",all.x=T)
  permits.2014 <- permits.2014 %>% mutate(permits.5yrchng = 100*round((totalunits.2014 - totalunits.2009) / totalunits.2009,3))
  buildingpermits <<- permits.2014
  }
load()
saveRDS(buildingpermits,file="data/building_permits/buildingpermits.RDa")
