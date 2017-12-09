load<-function(){
CDC_prescription_rates_state_2015 <- read_csv("data/opioid_prescription_rates/CDC_prescription_rates_state_2015.csv")
rx_rates <<- CDC_prescription_rates_state_2015
}
load()
saveRDS(rx_rates, file="data/opioid_prescription_rates/rx_rates.RDa")
