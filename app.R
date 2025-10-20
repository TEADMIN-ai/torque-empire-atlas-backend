# 🧠 Torque Empire Backend - Hybrid Shiny + Plumber API
print('🚀 Starting Torque Empire Backend (Shiny + API) ...')

library(shiny)
library(plumber)
library(future)

# ---- SHINY UI ----
ui <- fluidPage(
  titlePanel("Torque Empire Backend ✅"),
  h3("Shiny Server is running correctly on Railway."),
  p("If you can see this, the deployment is successful."),
  br(),
  tags$footer("Powered by Torque Empire | © 2025")
)

server <- function(input, output, session) {}

# ---- API ----
future::plan(future::multisession)

# Load your Plumber API from api.R
api <- plumber::plumb("api.R")

future::future({
  print("⚙️ Starting Torque Empire API on port 8000 ...")
  api$run(host = "0.0.0.0", port = 8000)
})

# ---- Run Shiny ----
shinyApp(ui, server)