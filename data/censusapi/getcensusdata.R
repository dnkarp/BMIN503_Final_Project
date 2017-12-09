#load libraries
library("censusapi")

# load + install census key from script
source("census_key.R")

# get table of apis 
apis <- listCensusApis()

# get varlist for 5-year ACS (2015)
acs5_vars <- listCensusMetadata(name="acs5", vintage= 2015, type = "v")

# find variables
varsearch.race<-makeVarlist("acs5", vintage = 2015, c("race"), varsearch = "label",
            output = "dataframe")
varsearch.sex<-makeVarlist("acs5", vintage = 2015, c("sex"), varsearch = "label",
                            output = "dataframe")
varsearch.age<-makeVarlist("acs5", vintage = 2015, c("age"), varsearch = "label",
                            output = "dataframe")
varsearch.ethnicity<-makeVarlist("acs5", vintage = 2015, c("ethnicity"), varsearch = "label",
                            output = "dataframe")

# make varlist
varlist = c("NAME", "IPRCAT", "IPR_DESC", "PCTUI_PT")

# pull variables
county_vars.2015 <- getCensus(name="acs5",
          vars=varlist, 
          region="county:*", time=2015)

# export data
write.csv(dataset, "filename.csv")