#define merge function
mergevars <- function(x,y){
  if(y==1){
    z="countyFIPS"
  } else {
    z="stateFIPS"
  }
  return(merge(hotspots.vars,x,by.x=z,by.y="geo",all.x=T))
}

#merge county LISA datasets (wide format, 2015 only)
a <- `2015allCounty` %>% mutate(drug=c("all"))
colnames(a)[2] <- "rt"
b <- `2015rxCounty` %>% mutate(drug="rx")
colnames(b)[2] <- "rt"
c <- `2015opioidCounty` %>% mutate(drug="opioid")
colnames(c)[2] <- "rt"
d <- `2015heroinCounty` %>% mutate(drug="heroin")
colnames(d)[2] <- "rt"
e <- rbind(a, b, c, d)
f<-setDT(e)
g<-dcast(f, geo ~ drug, value.var = "quad_sig")
       
#merge to county geo dataframe
hotspots <- merge(geo.cnty.mcod@data[c("geo","GEOID","countyFIPS","stateFIPS","STUSPS","NAME")],g,by="geo",all.x = T)

#code high-high hotspos
hotspots<setDT(hotspots)
hotspots[, all.hh := ifelse(all==1,1,0)]
hotspots[, rx.hh := ifelse(rx==1,1,0)]
hotspots[, opioid.hh := ifelse(opioid==1,1,0)]
hotspots[, heroin.hh := ifelse(heroin==1,1,0)]
hotspots[, hotspot_any := (all.hh+rx.hh+opioid.hh+heroin.hh)]
hotspots[, hotspot_heroin := ifelse(heroin.hh == 1 & opioid.hh == 0,1,ifelse(heroin.hh == 0 & opioid.hh == 1,2,ifelse(heroin.hh == 1 & opioid.hh == 1,3,0)))]
hotspots[, c("all","rx","opioid","heroin"):=NULL]

#set new dt to merge
hotspots.vars <- hotspots

#raw counts
mcod.county.counts <- readRDS(file="../local_data/multiple_cause_of_death/mcod_cnty_2015_suppressed.RDa")
setDT(mcod.county.counts)
mcod.county.counts <- mcod.county.counts[year=="2015",1:7]
mcod.county.counts <- mcod.county.counts %>% 
  mutate(all.n=drd.all_count) %>%
  mutate(rx.n=drd.rx_count) %>%
  mutate(opioid.n=drd.opioid_count) %>%
  mutate(heroin.n=drd.heroin_count) %>%
  mutate(geo=countyFIPS)
mcod.county.counts <- mcod.county.counts[,c("geo","all.n","rx.n","opioid.n","heroin.n")]
#merge
hotspots.vars <- mergevars(mcod.county.counts,1)

#raw rates
mcod.county.rates <- readRDS(file="../local_data/multiple_cause_of_death/aa_mcod_cnty_2015_suppressed.RDa")
mcod.county.rates <- mcod.county.rates[1:6]
mcod.county.rates <- mcod.county.rates%>%
  mutate(all.rt=all) %>% mutate(rx.rt=rx) %>% mutate(opioid.rt=opioid) %>% mutate(heroin.rt=heroin)
mcod.county.rates <- mcod.county.rates[,c("geo","all.rt","rx.rt","opioid.rt","heroin.rt")]
#merge
hotspots.vars <- mergevars(mcod.county.rates,1)

#general population demographics
names(demographics) #county
setDT(demographics)
cols <- c(2,56:93)
a<-demographics[,..cols] %>% mutate(geo=fips)
#merge
hotspots.vars <- mergevars(a[,-c("fips")],1)

#healthcare
names(healthcare) #county
setDT(healthcare)
cols <- c(2,33:46)
a<-healthcare[,..cols] %>% mutate(geo=fips)
#merge
hotspots.vars <- mergevars(a[,-c("fips")],1)

#mortality (homicide/suicide)
names(mortality) #county
setDT(mortality)
cols <- c(7,9:11)
a<-mortality[,..cols] %>% mutate(geo=fips)
#merge
hotspots.vars <- mergevars(a[,-c("fips")],1)

#crime
names(crime) #county
setDT(crime)
cols <- c(2,11:17)
a<-crime[,..cols] %>% mutate(geo=fips5)
#merge
hotspots.vars <- mergevars(a[,-c("fips5")],1)

#urban rural classification
names(ruralurbancodes2013) #county
setDT(ruralurbancodes2013)
cols <- c(1,5:6)
a<-ruralurbancodes2013[,..cols] %>% mutate(geo=FIPS) %>% mutate(urbanrural=factor(ifelse(RUCC_2013 %in% c(1,2,3),1,ifelse(RUCC_2013 %in% c(4,6),2,ifelse(RUCC_2013 %in% c(5,7),3,4))),labels=c("large city","suburb","small city","rural")))
#merge
hotspots.vars <- mergevars(a[,-c("FIPS")],1)

#building permits
names(buildingpermits) #county
setDT(buildingpermits)
cols <- c(1:4)
a<-buildingpermits[,..cols] %>% mutate(geo=StCnty)
#merge
hotspots.vars <- mergevars(a[,-c("StCnty")],1)

#election results
names(US_County_Level_Presidential_Results_08_16) #county
setDT(US_County_Level_Presidential_Results_08_16)
cols <- c(1,4:5,8:9,12:13)
a<-US_County_Level_Presidential_Results_08_16[,..cols] %>% mutate(geo=fips_code) %>% 
  mutate(dem2rep08=dem_2008/gop_2008) %>%
  mutate(dem2rep12=dem_2012/gop_2012) %>%
  mutate(dem2rep16=dem_2016/gop_2016) %>%
  mutate(blue08=ifelse(dem2rep08>1,1,0)) %>%
  mutate(blue12=ifelse(dem2rep12>1,1,0)) %>%
  mutate(blue16=ifelse(dem2rep16>1,1,0)) %>%
  mutate(flip0816=ifelse(blue08-blue16!=0,1,0))
