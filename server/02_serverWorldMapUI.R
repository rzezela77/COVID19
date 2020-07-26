#######################################################
## 02_serverWorldMapUI.R
#####################################################


output$worldMapUI <- renderUI({
    
    tagList(
        
        argonR::argonRow(
            
            argonColumn(
                width = 12,
                highchartOutput("hc_out_worldMap", height = "600px")
            )
        )
        
    )
})


output$hc_out_worldMap <- renderHighchart({
    
    hcmap("custom/world", name = "COVID-19", 
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
        # hc_colorAxis(stops = color_stops(5)) %>% 
        hc_colorAxis(dataClasses = color_classes(c(0, 50, 100, 500, 1000, 10000))) %>%
        hc_exporting(enabled = TRUE) %>% 
        hc_tooltip(useHTML = TRUE,
                   headerFormat = '',
                   pointFormat = paste0('<b> {point.name} </b> <br>
                                    Confirmed: <b> {point.value} </b><br>
                                    Deaths: <b> {point.death:,0f} </b><br>
                                    Recovered: <b> {point.recovered:,0f} </b><br>
                                    Active: <b> {point.Unrecovered:,0f} </b><br>') ) %>% 
        hc_title(text = "Global COVID-19")
    
})
