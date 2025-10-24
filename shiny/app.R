# Torque Empire Shiny App + Integrated API Healthcheck

options(shiny.error = function(e) {
  print(paste("💥 SHINY ERROR:", e))
  flush.console()
})

print("⚙️ Starting Torque Empire unified backend...")

library(shiny)
library(jsonlite)

# ---- UI ----
ui <- fluidPage(
  titlePanel("Torque Empire Backend ✅"),
  h3("Shiny Server is running correctly on Railway."),
  p("If you can see this, the deployment is successful."),
  br(),
  tags$footer("Powered by Torque Empire | © 2025")
)

# ---- Server ----
server <- function(input, output, session) {
  output$health <- renderText({
    paste("Torque Empire is healthy ✅", Sys.time())
  })
}

# ---- Run App ----
port <- as.numeric(Sys.getenv("PORT", 3838))
host <- "0.0.0.0"

print(sprintf("🌐 Launching Torque Empire Shiny on %s:%d", host, port))
shiny::runApp(shinyApp(ui, server), host = host, port = port, launch.browser = FALSE)
