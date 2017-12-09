geo_counties <- geo.make(state="*", county="*")
dem2000.sexbyage.vlist<-acs.lookup(endyear=2000, dataset="sf1", table.number = "P12")
dem2015.sexbyage.vlist<-acs.lookup(endyear=2015, span=5, table.number = "B01001")
dem2015.sexbyage.vlist <- data.frame(dem2015.sexbyage.vlist@results)
dem2000.sexbyage.vlist <- data.frame(dem2000.sexbyage.vlist@results)
age2015.county <- acs.fetch(endyear=2015, dataset="acs", span=5, table.number = "B01001", geography = geo_counties)
age2010.county <- acs.fetch(endyear=2010, dataset="acs", span=5, table.number = "B01001", geography = geo_counties)
age2000.county <- acs.fetch(endyear=2000, dataset="sf1", table.number="P12", geography = geo_counties)

age2015.county.extract <- data.table(age2015.county@geography[,2:3],age2015.county@estimate)
age2010.county.extract <- data.table(age2010.county@geography[,2:3],age2010.county@estimate)
age2000.county.extract <- data.table(age2000.county@geography[,2:3],age2000.county@estimate)

sumagegroups.acs <- function(x){
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
return(dt %>% select(c("state","county"),starts_with("age")))
}
sumagegroups.census <- function(x){
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
  return(dt %>% select(c("state","county"),starts_with("age")))
}

age2015.county.clean <- sumagegroups.acs(age2015.county.extract)
age2010.county.clean <- sumagegroups.acs(age2010.county.extract)
age2000.county.clean <- sumagegroups.census(age2000.county.extract)
