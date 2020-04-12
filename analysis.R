library(coronavirus)
library(tidyverse)

library(highcharter) # for visualization

coronavirus <- read.csv(file = "https://raw.githubusercontent.com/ulklc/covid19-timeseries/master/countryReport/raw/rawReport.csv", stringsAsFactors = F)

coronavirus %>% glimpse()

coronavirus %>% 
    write.csv(file = 'data/coronavirus.csv')

# convert data type
coronavirus$day <- as.Date(coronavirus$day, '%Y/%m/%d')

# rename column name
colnames(coronavirus)[1] <- 'date'



coronavirus %>% 
    filter(countryName == 'Mozambique')


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

# %>% 
#     dplyr::mutate(activeCasesPer = round((Unrecovered/confirmed)*100),1)

# select total confirmed, recovered, death and Unrecovered by countryName
dataframeTotal %>% 
    filter(countryName == 'South Africa')

# getting percent of Active Cases by country name
dataframeTotal$activeCasesPer <- round((dataframeTotal$Unrecovered/dataframeTotal$confirmed)*100, 1)

# getting percent of Recovered Cases by country name
dataframeTotal$RecoveredPer <- round((dataframeTotal$recovered/dataframeTotal$confirmed)*100, 1)

# getting Death percent of the cases by country name
dataframeTotal$DeathPer <- round((dataframeTotal$death/dataframeTotal$confirmed)*100, 1)


# getting Total countries affected:
dataframeTotal %>% 
    filter(confirmed > 0) %>% 
    select(countryName) %>% 
    unique() %>% 
    nrow()

# or better
No_affected_country <- dataframeTotal %>% 
    filter(confirmed > 0) %>% 
    count() %>% 
    pull() %>% 
    as.integer()



# # Confirmed Cases Over Time
# coronavirus %>% 
#     filter(countryName == 'Mozambique') %>% 
#     filter(confirmed > 0) %>% 
#     select(date, confirmed) %>% 
#     group_by(date) %>% 
#     # mutate(incident_cases = c(0, diff(confirmed))) 
#     mutate(confirmed_lag = ifelse(is.na(dplyr::lag(confirmed)), 0, dplyr::lag(confirmed, 1))) %>% 
#     # dplyr:: mutate(confirmed_lag = dplyr::lag(confirmed),
#     #                diff_confirmed = confirmed - confirmed_lag) %>% 
#     # select(-c(region,lat,lon)) %>% 
#     head()


# Confirmed Cases Over Time: New cases by country name
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

NewCases_tbl %>% 
    filter(countryName == 'South Africa') %>% 
    select(-c(countryCode, 'region', 'lat', 'lon')) %>% 
    tail()

NewCases_tbl$Death_Rate <- round((NewCases_tbl$death/NewCases_tbl$confirmed)*100, 2)

# 2.0 Creating Visualizations ---------------------------------------------

# 2.1 Plotting New Cases per Day ----------------------------------------------

plot_data <- NewCases_tbl %>% 
    # filter by Country Name
    filter(countryName == 'South Africa') %>% 
    select(date, countryName, NewConfirmed, NewRecovered, NewDeaths)
    


highchart() %>% 
    hc_chart(type = 'column') %>% 
    hc_xAxis(categories = plot_data$date) %>% 
    hc_add_series(data = plot_data$NewConfirmed, name = 'Confirmed', dataLabels = list(enabled = TRUE)) %>%
    hc_add_series(data = plot_data$NewDeaths, name = 'Deaths') %>% 
    hc_add_series(data = plot_data$NewRecovered, name = 'Recovered') %>% 
    highcharter::hc_title(text = paste('New Cases per Day -', unique(plot_data$countryName))) %>%
    hc_tooltip(crosshairs = TRUE, shared = TRUE)
   

# 2.2 Plotting Cumulative Cases per Day ----------------------------------------------

plot_cumulative_data <- NewCases_tbl %>% 
    # filter by Country Name
    filter(countryName == 'South Africa') %>% 
    select(date, countryName, confirmed, recovered, death)


highchart() %>% 
    hc_chart(type = 'column') %>% 
    hc_xAxis(categories = plot_cumulative_data$date) %>% 
    hc_add_series(data = plot_cumulative_data$confirmed, name = 'Confirmed', dataLabels = list(enabled = TRUE)) %>%
    hc_add_series(data = plot_cumulative_data$death, name = 'Deaths') %>% 
    hc_add_series(data = plot_cumulative_data$recovered, name = 'Recovered') %>% 
    highcharter::hc_title(text = paste('Cumulative Cases per Day -', unique(plot_cumulative_data$countryName))) %>%
    hc_tooltip(crosshairs = TRUE, shared = TRUE)


# 2.3 Creating function to plot New Cases ---------------------------------

