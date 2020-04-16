frow_InfoCard_tables <- 
    fluidRow(
        argonInfoCard(
            value = "350,897",
            title = "TRAFFIC",
            stat = 3.48,
            stat_icon = icon("arrow-up"),
            # stat_icon = argonIcon("bold-up"),
            description = "Since last month",
            icon = icon("chart-bar"),
            icon_background = "danger",
            hover_lift = TRUE,
            background_color = 'default'
        )
    )

argonTabItem(tabName = "tab_table", frow_InfoCard_tables)
