#############################################
#               Global File   
# 
# To loading the data and create necessary dataframe according to the goal
#
#############################################


# 1.0 Loading required libraries and data ---------------------------------


# loading required library
library(shiny)
library(argonR)
library(argonDash)

library(tidyverse)
library(shinycssloaders)
library(shinyWidgets)

library(coronavirus) # updating COVID-19 data
# library(tidyverse) # for data manipulation

# library(pander) # for formating in R Markdown

library(highcharter) # for visualization

library(prophet) # for forecasting




# # updating data
# source(file = 'Update_Data.R')

# loading the data
# coronavirus <- read.csv(file = "https://raw.githubusercontent.com/ulklc/covid19-timeseries/master/countryReport/raw/rawReport.csv", stringsAsFactors = F)


# # 2.0 ReactivePoll coronavirus data ------------------------------------------
# 
# update_coronavirus_data <- reactivePoll((1/4)*60*60*1000, session = NULL,
#                               checkFunc = function(){
#                                   
#                                   # max_date <- Sys.Date()
#                                   
#                                   max_date <- Sys.time()
#                                   
#                                   # max_date <- getMaxDate(coronavirus)
# 
#                                   return(max_date)
# 
#                               },
# 
#                               valueFunc = function(){
# 
#                                   
#                                   # updating data
#                                   source('Update_Data.R')
# 
# 
#                                   # # loading updated data
#                                   # coronavirus <- read.csv(file = 'data/coronavirus.csv')[, -1]
# 
#                                   # return(coronavirus)
# 
#                               }
# )
# 




# loading coronavirus data
coronavirus <- read.csv(file = 'data/coronavirus.csv')[, -1]

# coronavirus %>% glimpse()

# convert data type
coronavirus$day <- as.Date(coronavirus$day, '%Y/%m/%d')

# rename column name
colnames(coronavirus)[1] <- 'date'



# # # remove unnecessary variable
# # coronavirus <- coronavirus[, -1]

# base_coronavirus_data <- reactive({
#     
#     coronavirus <- coronavirus_data()
#     
#     # convert data type
#     coronavirus$day <- as.Date(coronavirus$day, '%Y/%m/%d')
#     
#     # rename column name
#     colnames(coronavirus)[1] <- 'date'
#     
#     return(coronavirus)
#     
# })



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
# dataframeTotal <- reactive({
#     
#     coronavirus <- base_coronavirus_data()
#     
#     result <- 
#     coronavirus %>% 
#         dplyr::group_by(countryName) %>%
#         slice(n()) %>%
#         ungroup() %>%
#         dplyr::mutate(Unrecovered = confirmed - ifelse(is.na(recovered), 0, recovered) - ifelse(is.na(death), 0, death)) %>%
#         dplyr::arrange(-confirmed) %>%
#         dplyr::ungroup() %>%
#         select(-c(date,region,lat,lon)) 
#     
#     return(result)
#     
# })


dataframeTotal <- 
    result <- 
        coronavirus %>% 
        dplyr::group_by(countryName) %>%
        slice(n()) %>%
        ungroup() %>%
        dplyr::mutate(Unrecovered = confirmed - ifelse(is.na(recovered), 0, recovered) - ifelse(is.na(death), 0, death)) %>%
        dplyr::arrange(-confirmed) %>%
        dplyr::ungroup() %>%
        select(-c(date,region,lat,lon)) 


# creating Yestaerday dataframe
df_TotalYesterdayCases <- 
    coronavirus %>%
        dplyr::group_by(countryName) %>%
        slice(n() - 1) %>% # max_date -1
        ungroup() %>%
        dplyr::mutate(Unrecovered = confirmed - ifelse(is.na(recovered), 0, recovered) - ifelse(is.na(death), 0, death)) %>%
        dplyr::arrange(-confirmed) %>%
        dplyr::ungroup() %>%
        select(-c(date,region,lat,lon))

    
 
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


    
    # 3.0 Criar Mapa ----------------------------------------

    # # Step 1
    # mapdata <- get_data_from_map(download_map_data("custom/world"))
    # # mapdata <- get_data_from_map(download_map_data("countries/mz/mz-all"))
    #
    # # mapdata %>% glimpse()


    # Step 2
    df_mapdata <- dataframeTotal %>%
        select(code = countryCode, name = countryName, value = confirmed, death, recovered, Unrecovered)


    
