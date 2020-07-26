#################################################################
## serverDashboard.R
#################################################################



# 1.0 cardUI --------------------------------------------------------------

# 1.1 Test: sections - argonDashHeader --------------------------------------------------------

sections_tab <- argonTabItem(
    tabName = "sections",
    argonDashHeader(
        gradient = TRUE,
        color = "warning",
        separator = TRUE,
        separator_color = "info",
        top_padding = 8,
        bottom_padding = 8,
        argonCard(
            src = "https://www.google.com",
            status = "success",
            border_level = 0,
            hover_shadow = TRUE,
            title = "Card with Margins"
        ) %>% argonMargin(orientation = "t", value = -150)
    ),
    argonDashHeader(
        gradient = FALSE,
        color = "info",
        top_padding = 8,
        bottom_padding = 8,
        argonRow(
            argonColumn(
                width = 6,
                h1("Section Text"),
                h3("Some text here"),
                argonCard()
            ),
            argonColumn(
                width = 6, 
                argonCard() %>% argonMargin(orientation = "t", value = -200)
            )
        )
    ),
    argonDashHeader(
        gradient = FALSE,
        color = "secondary",
        top_padding = 8,
        bottom_padding = 8,
        mask = TRUE,
        background_img = "https://demos.creative-tim.com/argon-design-system/assets/img/theme/img-1-1200x1000.jpg",
        opacity = 6,
        argonH1("Header with mask", display = 1) %>% argonTextColor(color = "white"),
        argonLead("This is the content.") %>% argonTextColor(color = "white")
    )
)


# 1.1 Test: Alerts --------------------------------------------------------



alerts_tab <- argonTabItem(
    tabName = "alerts",
    argonH1("Alerts", display = 4),
    argonRow(
        argonColumn(
            width = 4,
            argonAlert(
                icon = argonIcon("basket"),
                status = "danger",
                "This is an alert",
                closable = TRUE
            )
        ),
        argonColumn(
            width = 4,
            argonAlert(
                icon = icon("bars"),
                status = "success",
                "This is an alert",
                closable = TRUE
            )
        ),
        argonColumn(
            width = 4,
            argonAlert(
                icon = argonIcon("app", color = "white"),
                status = "info",
                "This is an alert",
                closable = TRUE
            )
        )
    ),
    br(), br(),
    
    # Modals
    argonH1("Modals", display = 4),
    argonRow(
        
        # modal with gradient
        argonButton(
            name = "Click me!",
            status = "danger",
            icon = argonIcon("atom"),
            size = "lg",
            toggle_modal = TRUE,
            modal_id = "modal1"
        ),
        argonModal(
            id = "modal1",
            title = "This is a modal",
            status = "danger",
            gradient = TRUE,
            "YOU SHOULD READ THIS!",
            br(),
            "A small river named Duden flows by their place and supplies it with the necessary regelialia."
        ),
        
        # modal without gradient
        argonButton(
            name = "Click me!",
            status = "warning",
            icon = argonIcon("atom"),
            size = "lg",
            toggle_modal = TRUE,
            modal_id = "modal2"
        ),
        argonModal(
            id = "modal2",
            title = "This is a modal without gradient",
            status = "warning",
            gradient = FALSE,
            "YOU SHOULD READ THIS!",
            br(),
            "A small river named Duden flows by their place and supplies it with the necessary regelialia."
        ),
        
        # Modal without status not gradient
        argonButton(
            name = "Click me!",
            status = "info",
            icon = argonIcon("atom"),
            size = "lg",
            toggle_modal = TRUE,
            modal_id = "modal3"
        ),
        argonModal(
            id = "modal3",
            title = "This is a modal without gradient nor status",
            status = NULL,
            gradient = FALSE,
            "YOU SHOULD READ THIS!",
            br(),
            "A small river named Duden flows by their place and supplies it with the necessary regelialia."
        )
        
    )
)


