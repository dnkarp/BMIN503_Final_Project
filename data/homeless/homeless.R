load<-function(){
  require(readxl)
  X2007_2016_PIT_Counts_by_CoC <- read_excel("data/homeless/2007-2016-PIT-Counts-by-CoC.xlsx")
  homeless <<- X2007_2016_PIT_Counts_by_CoC
  }
load()
saveRDS(homeless, file="data/homeless/homeless.RDa")
