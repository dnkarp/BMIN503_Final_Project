load<-function(){
require(haven)
merged_data_files_v13 <- read_dta("data/demographics/merged_data_files_v13.dta")

demographics.2012.import <- merged_data_files_v13[,c("year","fips",colnames(merged_data_files_v13[37:89]))]

data.frame(str(demographics.2012.import))

demographics <<- demographics.2012.import %>%
  mutate(totpop.2012 = T001_001) %>%
  mutate(popdens.2012 = T002_002) %>%
  mutate(male.2012 = T004_002) %>%
  mutate(female.2012 = T004_003) %>%
  mutate(male.2012.pct = male.2012 / totpop.2012) %>%
  mutate(female.2012.pct = female.2012 / totpop.2012) %>%
  mutate(age.under18.2012 = T007A004 + T007A005) %>%
  mutate(age.18to25.2012 = T007A006 - age.under18.2012) %>%
  mutate(age.25to55.2012 = T007A009 - T007A006) %>%
  mutate(age.55over.2012 = totpop.2012 - T007A009) %>%
  mutate(age.under18.2012.pct = age.under18.2012 / totpop.2012)%>%
  mutate(age.18to25.2012.pct = age.18to25.2012 / totpop.2012)%>%
  mutate(age.25to55.2012.pct = age.25to55.2012 / totpop.2012)%>%
  mutate(age.55over.2012.pct = age.55over.2012 / totpop.2012)%>%
  mutate(age.mdn.2012 = T012_001)%>%
  mutate(race.wht.2012 = T013_002)%>%
  mutate(race.blk.2012 = T013_003)%>%
  mutate(race.asn.2012 = T013_005)%>%
  mutate(ethnicity.2012 = T014_010)%>%
  mutate(households.total.2012 = T017_001)%>%
  mutate(households.singlefemale.2012 = T017_006)%>%
  mutate(edu.male.nohs.2012.pct = T151_002 / T151_001)%>%
  mutate(edu.female.nohs.2012.pct = T151_002 / T152_001)%>%
  mutate(edu.nohs.2012.pct = (T151_002 + T151_002) / (T151_001 + T152_001)) %>%
  mutate(edu.hsdropout.2012.pct = T030_002 / T030_001)%>%
  mutate(unemployment.2012.pct = T033_006 / T033_002)%>%
  mutate(notinlaborforce.male.2012.pct = T033_007 / T033_001) %>%
  mutate(unemployment.male.2012.pct = T034_006 / T034_002)%>%
  mutate(notinlaborforce.2012.pct = T034_007 / T034_001)%>%
  mutate(hhinc.lt1x.2012.pct = T056A004 / T056A001)%>%
  mutate(hhinc.lt2x.2012.pct = T056A008 / T056A001)%>%
  mutate(hhinc.mdn.2012 = T057_001)%>%
  mutate(vacancy.2012.pct = T095_003 / T095_001)%>%
  mutate(pov.lt2x.2012.pct = (T117_001 - T117_007) / T117_001)%>%
  mutate(foreign.2012.pct = T117_001 / totpop.2012) %>%
  mutate(foreign.since2010.2012.pct = T134_002 / T134_001)%>%
  mutate(foreign.since2000.2012.pctchng = (T134_002 - T134_003) / T134_003) %>%
  mutate(insurance.2012.pct = T145_002 / T145_001)

}
load()
saveRDS(demographics,file="data/demographics/demographics.Rda")
