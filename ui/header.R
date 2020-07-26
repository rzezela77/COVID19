header <- argonDashHeader(
    #options
    gradient = TRUE, 
    # color = "default",
    color = "primary",
    # color = "warning",
    # separator = FALSE, 
    separator = TRUE,
    separator_color = "info",
    # bottom_padding = 4, 
    # top_padding = 6, 
    background_img = NULL,
    mask = FALSE, 
    opacity = 8, 
    # height = 600,
    top_padding = 2,
    bottom_padding = 0,
    # background_img = "coronavirus.jpg",
    height = 70,
    argonH1("Tracking COVID-19", display = 1) %>% argonTextColor(color = "white"),
    argonLead(strong("#VaiFicarTudoBem.")) %>% argonTextColor(color = "white")
    
    # # elements
    # stabilityUi(id = "stability")
)