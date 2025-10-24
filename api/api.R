# Torque Empire API - health & info endpoints
library(plumber)
library(jsonlite)

#* @apiTitle Torque Empire Backend API

# Health check endpoint
#* @get /health
function() {
  list(
    status = "ok",
    message = "Torque Empire backend is healthy 🚀",
    time = Sys.time()
  )
}

# Info endpoint
#* @get /info
function() {
  list(
    service = "Torque Empire Backend",
    version = "1.0.0",
    author = "Torque Empire DevOps",
    timestamp = Sys.time()
  )
}