#merge
hotspots.vars <- mergevars(a[,8:15],1)

#medicaid expansion
names(medicaid) #state
statefips<-unique(fips_codes[1:3])
colnames(statefips) <- c("STUSPS","stateFIPS","states")
a <- merge(statefips,medicaid,by="states") %>% mutate(geo=stateFIPS)
setnames(a, "status", "medicaid_expansion")
#merge
hotspots.vars <- mergevars(a[,4:5],0)

#gdp per cap
names(per_captia_gdp_by_state_multi_year) #state
setDT(per_captia_gdp_by_state_multi_year)
cols <- c(1,5,7)
a<-per_captia_gdp_by_state_multi_year[,..cols] %>% mutate(geo=substr(Fips,1,2)) %>% 
  mutate(gdp.10yr.growth=(`2015`-`2005`)/`2005`)
#merge
hotspots.vars <- mergevars(a[,4:5],0)

#industry contribution to gdp
names(per_industry_contribution_to_state_gdp_multi_year) #state

tmp1 <- tmp %>% 
  mutate(geo=as.factor(substr(Fips,1,2))) %>%
  filter(IndCode %in% c(1,3,6,11,12,35,36,45,50,56,59,68,74,82))

vars2 <- c("2005","2015")
setDT(tmp1)
tmp2<-dcast(tmp1, geo ~ IndCode, value.var = vars2)

#colnames(tmp2) <- c("geo","gdp.pchng","gdp.ag","gdp.mining","gdp.constrctn","gdp.manfctring","gdp.retail","gdp.trans","gdp.info","gdp.fnce","gdp.re","gdp.prof","gdp.edu","gdp.art","gdp.govt")

industry<-data.frame("IndCode"=c(3,6,11,12,35,36,45,50,56,59,68,74,82),"Industry"=c("ag","mining","constrctn","manfctring","retail","trans","info","fnce","re","prof","edu","art","govt"))

tmp3a <- data.table(tmp2[,1:2],sapply(tmp2[,3:15],function(x) x/tmp2$`2005_1`))
tmp3a[, "gdp05.mxval"] <- apply(tmp3a[, 3:15], 1, max)
tmp3a[, "gdp05.mxind"] <- substr(colnames(tmp3a[,3:15])[apply(tmp3a[,3:15],1,which.max)],6,20)
cols <- c(1,16)
tmp3b <- data.table(tmp2[,..cols],sapply(tmp2[,17:ncol(tmp2)],function(x) x/tmp2$`2015_1`))
tmp3b[, "gdp15.mxval"] <- apply(tmp3b[, 3:15], 1, max)
tmp3b[, "gdp15.mxind"] <- substr(colnames(tmp3b[,3:15])[apply(tmp3b[,3:15],1,which.max)],6,20)
cols <- c(1:2,16)
tmp4 <- data.table(tmp2[,..cols],tmp3b[,3:15]-tmp3a[,3:15],tmp3a[,16:17],tmp3b[,16:17])
tmp4[, "gdp10y.mnval"] <- apply(tmp4[, 4:16], 1, min)
tmp4[, "gdp10y.mxval"] <- apply(tmp4[, 4:16], 1, max)
tmp4[, "gdp10y.mnind"] <- substr(colnames(tmp4[,4:16])[apply(tmp4[,4:16],1,which.min)],6,20)
tmp4[, "gdp10y.mxind"] <- substr(colnames(tmp4[,4:16])[apply(tmp4[,4:16],1,which.max)],6,20)
tmp4[, "gdp10y.chgval"] <- apply(abs(tmp4[, 4:16]), 1, max)
tmp4[, "gdp10y.chgind"] <- substr(colnames(tmp4[,4:16])[apply(abs(tmp4[,4:16]),1,which.max)],6,20)
cols <- c(1:3,17:26)
tmp5<-tmp4[,..cols]

industry.code <- c(ag=3
                   ,mining=6
                   ,constrctn=11 
                   ,manfctring=12
                   ,retail=35
                   ,trans=36
                   ,info=45
                   ,fnce=50
                   ,re=56
                   ,prof=59
                   ,edu=68
                   ,art=74
                   ,govt=82)

tmp5$gdp05.mxind <- names(industry.code)[match(tmp5$gdp05.mxind, industry.code)]
tmp5$gdp15.mxind <- names(industry.code)[match(tmp5$gdp15.mxind, industry.code)]
tmp5$gdp10y.mnind <- names(industry.code)[match(tmp5$gdp10y.mnind, industry.code)]
tmp5$gdp10y.mxind <- names(industry.code)[match(tmp5$gdp10y.mxind, industry.code)]
tmp5$gdp10y.chgind <- names(industry.code)[match(tmp5$gdp10y.chgind, industry.code)]

cols<-c(1,5,7,10:11,13)
a<-tmp5[,..cols]
#merge
hotspots.vars <- mergevars(a,0)

#geographic region
statelist<-data.frame(states=c(state.name),STUSPS=c(state.abb),region=c(data.frame(state.region)))
names(statelist) #state
a<-merge(statelist,statefips,by="STUSPS")[,3:4]
setnames(a,"stateFIPS","geo")
#merge
hotspots.vars <- mergevars(a,0)
hotspots.vars[STUSPS=="DC",state.region:="South"]

#save combined dataset
saveRDS(hotspots.vars,file = "data/hotspots/hotspots.suppressed.Rda")
