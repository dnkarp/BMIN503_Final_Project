load<-function(){
  election_results <<- read_csv("data/election_results/US_County_Level_Presidential_Results_08-16.csv")
}
load()
saveRDS(election_results,file="data/election_results/election_results.Rda")
