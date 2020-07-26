body = argonDashBody(
    
    # dashboardUI
    
    # CSS, #CSS.R
    
    argonTabSet(
        id = "tab_Menu",
        card_wrapper = T,
        horizontal = TRUE,
        circle = F,
        size = "sm",
        width = 12,
        iconList = list(
            icon("home"),
            icon("tachometer-alt"), 
            # icon("laptop-code"), 
            icon("globe"), 
            icon("chart-bar"),
            icon("chart-line"),
            icon("twitter")
        ),
        argonTab(
            tabName = "Home",
            active = T,
            # uiOutput("homeUI") %>% withSpinner()
            argonRow(
                
                argonColumn(
                           width = 4,
                           img(src = 'cdc-k0KRNtqcjfw-unsplash.jpg',width = "100%"),
                           h6("Source: Photo by CDC on Unsplash",style = 'text-align:center;
                    font-style: italic;font-weight: bold;')
                       ),
                argonColumn(
                    width = 4,
                    argonAlert(
                        icon = argonIcon("watch-time"),
                        status = "primary",
                        paste("Alert for last updated Data: ", getMaxDate(coronavirus)),
                        closable = TRUE
                    )
                ),
                # argonColumn(
                #     width = 4
                #     # img(src = 'covidGif.gif',width = "100%",height = "80%"),
                #     # h6("Source: Giphy",style = 'text-align:center;font-style: italic;font-weight: bold;')
                # ),
                argonColumn(
                            width = 4,
                            img(src = 'covidGif.gif',width = "100%",height = "80%"),
                            h6("Source: Giphy",style = 'text-align:center;font-style: italic;font-weight: bold;')
                        )
                
                
             #    argonColumn(
             #        width = 4,
             #        img(src = 'Tchingue_Consulting_v3.PNG',width = "100%"),
             #        h6("Source: Wikipedia",style = 'text-align:center;
             # font-style: italic;font-weight: bold;')
             #    ),
                # argonColumn(
                #     width = 5,
                #     h1("Import argonDash elements inside shiny!", align = "center"),
                #     h5("Don't need any sidebar, navbar, ...", align = "center"),
                #     h5("Only focus on basic elements for a pure interface", align = "center"),
                #     # p("A new invisible enemy, only 30kb in size, has emerged and is on a killing spree around the world: 2019-nCoV, the Novel Coronavirus!"),
                #      h5("A new invisible enemy, only 30kb in size, has emerged and is on a killing spree around the world: 2019-nCoV, the Novel Coronavirus!",style = 'text-align:justify;'),
                #     # p("In right we can see some precautionary measures to prevent spread of Coronavirus.",style = 'text-align:justify;'),
                #     tags$br(),
                #     # p("This monitor was developed to make the data and key visualizations of COVID-19 trends available to everyone and also provide a platform to conduct a sentiment analysis of social media posts using Natural Language Processing (NLP).",style = 'text-align:justify;')
                #     p("This monitor was developed to make the data and key visualizations of COVID-19 trends available to everyone and also provide a platform to conduct a sentiment analysis of social media posts using Natural Language Processing (NLP).")
                # )
            #     argonColumn(
            #         width = 3,
            #         img(src = 'covidGif.gif',width = "100%",height = "80%"),
            #         h6("Source: Giphy",style = 'text-align:center;font-style: italic;font-weight: bold;')
            #     )
            #     
            # ),
            # p("This monitor has 3 tabs: Dashboard, Comparison and Sentiments. Dashboard allows user to view a complete picture of COVID-19 spread around the world. User can also click on any country in the map to view the numbers in that country. In Comparison tab user can compare the spread of COVID-19 in multiple countries in one view. Sentiment tab allows user to run a sentiment analysis of trending hashtags of coronavirus on social media.",style = 'text-align:justify;'),
            # tags$br(),
            # h4("Important Note:",style = 'color:Red;font-size:15px;text-align:Left;'),
            # p("1. The data used in this dashboard taken from WHO website. In case of any discrepancy in the numbers please contact with developer.",style = 'color:Red;font-size:13px;text-align:Left;'),
            # p(paste0("2. Dashboard will be updated on daily basis at GMT 00:00. It could be a chance that daily numbers not match as per your local source but aggregate numbers will definitely match."),style = 'color:Red;font-size:13px;text-align:Left;'),
            # p(paste0("3. Last update: ",lastUpdate),style = 'color:Red;font-size:13px;text-align:Left;')
            # 
        )
        ),
        argonTab(
            tabName = "Dashboard",
            active = F,
            # uiOutput("dashboardUI") %>% withSpinner()
            uiOutput("cardUI") %>% withSpinner(),
            tags$br(),
            
            # country_choices <- levels(dataframeTotal$countryName),
            
            argonRow(
                argonColumn(
                    width = 4,
                    pickerInput(
                        inputId = "countryNameInput",
                        label = strong("Select country:"),
                        choices = c("All", levels(dataframeTotal$countryName)),
                        # selected = levels(dataframeTotal$countryName),
                        # multiple = TRUE,
                        selected = "All",
                        width = "100%",
                        options = list(`live-search` = TRUE
                                       # `select-all-text` = "Yeah, all !"
                                       ),
                        inline = F
                        )
                )
                
            ),
            
            argonRow(
                argonColumn(
                    width = 12,
                    uiOutput("chartUI") %>% withSpinner()
                    )
                )
        ),
        argonTab(
            tabName = "World Map",
            active = F,
            uiOutput("worldMapUI") %>% withSpinner()
            
        ),
        
# in development
        # argonTab(
        #     tabName = "Comparison",
        #     active = F,
        #     uiOutput("comparisonUI") %>% withSpinner()
        #     
        # ),

        argonTab(
            tabName = "Forecasting",
            active = F,
            argonRow(
                argonColumn(
                    width = 4,
                    pickerInput(
                        inputId = "countryNameInput_v2",
                        label = strong("Select country:"),
                        choices = levels(dataframeTotal$countryName),
                        selected = "Mozambique",
                        width = "100%",
                        options = list(`live-search` = TRUE),
                        inline = F
                    )
                )
            ),
            uiOutput("forecastUI") %>% withSpinner()
        )
    )
)