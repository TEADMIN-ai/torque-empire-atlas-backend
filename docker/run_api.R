library(plumber)

# Load the plumber API from the api/ directory
pr <- plumb("api/main.R")

# Run on port 8000, listen on all interfaces
pr$run(host = "0.0.0.0", port = 8000)
