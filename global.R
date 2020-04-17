#############################################
#               Global File   
# 
# To loading the data and create necessary dataframe according to the goal
#
#############################################


# 1.0 Loading required libraries and data ---------------------------------


# loading required library
library(coronavirus) # updating COVID-19 data
library(tidyverse) # for data manipulation

library(pander) # for formating in R Markdown

library(highcharter) # for visualization


# # updating data
# source(file = 'Update_Data.R')

# loading the data
# coronavirus <- read.csv(file = "https://raw.githubusercontent.com/ulklc/covid19-timeseries/master/countryReport/raw/rawReport.csv", stringsAsFactors = F)

coronavirus <- read.csv(file = 'data/coronavirus.csv')

# coronavirus %>% glimpse()

# remove unnecessary variable
coronavirus <- coronavirus[, -1]


# convert data type
coronavirus$day <- as.Date(coronavirus$day, '%Y/%m/%d')

# rename column name
colnames(coronavirus)[1] <- 'date'

# coronavirus %>% glimpse()

# 1.1 Examine the data ----------------------------------------------------

# coronavirus %>% 
#     filter(countryName == 'Mozambique') %>% 
#     select(date, countryName, confirmed, recovered, death) %>% 
#     tail() %>% 
#     pander()



# 2.0 Getting total values ------------------------------------------------

# getting total confirmed, recovered, death and Unrecovered by countryName
# confirmedCount 
dataframeTotal <- coronavirus %>% 
    dplyr::group_by(countryName) %>%
    slice(n()) %>%
    ungroup() %>%
    dplyr::mutate(Unrecovered = confirmed - ifelse(is.na(recovered), 0, recovered) - ifelse(is.na(death), 0, death)) %>%
    dplyr::arrange(-confirmed) %>%
    dplyr::ungroup() %>%
    select(-c(date,region,lat,lon)) 

# creating Yestaerday dataframe
df_TotalYesterdayCases <- coronavirus %>% 
    dplyr::group_by(countryName) %>%
    slice(n() - 1) %>% # max_date -1
    ungroup() %>%
    dplyr::mutate(Unrecovered = confirmed - ifelse(is.na(recovered), 0, recovered) - ifelse(is.na(death), 0, death)) %>%
    dplyr::arrange(-confirmed) %>%
    dplyr::ungroup() %>%
    select(-c(date,region,lat,lon)) 


# # select total confirmed, recovered, death and Unrecovered by countryName
# dataframeTotal %>% 
#     filter(countryName == 'Mozambique') %>% 
#     pander()


# 2.1 Confirmed Cases Over Time: New cases by country name -----------------------------------
NewCases_tbl <- 
    coronavirus %>% 
    # filter(countryName == 'Mozambique') %>% 
    filter(confirmed > 0) %>% 
    group_by(countryName) %>%
    mutate(
        recovered = case_when(
            is.na(recovered) ~ lag(recovered),
            TRUE ~ recovered
        ),
        confirmed = case_when(
            is.na(confirmed) ~ lag(confirmed),
            TRUE ~ confirmed
        ),
        death = case_when(
            is.na(death) ~ lag(death),
            TRUE ~ death
        ),
        Active = as.numeric(confirmed) - as.numeric(death) - as.numeric(recovered)
    ) %>%
    mutate(NewConfirmed = case_when(
        !is.na(lag(as.numeric(confirmed))) ~ abs(as.numeric(confirmed) - lag(as.numeric(confirmed))),
        TRUE ~ 0),
        NewRecovered = case_when(
            !is.na(lag(as.numeric(recovered))) ~ abs(as.numeric(recovered) - lag(as.numeric(recovered))),
            TRUE ~ 0),
        NewDeaths = case_when(
            !is.na(lag(as.numeric(death))) ~ abs(as.numeric(death) - lag(as.numeric(death))),
            TRUE ~ 0)
        # ,change = case_when(
        #     !is.na(lag(as.numeric(active))) ~ abs(as.numeric(active) - lag(as.numeric(active))),
        #     TRUE ~ 0)
    ) %>% 
    ungroup()

# getting deaths rate
NewCases_tbl$Death_Rate <- round((NewCases_tbl$death/NewCases_tbl$confirmed)*100, 1)

# NewCases_tbl %>% 
#     filter(countryName == 'South Africa') %>% 
#     select(-c(countryCode, 'region', 'lat', 'lon')) %>% 
#     tail() %>% 
#     pander()



# 3.0 Criar Mapa ----------------------------------------

# # Step 1
# mapdata <- get_data_from_map(download_map_data("custom/world"))
# # mapdata <- get_data_from_map(download_map_data("countries/mz/mz-all"))
# 
# # mapdata %>% glimpse()


# Step 2
df_mapdata <- dataframeTotal %>%
    select(code = countryCode, name = countryName, value = confirmed, death, recovered, Unrecovered)

# df_mapdata %>%
#     filter(name == 'South Africa') %>%
#     pander()

