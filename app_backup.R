options(shiny.error = function(e) { print(paste('?? SHINY ERROR:', e)); flush.console() })
print('?? Torque Empire Shiny app starting...')
library(shiny)

ui <- fluidPage(
  titlePanel("Torque Empire Backend ✅"),
  h3("Shiny Server is running correctly on Railway."),
  p("If you can see this, the deployment is successful."),
  br(),
  tags$footer("Powered by Torque Empire | © 2025")
)

server <- function(input, output, session) {}

# Use Railway's assigned port (default 3838)
port <- as.numeric(Sys.getenv("PORT", 3838))
shiny::runApp(shinyApp(ui, server), host = "0.0.0.0", port = port)

