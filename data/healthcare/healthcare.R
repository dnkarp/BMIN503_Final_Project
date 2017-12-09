load<-function(){
require(haven)
merged_data_files_v13 <- read_dta("../local_data/from_firearm_study/merged_data_files_v13.dta")

healthcare.2012.import <- merged_data_files_v13[,c(colnames(merged_data_files_v13[6:35]),"T001_001","T002_003")]

data.frame(str(healthcare.2012.import))

healthcare <<- healthcare.2012.import %>%
  mutate(healthcare.payroll.2012 = stgfacsrprtpayrollexpenses) %>%
  mutate(healthcare.emdepts.2012.dens = stghospwemergencydepartment / T002_003) %>%
  mutate(healthcare.trauma.2012.dens = stghospwcertifiedtraumacntr / T002_003) %>%
  mutate(healthcare.hosp.2012.dens = totalnumberhospitals / T002_003) %>%
  mutate(healthcare.adm.2012.rt = tothospitaladmissions / T001_001) %>%
  mutate(healthcare.hosp.highvol.2012.pct = (stgenhosp300beds + stgenhosp200299beds) / totalnumberhospitals) %>%
  mutate(healthcare.hosp.midvol.2012.pct = (stgenhosp100199beds + stgenhosp050099beds) / totalnumberhospitals) %>%
  mutate(healthcare.hosp.lowvol.2012.pct = (stgenhosp006049beds) / totalnumberhospitals) %>%
  mutate(healthcare.beds.2012.rt = totalhospitalbeds / T001_001) %>%
  mutate(healthcare.mds.2012.rt = mdsnonfederaltotalactive / T001_001) %>%
  mutate(healthcare.mds.em.2012.rt = mdsnfemergencymedtotal / T001_001) %>%
  mutate(healthcare.mds.rsrch.2012.rt = mdsnfemergencymedresearch / T001_001) %>%
  mutate(healthcare.inptdays.2012.rt = tothospsinpatientdays / T001_001) %>%
  mutate(healthcare.edvisits.2012.rt = stghospsedvisit / T001_001)

}
load()
saveRDS(healthcare, file="data/healthcare/healthcare.RDa")


