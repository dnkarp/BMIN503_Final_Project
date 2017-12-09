
library(tidycensus)
library(purrr)
# Un-comment below and set your API key
census_api_key("e7051ec917473383ba64a0c65d7090fa5cc10cf4")
api.key.install(key="e7051ec917473383ba64a0c65d7090fa5cc10cf4")

us.states.list <- unique(fips_codes$state)[1:51]
us.counties <- unique(fips_codes)
us.states <- us.counties %>%
  group_by(state) %>%
  
us.counties$GEOID <- paste0(us.counties$state_code,us.counties$county_code)
us.counties$stcnty <- paste0(us.counties$state,us.counties$county_code)

totalpop <- map_df(us.states, function(x) {
  get_acs(geography = "county", variables = "B01003_001", year="2015", state = x)
})

library(sf)
options(tigris_use_cache = TRUE)
totalpop_sf <- reduce(
  map(us.states, function(x) {
    get_acs(geography = "county", variables = "B01003_001", 
            state = x, geometry = TRUE)
  }), 
  rbind
)

counties.join <- merge(us.counties,totalpop_sf,by.x="GEOID",by.y="GEOID")[c("GEOID","state","state_code","state_name","stcnty","county_code","county","estimate","geometry")]
names(counties.join)[names(counties.join) == 'estimate'] <- 'totpop.2015'

counties.join <- merge(counties.join,dt.cnty,by.x="stcnty",by.y="stcnty",all.x=TRUE)
