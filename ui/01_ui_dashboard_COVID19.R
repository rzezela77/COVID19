# ##################################################################
# 01 - Dashboard                                                   #    
####################################################################

frow_InfoCard <- 
    # fluidRow(
    argonR::argonRow(
        argonInfoCard(
            value = "350,897",
            title = "TRAFFIC",
            stat = 3.48,
            stat_icon = icon("arrow-up"),
            # stat_icon = argonIcon("bold-up"),
            description = "Since last month",
            icon = icon("chart-bar"),
            icon_background = "danger",
            hover_lift = TRUE
        ),
        argonInfoCard(
            value = textOutput("value"),
            title = "NEW USERS",
            stat = -3.48,
            stat_icon = icon("arrow-down"),
            # stat_icon = argonIcon("bold-down"),
            description = "Since last week",
            icon = icon("chart-pie"),
            icon_background = "warning",
            shadow = TRUE
        ),
        argonInfoCard(
            value = "924",
            title = "SALES",
            stat = -1.10,
            stat_icon = icon("arrow-down"),
            # stat_icon = argonIcon("bold-down"),
            description = "Since yesterday",
            icon = icon("users"),
            icon_background = "yellow",
            background_color = "default"
        ),
        argonInfoCard(
            value = "49,65%",
            title = "PERFORMANCE",
            stat = 12,
            stat_icon = icon("arrow-up"),
            # stat_icon = argonIcon("bold-up"),
            description = "Since last month",
            icon = icon("percent"),
            icon_background = "info",
            gradient = TRUE,
            background_color = "orange",
            hover_lift = TRUE
        )
    )

frow_test <- argonRow(
    
    argonColumn(width = 12, style = "background-color:#4d3a7d", height = "500px",
           argonInfoCard(
               value = "350,897",
               title = "TRAFFIC",
               stat = 3.48,
               stat_icon = icon("arrow-up"),
               # stat_icon = argonIcon("bold-up"),
               description = "Since last month",
               icon = icon("chart-bar"),
               icon_background = "danger",
               hover_lift = TRUE
           )
    )
    
)



# tabItem(tabName = "tab_dashboard", frow_InfoCard)

# argonTabItem(tabName = "tab_dashboard", frow_InfoCard, frow_test)



# # analysis setting tab -----
#     dashboard_row <- argonRow(
#         
#         argonRow(
#             argonColumn(
#                 width = 12,
#                 uiOutput("cardUI") %>% withSpinner()
#             )
#         ),
#         tags$hr(),
#         argonRow(
#             argonColumn(
#                 width = 12,
#                 uiOutput("chartUI") %>% withSpinner()
#             )
#         ),
#         conditionalPanel(condition = "$('html').hasClass('shiny-busy')",
#                          tags$div("Loading Page!!! Please wait...",id = "loadmessage")),
#         argonRow(
#             argonColumn(
#                 width = 12,
#                 dataTableOutput("dataTableCountryWise") %>% withSpinner()
#                 
#             )
#         )
#     )


dashboard_cardUI <- 
argonRow(
    argonColumn(
        width = 12,
        uiOutput("cardUI")  %>% withSpinner()
    )
)


dashboard_chartUI <- 
argonRow(
    argonColumn(
        width = 12,
        uiOutput("chartUI") 
        # %>% withSpinner()
    )
)

argonTabItem(tabName = "tab_dashboard", dashboard_cardUI, dashboard_chartUI)        
        
    
 


