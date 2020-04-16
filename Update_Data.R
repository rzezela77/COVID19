########################################################
## Getting New Data 
######################################################

# loading required library
library(coronavirus) # updating COVID-19 data
library(tidyverse) # for data manipulation


# loading the data
coronavirus <- read.csv(file = "https://raw.githubusercontent.com/ulklc/covid19-timeseries/master/countryReport/raw/rawReport.csv", stringsAsFactors = F)

# write new data
coronavirus %>% 
    write.csv(file = 'data/coronavirus.csv')