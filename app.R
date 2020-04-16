if(interactive()){
    library(shiny)
    library(argonR)
    library(argonDash)
    
    # library(tidyverse)
    library(shinycssloaders)
    
    source(file = 'ui/header.R')
    source(file = 'ui/body.R')
    source(file = 'ui/dashboardUI.R')
    # source(file = 'ui/sidebar.R')
    
    source(file = 'global.R')
    source(file = 'getFunctions.R')
    
    source(file = 'CSS.R')
    
    shiny::shinyApp(
        
        ui = argonDashPage(
            title = "Dashboard for tracking COVID-19", 
            description = "Track COVID-19 Dashboard", 
            author = "Reinaldo Zezela",
            navbar = NULL, 
            sidebar = NULL, 
            header = header,
            body = body,
            footer = argonDashFooter(
                copyrights = tagList(
                    "by Reinaldo Zezela.",
                    "Built with",
                    img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30"),
                    "by",
                    img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30"),
                    "and with", img(src = "love.png", height = "30"),
                    "."
                ),
                HTML(
                    paste(
                        "2020,", 
                        a(href = "https://reinaldozezela.netlify.com/", "Tchingue powered", target = "_blank")
                    )
                )
            )
        ),
        

# server ------------------------------------------------------------------
        server = function(input, output) {
            
            source(file = "server/01_srv_dashboard_COVID19.R", local = TRUE)
        }
    )
}