output$cardUI <- renderUI({
    
    # result <- 
    #         dataframeTotal %>%
    #             filter(countryName == 'Mozambique')
    # 
    # v_confirmedCount <- result$confirmed
    
    
    
    # v_confirmedCount <- getConfirmedCount(countryName = 'South Africa')
    # 
    # v_confirmedCount <- prettyNum(v_confirmedCount, big.mark = ",")
    
    v_confirmedCount <- getCasesCount(countryName = input$countryNameInput, typeCase = 'confirmed')
    
    v_confirmedCount <- prettyNum(v_confirmedCount, big.mark = ",")
    
    
    v_recoveredCount <- getCasesCount(countryName = input$countryNameInput, typeCase = 'recovered')

    v_recoveredCount <- prettyNum(v_recoveredCount, big.mark = ",")


    v_deathCount <- getCasesCount(countryName = input$countryNameInput, typeCase = 'death')

    v_deathCount <- prettyNum(v_deathCount, big.mark = ",")

    v_ActiveCount <- getCasesCount(countryName = input$countryNameInput, typeCase = 'Unrecovered')

    v_ActiveCount <- prettyNum(v_ActiveCount, big.mark = ",")
    
    
# 1.1 getting Percentage for Recovered, Deaths and Unrecovered ---------------------------------------------

    v_ActivePerc <- getCasesPerc(dataframeTotal, countryName = input$countryNameInput, typeCase = 'Unrecovered')

    v_recoveredPerc <- getCasesPerc(dataframeTotal, countryName = input$countryNameInput, typeCase = 'recovered')

    v_deathsPerc <- getCasesPerc(dataframeTotal, countryName = input$countryNameInput, typeCase = 'death')

    

# 1.2 getting yesterday percentage ----------------------------------------

    v_ConfirmedYesterdayPerc <- getYesterdayPerc(data_actual = dataframeTotal, data_yesterday = df_TotalYesterdayCases, countryName = input$countryNameInput, typeCase = 'Confirmed')

    v_ActiveYesterdayPerc <- getYesterdayPerc(data_actual = dataframeTotal, data_yesterday = df_TotalYesterdayCases, countryName = input$countryNameInput, typeCase = 'Unrecovered')

    if (v_ActiveYesterdayPerc >= 0){

        v_stat_icon = icon("arrow-up") %>% argonTextColor(color = "orange")
    } else{

        v_stat_icon = icon("arrow-down") %>% argonTextColor(color = "orange")

    }


    v_RecoveredYesterdayPerc <- getYesterdayPerc(data_actual = dataframeTotal, data_yesterday = df_TotalYesterdayCases, countryName = input$countryNameInput, typeCase = 'recovered')

    v_DeathYesterdayPerc <- getYesterdayPerc(data_actual = dataframeTotal, data_yesterday = df_TotalYesterdayCases, countryName = input$countryNameInput, typeCase = 'death')

    
    
    tagList(
        
       
        
        argonR::argonRow(
            
# Color of the button : default, primary, warning, danger, success, royal.
        argonInfoCard(
            value = v_confirmedCount,
            title = "CONFIRMED",
            # stat = v_ConfirmedYesterdayPerc,
            # stat = h4(paste0(v_ConfirmedYesterdayPerc, '%')) %>% argonTextColor(color = "gray"),
            stat = h4(prettyNum(v_ConfirmedYesterdayPerc, big.mark = ",")) %>% argonTextColor(color = "gray"),
            stat_icon = icon("arrow-up") %>% argonTextColor(color = "gray"),
            # stat_icon = argonIcon("bold-up"),
            description = "Since yesterday",
            # #icon = icon("chart-bar"),
            icon = icon("users"),
            icon_background = "danger",
            hover_lift = TRUE,
            # background_color = "primary",
            background_color = 'default',
            gradient = TRUE
        ),

        argonInfoCard(
            value = v_ActiveCount,
            # value = paste0(v_ActiveCount, " (",v_ActivePerc,"%)"),
            title = "ACTIVE",
            # stat = paste0('(', v_ActivePerc, '%)'),
            # stat = h4(paste0(v_ActiveYesterdayPerc, '%')) %>% argonTextColor(color = "orange"),
            stat = h4(prettyNum(v_ActiveYesterdayPerc, big.mark = ",")) %>% argonTextColor(color = "orange"),
            # stat = -3.48,
            # stat_icon = icon("arrow-down") %>% argonTextColor(color = "white"),
            stat_icon = v_stat_icon,
            # # stat_icon = argonIcon("bold-down"),
            description = "Since yesterday",
            icon = icon("hospital"),
            icon_background = "warning",
            shadow = TRUE,
            # background_color = 'warning',
            background_color = 'default',
            gradient = TRUE
        ),

        argonInfoCard(
            value = v_recoveredCount,
            # value = paste0(v_recoveredCount, " (",v_recoveredPerc,"%)"),
            title = "RECOVERED",
            stat = h4(prettyNum(v_RecoveredYesterdayPerc, big.mark = ",")) %>% argonTextColor(color = "green"),
            # stat = h4(paste0(v_RecoveredYesterdayPerc, '%')) %>% argonTextColor(color = "green"),
            # stat = strong(paste0(v_recoveredPerc, '%')),
            stat_icon = icon("arrow-up") %>% argonTextColor(color = "green"),
            # stat_icon = argonIcon("bold-down"),
            description = "Since yesterday",
            icon = icon("smile"),
            icon_background = "success",
            shadow = TRUE,
            # background_color = 'primary',
            # status = "info"
            background_color = 'default'
            # background_color = 'success'
            # gradient = TRUE
        ),
        argonInfoCard(
            value = v_deathCount,
            # value = paste0(v_deathCount, " (",v_deathsPerc,"%)"),
            title = "DEATHS",
            stat = h4(prettyNum(v_DeathYesterdayPerc, big.mark = ",")) %>% argonTextColor(color = "red"),
            # stat = h4(paste0( v_DeathYesterdayPerc, '%')) %>% argonTextColor(color = "red"),
            # stat = 3.48,
            stat_icon = icon("arrow-up") %>% argonTextColor(color = "red") ,
            # # stat_icon = argonIcon("bold-up"),
            description = "Since yesterday",
            icon = icon("heartbeat"),
            icon_background = "danger",
            hover_lift = TRUE,
            background_color = 'default',
            # background_color = "danger",
            # gradient = FALSE
            shadow = TRUE,
            gradient = TRUE
        )
    ),
argonR::argonRow(
    argonColumn(
        width = 3,
        argonBadge(
            text = NULL,
            src = "https://www.google.com",
            pill = FALSE,
            status = "success"
        )
    ),
    argonColumn(
        width = 3,
        argonBadge(
            text = paste0("Active rate: ", v_ActivePerc, '%'),
            src = NULL,
            pill = TRUE,
            status = "warning"
        )
    ),
    argonColumn(
        width = 3,
        argonBadge(
            text = paste0("Recovered rate: ", v_recoveredPerc, '%'),
            src = NULL,
            pill = FALSE,
            status = "success"
        )
    ),
    argonColumn(
        width = 3,
        argonBadge(
            text = paste0("Deaths rate: ", v_deathsPerc, '%'),
            src = NULL,
            pill = FALSE,
            status = "danger"
        )
    )
)
    )
    
})



