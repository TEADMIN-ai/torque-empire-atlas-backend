# 🧠 Torque Empire Backend - Clean Production Version

options(shiny.error = function(e) { 
  print(paste('💥 SHINY ERROR:', e)) 
  flush.console() 
})

print('🚀 Torque Empire Shiny app starting...')

library(shiny)

ui <- fluidPage(
  titlePanel("Torque Empire Backend ✅"),
  h3("Shiny Server is running correctly on Railway."),
  p("If you can see this, the deployment is successful."),
  br(),
  tags$footer("Powered by Torque Empire | © 2025")
)

server <- function(input, output, session) {
  # Future logic can go here
}

# ✅ Run the Shiny app
shinyApp(ui = ui, server = server)