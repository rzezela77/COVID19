#################################################################
## serverDashboard.R
#################################################################



# 1.0 cardUI --------------------------------------------------------------


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
    
    
    # getting Percentage for Recovered, Deaths and Unrecovered
    
    v_ActivePerc <- getCasesPerc(dataframeTotal, countryName = input$countryNameInput, typeCase = 'Unrecovered')
    
    v_recoveredPerc <- getCasesPerc(dataframeTotal, countryName = input$countryNameInput, typeCase = 'recovered')
    
    v_deathsPerc <- getCasesPerc(dataframeTotal, countryName = input$countryNameInput, typeCase = 'death')
    
    
    
    tagList(
        
       
        
        argonR::argonRow(
            
            # argonColumn(
            #     width = 3,
            #     argonBadge(text = paste0("Active: ",prettyNum(v_confirmedCount,big.mark = ",")
            #                              # " (",activeCasesPer,"%)"
            #     ), 
            #     src = NULL, 
            #     pill = T, 
            #     status = "info"),
            #     h6(paste0("Yesterday: ",
            #               prettyNum(75,
            #                         big.mark = ",")
            #     )
            #     )
            #     ),
            

            
# Color of the button : default, primary, warning, danger, success, royal.
        argonInfoCard(
            value = v_confirmedCount,
            title = "CONFIRMED",
            # stat = 3.48,
            # stat_icon = icon("arrow-up"),
            # stat_icon = argonIcon("bold-up"),
            # description = "Since last month",
            # #icon = icon("chart-bar"),
            icon = icon("users"),
            icon_background = "danger",
            hover_lift = TRUE,
            # background_color = "orange"
            background_color = 'default',
            gradient = TRUE
        ),
        
        argonInfoCard(
            value = v_ActiveCount, 
            # value = paste0(v_ActiveCount, " (",v_ActivePerc,"%)"),
            title = "ACTIVE",
            # stat = paste0('(', v_ActivePerc, '%)'),
            stat = h4(paste0(v_ActivePerc, '%')) %>% argonTextColor(color = "white"),
            # stat = -3.48,
            stat_icon = icon("arrow-down") %>% argonTextColor(color = "white"),
            # # stat_icon = argonIcon("bold-down"),
            description = "Since yesterday",
            icon = icon("hospital"),
            icon_background = "warning",
            shadow = TRUE,
            # background_color = 'warning'
            background_color = 'default',
            gradient = TRUE
        ),
        
        argonInfoCard(
            value = v_recoveredCount, 
            # value = paste0(v_recoveredCount, " (",v_recoveredPerc,"%)"),
            title = "RECOVERED",
            stat = h4(paste0(v_recoveredPerc, '%')) %>% argonTextColor(color = "green"),
            # stat = strong(paste0(v_recoveredPerc, '%')),
            stat_icon = icon("arrow-down") %>% argonTextColor(color = "green"),
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
            stat = h4(paste0( v_deathsPerc, '%')) %>% argonTextColor(color = "red"),
            # stat = shiny::p(v_deathsPerc),
            # stat = 3.48,
            stat_icon = icon("arrow-up") %>% argonTextColor(color = "red"),
            # # stat_icon = argonIcon("bold-up"),
            description = "Since yesterday",
            icon = icon("heartbeat"),
            icon_background = "danger",
            hover_lift = TRUE,
            background_color = 'default',
            # gradient = FALSE
            shadow = TRUE,
            gradient = TRUE
            # background_color = "blue"
        )
    ),
argonR::argonRow(
    argonColumn(
        width = 3,
        argonBadge(
            text = "My badge",
            src = "https://www.google.com",
            pill = FALSE,
            status = "success"
        )
    ),
    argonColumn(
        width = 3,
        argonBadge(
            text = "My badge",
            src = "https://www.google.com",
            pill = FALSE,
            status = "warning"
        )
    ),
    argonColumn(
        width = 3,
        argonBadge(
            text = "My badge",
            src = "https://www.google.com",
            pill = FALSE,
            status = "primary"
        )
    ),
    argonColumn(
        width = 3,
        argonBadge(
            text = "My badge",
            src = "https://www.google.com",
            pill = FALSE,
            status = "green"
        )
    )
)
    )
    
})



# 2.0 chartUI -------------------------------------------------------------

output$chartUI <- renderUI({
    
    tagList(
        
        argonCard(
                        # src = "https://www.google.com",
                        # status = "success",
                        # border_level = 0,
                        # hover_shadow = TRUE,
                        title = h3("Cases confirmed over time") %>% argonTextColor(color = "white"),
                        background_color = 'default',
                        prettyRadioButtons(
                                    inputId = "dist",
                                    inline = TRUE,
                                    # shape = c("round", "square", "curve"),
                                    shape = "curve",
                                    animation = "pulse",
                                    label = "Distribution type:",
                                    c("Normal" = "norm",
                                      "Uniform" = "unif",
                                      "Log-normal" = "lnorm",
                                      "Exponential" = "exp")
                                ),
                        # New Cases per Day
                        hc_plot_NewCases(data = NewCases_tbl, countryName = input$countryNameInput, cumulative = FALSE)
                        )
        
    )
        
        # # argonRow(
        # #     sections_tab
        # # )
        # 
        # argonR::argonRow(
        #     argonColumn(
        #         width = 6,
        # 
        #         # sections_tab,
        # 
        #         # prettyRadioButtons(
        #         #     inputId = "dist",
        #         #     inline = TRUE,
        #         #     # shape = c("round", "square", "curve"),
        #         #     shape = "curve",
        #         #     animation = "pulse",
        #         #     label = "Distribution type:",
        #         #     c("Normal" = "norm",
        #         #       "Uniform" = "unif",
        #         #       "Log-normal" = "lnorm",
        #         #       "Exponential" = "exp")
        #         # ),
        # 
        #         argonCard(
        #             # src = "https://www.google.com",
        #             # status = "success",
        #             # border_level = 0,
        #             # hover_shadow = TRUE,
        #             title = "Card with Margins",
        #             # New Cases per Day
        #             hc_plot_NewCases(data = NewCases_tbl, countryName = input$countryNameInput, cumulative = FALSE)
        #             )
        #         ),
        #     argonColumn(
        #         width = 6,
        #         # Cumulative Cases per Day
        #         # hc_plot_NewCases(data = NewCases_tbl, countryName = 'Mozambique', cumulative = TRUE)
        # 
        #         # Fatality Rate
        #         hc_plot_DeathsRate(data = NewCases_tbl, countryName = input$countryNameInput)
        #     )
        # 
        # )
    # )
    
    
    
})