hc_plot_NewCases <- function(data, countryName, cumulative = FALSE){
    
    dataset <- data
    
    v_countryName <- as.character(countryName)
    
    if (cumulative){
        
        plot_data <- dataset %>% 
            # filter by Country Name
            # filter(str_detect(ORIGIN_CITY_NAME, "New York"))
            filter(str_detect(countryName, v_countryName)) %>% 
            select(date, countryName, confirmed, recovered, death)
        
        v_confirmed <- plot_data$confirmed
        v_recovered <- plot_data$recovered
        v_deaths <- plot_data$death
        
        v_title <- paste('Cumulative Cases per Day -', countryName)
        
        
    }else{
        
        plot_data <- dataset %>% 
            # filter by Country Name
            # filter(countryName == countryName) %>% 
            filter(str_detect(countryName, v_countryName)) %>% 
            select(date, countryName, NewConfirmed, NewRecovered, NewDeaths)
        
        v_confirmed <- plot_data$NewConfirmed
        v_recovered <- plot_data$NewRecovered
        v_deaths <- plot_data$NewDeaths
        
        v_title <- paste('New Cases per Day -', countryName)
        
    }
    
    
    hc_out <- highchart() %>% 
        hc_chart(type = 'column') %>% 
        hc_xAxis(categories = plot_data$date) %>% 
        hc_add_series(data = v_confirmed, name = 'Confirmed', dataLabels = list(enabled = TRUE)) %>%
        hc_add_series(data = v_recovered, name = 'Recovered') %>% 
        hc_add_series(data = v_deaths, name = 'Deaths') %>% 
        highcharter::hc_title(text = v_title) %>%
        hc_tooltip(crosshairs = TRUE, shared = TRUE) %>% 
        hc_add_theme(hc_theme_flat() ) %>% 
        hc_exporting(enabled = TRUE)
        # hc_add_theme(hc_theme_ffx() ) %>% 
        # hc_add_theme(hc_theme_flat())
        # hc_add_theme(hc_theme_sandsignika() )
        # hc_add_theme(hc_theme_538() )
    
    return(hc_out)
    
    
}


# 2.3.1 plotting New Cases using function


# New Cases per Day
hc_plot_NewCases(data = NewCases_tbl, countryName = 'South Africa', cumulative = FALSE)


# Cumulative Cases per Day
hc_plot_NewCases(data = NewCases_tbl, countryName = 'South Africa', cumulative = TRUE)



# 2.4 Case Fatality Rate --------------------------------------------------

DeathRate_tbl <- 
NewCases_tbl %>% 
    # filter(countryName == 'South Africa') %>% 
    select(date, countryName, confirmed, death, Death_Rate) 

plot_data <- DeathRate_tbl %>% 
    filter(countryName == 'South Africa')

highchart() %>% 
    hc_chart(type = 'area') %>% 
    hc_xAxis(categories = plot_data$date) %>% 
    hc_add_series(data = plot_data$Death_Rate, name = 'Case Fatality Rate', dataLabels = list(enabled = TRUE)) %>% 
    hc_yAxis(plotLines = list(list(
        value = round(mean(plot_data$Death_Rate, na.rm = TRUE), 2),
        color = "green",
        width = 2,
        dashStyle = "shortdash",
        label = list ( text = 'Average') 
    )),
    labels = list(format = '{value}%') 
    ) %>% 
    hc_tooltip(table = TRUE, sort = TRUE, 
               pointFormat='Deaths: {point.death} <br>
             Confirmed: {point.confirmed}'
               )


highchart() %>% 
    # hc_chart(type = 'area') %>% 
    hc_xAxis(categories = plot_data$date) %>% 
    hc_add_series(data = plot_data, 
                  type = 'area',
                  hcaes(y = Death_Rate),
                  name = 'Case Fatality Rate', dataLabels = list(enabled = TRUE)) %>% 
    # hc_xAxis(categories = plot_data$date) %>% 
    hc_yAxis(plotLines = list(list(
        value = round(mean(plot_data$Death_Rate, na.rm = TRUE), 2),
        color = "green",
        width = 2,
        dashStyle = "shortdash",
        label = list ( text = 'Average') 
    )),
    labels = list(format = '{value}%') 
    ) %>% 
    hc_tooltip(table = TRUE, sort = TRUE,
               pointFormat='<br>
               Rate: <b> {point.Death_Rate}% </b><br>
               Deaths: <b> {point.death:,0f} </b><br>
             Confirmed: <b> {point.confirmed:,0f} </b>'
    ) 
# %>% 
    # hc_add_theme(hc_theme_flat() )
    # hc_add_theme(hc_theme_sandsignika() )
    # hc_add_theme(hc_theme_flat())
    # hc_tooltip(crosshairs = TRUE, borderWidth = 5, sort = TRUE, table = TRUE) 


# 2.4.1 Creating function for plotting Deaths Rate ------------------------