# 2.0 chartUI -------------------------------------------------------------

output$chartUI <- renderUI({
    
    tagList(
        
        # sections_tab,
        
        # alerts_tab
        
              argonCard(
                width = 12,
                # src = "https://www.google.com",
                # status = "success",
                # border_level = 0,
                # hover_shadow = TRUE,
                title = h2("Cases confirmed over time") %>% argonTextColor(color = "white"),
                background_color = 'default',
                # background_color = 'primary',

                radioGroupButtons(
                    inputId = "optChart_Id",
                    choiceNames = c("Daily", "Cumulative", "Fatality Rate"),
                    choiceValues = c("daily", "cumulative", "deaths"),
                    status = "secondary",
                    # status = "gray",
                    size = "normal",
                    individual = TRUE,
                    justified = TRUE
                    ),
                # prettyRadioButtons(
                #     inputId = "optChart_Id",
                #     inline = TRUE,
                #     # status = c("default", "primary", "success", "info", "danger", "warning")
                #     status = "default",
                #     # shape = c("round", "square", "curve"),
                #     shape = "curve",
                #     outline = TRUE,
                #     # fill = TRUE,
                #     thick = TRUE,
                #     # plain = TRUE,
                #     bigger = TRUE,
                #     # animation = c('smooth', 'jelly', 'tada', 'rotate', 'pulse'),
                #     animation = "pulse",
                #     label = NULL,
                #     # c("Daily" = "daily",
                #     #   "Cumulative" = "cumulative",
                #     #   "Fatality Rate" = "deaths")
                #     choiceNames = c("Daily", "Cumulative", "Fatality Rate"),
                #     choiceValues = c("daily", "cumulative", "deaths")
                # ),
                highchartOutput("hc_out_plot", height = "500px")
                # # New Cases per Day
                # hc_plot_NewCases(data = NewCases_tbl, countryName = input$countryNameInput, cumulative = FALSE)
            )

        )
            
    
})



# plotting the Cases ------------------------------------------------------

output$hc_out_plot <- renderHighchart({
    
    switch (input$optChart_Id,
            # New Cases per Day
            daily = hc_plot_NewCases(data = NewCases_tbl, countryName = input$countryNameInput, cumulative = FALSE),
            
            # Cumulative Cases per Day
            cumulative = hc_plot_NewCases(data = NewCases_tbl, countryName = input$countryNameInput, cumulative = TRUE),
            
            # Fatality Rate
            deaths = hc_plot_DeathsRate(data = NewCases_tbl, countryName = input$countryNameInput)
            )
})

