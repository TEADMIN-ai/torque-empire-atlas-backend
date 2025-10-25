future::plan("multisession")

shiny::runApp("shiny/app.R", port = 3838, host = "0.0.0.0", launch.browser = FALSE) &

pr <- plumber::plumb("api/api.R")
pr(host = "0.0.0.0", port = 8000)
