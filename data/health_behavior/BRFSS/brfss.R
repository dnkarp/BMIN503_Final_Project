library(data.table)

brfss.raw<-fread("data/health_behavior/BRFSS/LLCP2016.asc",sep="\r",header=FALSE)
head(brfss.raw)
