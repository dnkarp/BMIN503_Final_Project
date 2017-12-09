load<-function(){
require(readxl)
ruralurbancodes2013 <<- read_excel("data/built_environment/ruralurbancodes2013.xls")
}
load()
saveRDS(ruralurbancodes2013,file="data/built_environment/ruralurbancodes2013.RDa")
