load<-function(){
  per_captia_gdp_by_state_multi_year <<- read_csv("data/gdp/per_captia_gdp_by_state_multi_year.csv", skip = 4)

  per_industry_contribution_to_state_gdp_multi_year <<- read_csv("data/gdp/per_industry_contribution_to_state_gdp_multi_year.csv", skip = 4)

  subsidies_by_industry_LQ_multi_year <<- read_csv("data/gdp/subsidies_by_industry_LQ_multi_year.csv",skip = 4)
}
load()
saveRDS(per_captia_gdp_by_state_multi_year,file="data/gdp/per_captia_gdp_by_state_multi_year.Rda")
saveRDS(per_industry_contribution_to_state_gdp_multi_year,file="data/gdp/per_industry_contribution_to_state_gdp_multi_year.Rda")
saveRDS(subsidies_by_industry_LQ_multi_year,file="data/gdp/subsidies_by_industry_LQ_multi_year.Rda")
