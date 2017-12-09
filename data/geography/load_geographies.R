require("tigris")
setwd("~/Dropbox/courses/fall-2017/EPID-600/final_project/")

#load county geographies
geo.cnty <- counties() #loads all counties
#geo.cnty <- counties(state=c("PA","NY","NJ")) #specify a subset of states
saveRDS(geo.cnty, file="data/geography/UScountySPDF.RDa")

#load state geographies
geo.st <- states()
saveRDS(geo.st, file="data/geography/USstateSPDF.RDa")