# function to plot Case Fatality Rate
hc_plot_DeathsRate <- function(data = NewCases_tbl, countryName = 'South Africa'){
    
    v_countryName = countryName
    
    v_title <- paste('Case Fatality Rate -', v_countryName)
    
    plot_data <- 
        NewCases_tbl %>% 
        # filter(countryName == 'South Africa') %>% 
        filter(str_detect(countryName, v_countryName)) %>% 
        select(date, countryName, confirmed, death, Death_Rate) 
    
    
    hc_out <- highchart() %>% 
        # hc_chart(type = 'area') %>% 
        hc_xAxis(categories = plot_data$date) %>% 
        hc_add_series(data = plot_data, 
                      type = 'area',
                      hcaes(y = Death_Rate),
                      name = 'Case Fatality Rate', dataLabels = list(enabled = TRUE)) %>% 
        highcharter::hc_title(text = v_title) %>%
        hc_yAxis(plotLines = list(list(
            value = round(mean(plot_data$Death_Rate, na.rm = TRUE), 2),
            color = "green",
            width = 2,
            dashStyle = "shortdash",
            label = list ( text = 'Average') 
        )),
        labels = list(format = '{value}%') 
        ) %>% 
        hc_tooltip(table = TRUE, sort = TRUE, borderWidth = 1,
                   pointFormat='<br>
               Rate: <b> {point.Death_Rate}% </b><br>
               Deaths: <b> {point.death:,0f} </b><br>
             Confirmed: <b> {point.confirmed:,0f} </b>'
        ) %>% 
        # hc_add_theme(hc_theme_sandsignika() )
         hc_add_theme(hc_theme_flat()) %>% 
        hc_exporting(enabled = TRUE)
    
    return(hc_out)
    
    
}


hc_plot_DeathsRate(data = NewCases_tbl, countryName = 'Italy')

hc_plot_DeathsRate(data = NewCases_tbl, countryName = 'United State')



# 3.0 Creating Map --------------------------------------------------------

df_mapdata <- dataframeTotal %>% 
    # filter(countryName == 'South Africa') %>% 
    select(code = countryCode, name = countryName, value = confirmed, death, recovered, Unrecovered)

highchart(type = "map",width = "100%",height = "100%") %>%
    hc_add_series_map(map = worldgeojson, data = df_mapdata, value = 'value', joinBy = c('iso-a2', 'code')) %>% 
    hc_colorAxis(stops = color_stops(5)) %>%
    hc_tooltip(useHTML = TRUE,
               headerFormat = '',
               pointFormat = paste0('{point.name}: {point.value}')) %>%
    # hc_exporting(enabled = TRUE,filename = value) %>%
    hc_add_theme(hc_theme_ffx()) %>%
    hc_chart(zoomType = "xy") %>%
    hc_mapNavigation(enabled = TRUE)


mapdata <- get_data_from_map(download_map_data("custom/world"))

mapdata %>% glimpse()

hcmap("custom/world", name = "Total Confirmed", 
      data = df_mapdata, 
      value = "value",
      joinBy = c('iso-a2', 'code'), 
      # dataLabels = list(
      #                   # enabled = TRUE, 
      #                   format = '{point.name}'),
      borderColor = "#FAFAFA", borderWidth = 0.1,
      tooltip = list(valueDecimals = 0, valuePrefix = "", valueSuffix = "")) %>% 
    # hc_add_theme(hc_theme_db() ) %>% 
    hc_add_theme(hc_theme_sandsignika() ) %>% 
    # hc_add_theme(hc_theme_flat() ) %>% 
    hc_chart(zoomType = "xy") %>%
    hc_mapNavigation(enabled = TRUE) %>% 
    hc_colorAxis(stops = color_stops(5)) %>% 
    hc_exporting(enabled = TRUE) %>% 
    hc_tooltip(useHTML = TRUE,
               headerFormat = '',
               pointFormat = paste0('<b> {point.name} </b> <br>
                                    Confirmed: <b> {point.value} </b><br>
                                    Deaths: <b> {point.death:,0f} </b><br>
                                    Recovered: <b> {point.recovered:,0f} </b><br>
                                    Active: <b> {point.Unrecovered:,0f} </b><br>') )
#
# %>% 
#     hc_tooltip(useHTML = TRUE,
#                headerFormat = '',
#                pointFormat = paste0('{point.name}: {point.value}'))


hcmap(worldgeojson, name = "Total Confirmed", 
      data = df_mapdata, 
      value = "value",
      joinBy = c('iso-a2', 'code'), 
      # dataLabels = list(enabled = TRUE, format = '{point.name}'),
      borderColor = "#FAFAFA", borderWidth = 0.1,
      tooltip = list(valueDecimals = 0, valuePrefix = "", valueSuffix = "")) %>% 
    hc_tooltip(useHTML = TRUE,
               headerFormat = '',
               pointFormat = paste0('{point.name}: {point.value}'))
