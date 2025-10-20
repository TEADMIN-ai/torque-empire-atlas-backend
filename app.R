# ?? Torque Empire Backend - Clean Hybrid Version

options(shiny.error = function(e) { 
  print(paste('?? SHINY ERROR:', e)) 
  flush.console() 
})

print('?? Torque Empire Backend starting...')

library(shiny)

ui <- fluidPage(
  titlePanel("Torque Empire Backend ?"),
  h3("Shiny + API server running correctly on Railway."),
  p("If you can see this, deployment and API integration are successful."),
  br(),
  tags("Powered by Torque Empire | © 2025")
)

server <- function(input, output, session) {}

shinyApp(ui = ui, server = server)
