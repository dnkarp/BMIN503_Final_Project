load<-function(){
  require(haven)
  merged_data_files_v13 <- read_dta("../local_data/from_firearm_study/merged_data_files_v13.dta")
  
  mortality.2012.import <- merged_data_files_v13[,c(colnames(merged_data_files_v13[1:7]),colnames(merged_data_files_v13[37]))]
  
  data.frame(str(mortality.2012.import))
  
  setDT(mortality.2012.import)
  mortality.2012.suppress <- mortality.2012.import[(suicide_gun_count_>=10 & suicide_nongun_count_ >= 10 & homicide_gun_count_ >=10 & homicide_nongun_count_ >=10),]
  mortality <<- mortality.2012.suppress %>%
    mutate(suicide.2012.rt = (suicide_gun_count_ + suicide_nongun_count_) / T001_001) %>%
    mutate(homicide.2012.rt = (homicide_gun_count_ + homicide_nongun_count_) / T001_001) %>%
    mutate(homcide.firearm.2012.rt = homicide_gun_count_ / T001_001)
  
}
load()
saveRDS(mortality,file="data/mortality/mortality.RDa")
