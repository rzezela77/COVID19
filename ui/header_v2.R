header <- argonDashHeader(
    #options
    gradient = TRUE, 
    # color = "default",
    color = "primary",
    # separator = FALSE, 
    separator = TRUE,
    separator_color = "secondary",
    background_img = NULL,
    mask = FALSE, 
    opacity = 8, 
    top_padding = 2,
    bottom_padding = 0,
    height = 70,
    argonH1("Tracking COVID-19", display = 1) %>% argonTextColor(color = "white"),
    argonLead("#VaiFicarTudoBem.") %>% argonTextColor(color = "white")
)