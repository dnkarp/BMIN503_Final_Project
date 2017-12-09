load<-function(){
#AL only -- need to pull the rest, state by state, or look into API query
subsidies_by_industry_LQ_multi_year <- read_csv("data/gdp/subsidies_by_industry_LQ_multi_year.csv", skip = 4)
jobs <<- subsidies_by_industry_LQ_multi_year
}
load()
saveRDS(jobs, file="data/jobs/jobs.RDa")
