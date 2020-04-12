appLongName = "COVID-19 Data Visualization Platform"

if (interactive()) {
    library(shiny)
    library(argonR)
    library(argonDash)
    shinyApp(
        ui = argonDashPage(
            navbar = argonDashNavbar(),
            sidebar = argonDashSidebar(id = "mysidebar",
                                       dropdownMenus = NULL,
                                       brand_url = NULL,
                                       brand_logo = 'Tchingue_logo_v4.PNG',
                                       vertical = TRUE,
                                       side = 'left',
                                       size = 'md',
                                       skin = 'light',
                                       # skin = 'dark',
                                       background = 'white',
                                       # background_img = 'www/logo/Tchingue_logo_v4.PNG',
                                       # id = "my_sidebar",
                                       
                                       
                                       argonSidebarHeader(title = "Menu"),
                                       argonSidebarMenu(
                                           argonSidebarItem(
                                               tabName = "tab_dashboard", 
                                               style="text-align:center","Dashboard",
                                               icon = icon("dashboard")
                                           ),
                                           
                                           argonSidebarItem(
                                               tabName = "tab_table", 
                                               style="text-align:center","Tables",
                                               icon = icon("chart-bar-32")
                                           )
                                       )
                                       ),
            

# header ------------------------------------------------------------------

            header = argonDashHeader(
                gradient = TRUE,
                # color = NULL,
                color = 'primary',
                separator = TRUE,
                # separator_color = "secondary",
                bottom_padding = 4,
                top_padding = 6,
                background_img = NULL,
                mask = FALSE,
                opacity = 8,
                height = 600
                # argonRow(
                #     argonColumn(width = 8,
                #                 h4(appLongName, style = 'color:white;
                #        text-align:left;
                #        vertical-align: middle;
                #        font-size:40px;')
                #     )
                # )
                
            ),
            body = argonDashBody(),
            footer = argonDashFooter()
        ),
        server = function(input, output) { }
    )
}