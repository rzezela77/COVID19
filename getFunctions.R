######################################################
# getFunctions.R
#####################################################


# 1.0 Creating function to plot New Cases ---------------------------------

hc_plot_NewCases <- function(data, countryName, cumulative = FALSE){
    
    dataset <- data
    
    v_countryName <- as.character(countryName)
    
    
    plot_data <- dataset %>% 
        # filter by Country Name
        # filter(str_detect(ORIGIN_CITY_NAME, "New York"))
        filter(str_detect(countryName, v_countryName)) 
    # %>% 
    #     select(date, countryName, confirmed, recovered, death)
    
    
    if (cumulative){
      
        v_confirmed <- plot_data$confirmed
        v_recovered <- plot_data$recovered
        v_deaths <- plot_data$death
        
        v_title <- paste('Cumulative Cases per Day -', v_countryName)
        
        
    }else{
        
        # plot_data <- dataset %>% 
        #     # filter by Country Name
        #     # filter(countryName == countryName) %>% 
        #     filter(str_detect(countryName, v_countryName)) %>% 
        #     select(date, countryName, NewConfirmed, NewRecovered, NewDeaths)
        
        v_confirmed <- plot_data$NewConfirmed
        v_recovered <- plot_data$NewRecovered
        v_deaths <- plot_data$NewDeaths
        
        v_title <- paste('New Cases per Day -', v_countryName)
        
    }
    
    
    hc_out <- highchart() %>% 
        hc_chart(type = 'column') %>% 
        # hc_chart(type = 'line') %>% 
        hc_xAxis(categories = plot_data$date) %>% 
        hc_add_series(data = v_confirmed, name = 'Confirmed', dataLabels = list(enabled = TRUE)) %>%
        hc_add_series(data = v_deaths, name = 'Deaths') %>% 
        hc_add_series(data = v_recovered, name = 'Recovered') %>% 
        highcharter::hc_title(text = v_title) %>%
        hc_tooltip(crosshairs = TRUE, shared = TRUE) %>% 
        # hc_add_theme(hc_theme_flat() ) %>% 
        # hc_add_theme(hc_theme_ffx()) %>% 
        # hc_add_theme(hc_theme_sandsignika() ) %>% 
        hc_add_theme(hc_theme_538() ) %>% 
        hc_exporting(enabled = TRUE)
    
    
    return(hc_out)
    
    
}


# 2.0 Creating function for plotting Deaths Rate ------------------------

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
        # hc_add_theme(hc_theme_flat()) %>% 
        hc_add_theme(hc_theme_538() ) %>% 
        hc_exporting(enabled = TRUE)
    
    return(hc_out)
    
    
}


# 3.0 getting total Confirmed, Recovered, Death and Unrecovered ----------
getCasesCount <- function(countryName = 'Mozambique', typeCase = 'confirmed'){
    
    v_countryName = countryName
    
    result <-
        dataframeTotal %>%
        filter(str_detect(countryName, v_countryName))
    
    if (typeCase == 'confirmed') {
        v_CasesCount <- result$confirmed
        
    } else if (typeCase == 'recovered') {
        v_CasesCount <- result$recovered
        
    } else if (typeCase == 'death') {
        v_CasesCount <- result$death
        
    } else {
        v_CasesCount <- result$Unrecovered
    }
    
    return(v_CasesCount)
    
}


# 4.0 getting percentage for Recovered, Death and Unrecovered ---------
getCasesPerc <- function(data = data, countryName = 'Mozambique', typeCase = 'confirmed'){
    
    v_countryName = countryName
    
    
    result <-
        data %>%
        filter(str_detect(countryName, v_countryName))
    
     if (typeCase == 'recovered') {
        v_CasesPerc <- round((result$recovered/result$confirmed)*100,1)
        
    } else if (typeCase == 'death') {
        v_CasesPerc <- round((result$death/result$confirmed)*100,1)
        
    } else {
        v_CasesPerc <- round((result$Unrecovered/result$confirmed)*100,1)
    }
    
    return(v_CasesPerc)
    
}


# 4.1 getting Yesterday percentage for Recovered, Death and Unrecovered ---------
getYesterdayPerc <- function(data_actual = data_actual, data_yesterday = data_yesterday, countryName = 'Mozambique', typeCase = 'confirmed'){
    
    v_countryName = countryName
    
    
    result_actual <-
        data_actual %>%
        filter(str_detect(countryName, v_countryName))
    
    result_yesterday <-
        data_yesterday %>%
        filter(str_detect(countryName, v_countryName))
    
    if (typeCase == 'recovered') {
        v_YesterdayPerc <- round(((result_actual$recovered/result_yesterday$recovered) -1)*100,1)
        
    } else if (typeCase == 'death') {
        v_YesterdayPerc <- round(((result_actual$death/result_yesterday$death) -1)*100,1)
        
    } else if (typeCase == 'Unrecovered') {
        v_YesterdayPerc <- round(((result_actual$Unrecovered/result_yesterday$Unrecovered) -1)*100,1)
        
    } else {
        v_YesterdayPerc <- round(((result_actual$confirmed/result_yesterday$confirmed) -1)*100,1)
    }
    
    return(v_YesterdayPerc)
    
}



getConfirmedCount <- function(countryName = 'Mozambique'){
    
    v_countryName = countryName
    
    result <- 
        dataframeTotal %>%
        filter(str_detect(countryName, v_countryName))
    
    v_confirmedCount <- result$confirmed
    
    return(v_confirmedCount)
    
}



