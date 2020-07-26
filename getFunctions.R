######################################################
# getFunctions.R
#####################################################


# 1.0 Creating function to plot New Cases ---------------------------------

hc_plot_NewCases <- function(data, countryName, cumulative = FALSE){
    
    dataset <- data
    
    v_countryName <- as.character(countryName)
    
    
    if(v_countryName == "All"){
      
      plot_data <- dataset %>%
        group_by(date) %>% 
        summarise(
          confirmed = sum(confirmed),
          recovered = sum(recovered),
          death = sum(death),
          NewConfirmed = sum(NewConfirmed),
          NewRecovered = sum(NewRecovered),
          NewDeaths = sum(NewDeaths)
        )
      
      
    }else{
      
      plot_data <- dataset %>% 
        # filter by Country Name
        # filter(str_detect(ORIGIN_CITY_NAME, "New York"))
        filter(str_detect(countryName, v_countryName)) 
      # %>% 
      #     select(date, countryName, confirmed, recovered, death)
      
    }
    
    
   
    
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
    
    if (v_countryName == "All"){
      
      plot_data <-
        NewCases_tbl %>%
        group_by(date) %>% 
        # filter(countryName == 'South Africa') %>%
        # filter(str_detect(countryName, v_countryName)) %>%
        select(date, countryName, confirmed, death, Death_Rate) %>%
        summarise(confirmed = sum(confirmed), death = sum(death)) %>%
        mutate(Death_Rate = round((death / confirmed), 1))
      
      
    }else{
      
      plot_data <- 
        NewCases_tbl %>% 
        # filter(countryName == 'South Africa') %>% 
        filter(str_detect(countryName, v_countryName)) %>% 
        select(date, countryName, confirmed, death, Death_Rate) 
      
    }
    
    
    
    
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
    
    if (v_countryName == "All"){
      
      result <-
        dataframeTotal %>%
        summarise(
          confirmed = sum(confirmed),
          recovered = sum(recovered),
          death = sum(death),
          Unrecovered = sum(Unrecovered)
        )
      
      
    }else{
      
      result <-
        dataframeTotal %>%
        filter(str_detect(countryName, v_countryName))
      
    }
    
    
    
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
    
    if (v_countryName == "All"){
      
      result <-
        data %>%
        summarise(
          confirmed = sum(confirmed),
          recovered = sum(recovered),
          death = sum(death),
          Unrecovered = sum(Unrecovered)
        )
      
      
    }else{
      
      result <-
        data %>%
        filter(str_detect(countryName, v_countryName))
      
    }
    
    
   
    
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
    
    if (v_countryName == "All"){
      
      result_actual <-
        data_actual %>%
        summarise(
          confirmed = sum(confirmed),
          recovered = sum(recovered),
          death = sum(death),
          Unrecovered = sum(Unrecovered)
        )
      
      result_yesterday <-
        data_yesterday %>%
        summarise(
          confirmed = sum(confirmed),
          recovered = sum(recovered),
          death = sum(death),
          Unrecovered = sum(Unrecovered)
        )
      
    }else{
      
      result_actual <-
        data_actual %>%
        filter(str_detect(countryName, v_countryName))
      
      result_yesterday <-
        data_yesterday %>%
        filter(str_detect(countryName, v_countryName))
      
    }
    
    
   
    
    if (typeCase == 'recovered') {
        # v_YesterdayPerc <- round(((result_actual$recovered/result_yesterday$recovered) -1)*100,1)
        
        v_YesterdayPerc <- result_actual$recovered - result_yesterday$recovered
        
    } else if (typeCase == 'death') {
        # v_YesterdayPerc <- round(((result_actual$death/result_yesterday$death) -1)*100,1)
        
        v_YesterdayPerc <- result_actual$death - result_yesterday$death
        
    } else if (typeCase == 'Unrecovered') {
        # v_YesterdayPerc <- round(((result_actual$Unrecovered/result_yesterday$Unrecovered) -1)*100,1)
        
        v_YesterdayPerc <- result_actual$Unrecovered - result_yesterday$Unrecovered
        
    } else {
        # v_YesterdayPerc <- round(((result_actual$confirmed/result_yesterday$confirmed) -1)*100,1)
        
        v_YesterdayPerc <- result_actual$confirmed - result_yesterday$confirmed
    }
    
    return(v_YesterdayPerc)
    
}


getMaxDate <- function(data = data){
  
  max_date <- as.Date(max(data$date))
  
  return(max_date)
}

# getConfirmedCount <- function(countryName = 'Mozambique'){
#     
#     v_countryName = countryName
#     
#     result <- 
#         dataframeTotal %>%
#         filter(str_detect(countryName, v_countryName))
#     
#     v_confirmedCount <- result$confirmed
#     
#     return(v_confirmedCount)
#     
# }


# 5.0 Apply function for forecasting -------------------------------------------

# 5.1 Forecasting Mode --------------------------------------------------------
forecast_mode <- function(result_tbl, periods, freq){
  
  colnames(result_tbl) <- c("ds", "y")
  
  # training_period <- lubridate::floor_date(Sys.Date()-90, unit = "month")
  
  # result_tbl <- result_tbl %>% 
  #     filter(ds < training_period)
  
  # result_tbl$y <- log(result_tbl$y) # the y values are very small so it was not tramsformed using log function
  
  
  # m <- prophet(result_tbl, seasonality.mode = 'multiplicative')
  
  m <- prophet(result_tbl)
  
  future <- make_future_dataframe(m, periods = periods, freq = freq)
  
  forecast <- predict(m, future)
  
  forecast_tbl <- 
    forecast %>%
    select(ds, yhat, yhat_lower, yhat_upper)
  
  return (forecast_tbl)
}



# 5.2 Plotting Forecasted Table -----------------------------------------------

hc_plot_forecast <- function(Original_tbl, forecast_tbl){
  
  colnames(Original_tbl) <- c("Date1", "Amount")
  
    hc_out <- highchart(type = "stock") %>% 
    # hc_out <- highchart() %>% 
    hc_add_series(Original_tbl, 
                  # type = "scatter",
                  type = "line", 
                  hcaes(x = Date1, y = Amount), name = "Observed") %>% 
    hc_add_series(forecast_tbl, 
                  type = "spline",
                  # type = "line", 
                  hcaes(x = as.Date(ds), y = round(yhat)),
                  # hcaes(x = as.Date(ds), y = round(exp(yhat),0)), 
                  name = "Mean Predicted",
                  id = "fit", # this is for link the arearange series to this one and have one legend
                  lineWidth = 1) %>% 
    hc_add_series(
      forecast_tbl,
      type = "arearange",
      hcaes(x = as.Date(ds), high = round(yhat_upper), low = round(yhat_lower)), # the y value were not tramsformed using log function
      # hcaes(x = as.Date(ds), low = round(exp(yhat_lower),0), high = round(exp(yhat_upper),0)),
      name = "Range",
      linkedTo = "fit", # here we link the legends in one.
      color = hex_to_rgba("gray", 0.2),  # put a semi transparent color
      zIndex = -3 # this is for put the series in a back so the points are showed first
    ) %>% 
      hc_xAxis(categories = Original_tbl$Date1)
  
  
  # hc_out <- hc_out %>%
  #     hc_title(text = "Forecasting Topup Revenue")
  
  return(hc_out)
}


