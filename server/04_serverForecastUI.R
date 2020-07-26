###############################################################
## 04_serverForecastUI.R
##############################################################

output$forecastUI <- renderUI({
    
    tagList(
        # tags$h1("Under Construction ...")
        
        # argonH1("Classic Cards", display = 4),
        argonRow(
            argonCard(
                width = 12,
                src = NULL,
                icon = icon("chart-line"),
                # status = "primary",
                shadow = TRUE,
                border_level = 2,
                hover_shadow = TRUE,
                title = "Forecasting",
                background_color = 'default',
                argonRow(
                    argonColumn(width = 6, highchartOutput("hc_outPredictedCases")),
                    argonColumn(width = 6, highchartOutput("hc_outPredictedDeaths"))
                )
            )
        )
        
    )
})



output$hc_outPredictedCases <- renderHighchart({
    
    
    original_tbl <- NewCases_tbl[ NewCases_tbl$countryName == input$countryNameInput_v2, c('date', 'NewConfirmed')] 
    
    forecast_tbl <- forecast_mode(original_tbl, periods = 30, freq = 'day')
    
    hc_out <- hc_plot_forecast(Original_tbl = original_tbl, forecast_tbl = forecast_tbl)
    
    
    v_title <- paste(input$countryNameInput_v2, " - Predicted number of confirmed cases over the next 30 days")
    
    hc_out %>% 
        hc_title(text = v_title) %>%
        hc_plotOptions(
            line = list(marker = list(enabled = FALSE)),
            arearange = list(marker = list(enabled = FALSE))
        ) %>% 
        hc_add_theme(hc_theme_sandsignika()) %>% 
        hc_exporting(enabled = TRUE)
        
    
    # hc_add_theme(hc_theme_flat() ) %>% 
    # hc_add_theme(hc_theme_ffx()) %>% 
    # hc_add_theme(hc_theme_sandsignika() ) %>% 
    # hc_add_theme(hc_theme_538() ) %>% 
        
       
})


output$hc_outPredictedDeaths <- renderHighchart({
    
    original_tbl <- NewCases_tbl[ NewCases_tbl$countryName == input$countryNameInput_v2, c('date', 'NewDeaths')] 
    
    forecast_tbl <- forecast_mode(original_tbl, periods = 30, freq = 'day')
    
    hc_out <- hc_plot_forecast(Original_tbl = original_tbl, forecast_tbl = forecast_tbl)
    
    v_title <- paste(input$countryNameInput_v2, " - Predicted number of deaths over the next 30 days")
    
    hc_out %>% 
        hc_title(text = v_title) %>%
        hc_plotOptions(
            line = list(marker = list(enabled = FALSE)),
            arearange = list(marker = list(enabled = FALSE))
        ) %>% 
        hc_add_theme(hc_theme_538() ) %>% 
        hc_exporting(enabled = TRUE)
    
    
    # hc_add_theme(hc_theme_flat() ) %>% 
    # hc_add_theme(hc_theme_ffx()) %>% 
    # hc_add_theme(hc_theme_sandsignika() ) %>% 
    # hc_add_theme(hc_theme_538() ) %>% 
    
    
})