# # creating Yestaerday dataframe
# df_TotalYesterdayCases <- reactive({
#     
#     coronavirus <- base_coronavirus_data()
#     
#     result <- 
#     coronavirus %>% 
#         dplyr::group_by(countryName) %>%
#         slice(n() - 1) %>% # max_date -1
#         ungroup() %>%
#         dplyr::mutate(Unrecovered = confirmed - ifelse(is.na(recovered), 0, recovered) - ifelse(is.na(death), 0, death)) %>%
#         dplyr::arrange(-confirmed) %>%
#         dplyr::ungroup() %>%
#         select(-c(date,region,lat,lon)) 
#     
#     return(result)
#     
#     
# })
#     
#     
# 
# 
# # # select total confirmed, recovered, death and Unrecovered by countryName
# # dataframeTotal %>% 
# #     filter(countryName == 'Mozambique') %>% 
# #     pander()
# 
# 
# # 2.1 Confirmed Cases Over Time: New cases by country name -----------------------------------
# NewCases_tbl <- reactive({
#     
#     coronavirus <- base_coronavirus_data()
#     
#     result <- 
#         coronavirus %>% 
#         # filter(countryName == 'Mozambique') %>% 
#         filter(confirmed > 0) %>% 
#         group_by(countryName) %>%
#         mutate(
#             recovered = case_when(
#                 is.na(recovered) ~ lag(recovered),
#                 TRUE ~ recovered
#             ),
#             confirmed = case_when(
#                 is.na(confirmed) ~ lag(confirmed),
#                 TRUE ~ confirmed
#             ),
#             death = case_when(
#                 is.na(death) ~ lag(death),
#                 TRUE ~ death
#             ),
#             Active = as.numeric(confirmed) - as.numeric(death) - as.numeric(recovered)
#         ) %>%
#         mutate(NewConfirmed = case_when(
#             !is.na(lag(as.numeric(confirmed))) ~ abs(as.numeric(confirmed) - lag(as.numeric(confirmed))),
#             TRUE ~ 0),
#             NewRecovered = case_when(
#                 !is.na(lag(as.numeric(recovered))) ~ abs(as.numeric(recovered) - lag(as.numeric(recovered))),
#                 TRUE ~ 0),
#             NewDeaths = case_when(
#                 !is.na(lag(as.numeric(death))) ~ abs(as.numeric(death) - lag(as.numeric(death))),
#                 TRUE ~ 0)
#             # ,change = case_when(
#             #     !is.na(lag(as.numeric(active))) ~ abs(as.numeric(active) - lag(as.numeric(active))),
#             #     TRUE ~ 0)
#         ) %>% 
#         ungroup()
#     
#     
#     # # getting deaths rate
#     # NewCases_tbl$Death_Rate <- round((NewCases_tbl$death/NewCases_tbl$confirmed)*100, 1)
#     
#     
#     # getting deaths rate
#     result$Death_Rate <- round((result$death/result$confirmed)*100, 1)
#     
#     return(result)
#     
# })
#     
# 
# 
# 
# # NewCases_tbl %>% 
# #     filter(countryName == 'South Africa') %>% 
# #     select(-c(countryCode, 'region', 'lat', 'lon')) %>% 
# #     tail() %>% 
# #     pander()
# 
# 
# 
# # 3.0 Criar Mapa ----------------------------------------
# 
# # # Step 1
# # mapdata <- get_data_from_map(download_map_data("custom/world"))
# # # mapdata <- get_data_from_map(download_map_data("countries/mz/mz-all"))
# # 
# # # mapdata %>% glimpse()
# 
# 
# # # Step 2
# # df_mapdata <- dataframeTotal %>%
# #     select(code = countryCode, name = countryName, value = confirmed, death, recovered, Unrecovered)
# 
# # df_mapdata %>%
# #     filter(name == 'South Africa') %>%
# #     pander()
# 
