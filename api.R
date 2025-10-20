# ?? Torque Empire Backend API
library(plumber)

#* @apiTitle Torque Empire API

#* Health check
#* @get /
function() {
  list(status = "online", service = "Torque Empire API", year = 2025)
}

#* Clients endpoint
#* @get /api/clients
function() {
  list(
    clients = list(
      list(id = 1, name = "John Doe", email = "john@torqueempire.co.za"),
      list(id = 2, name = "Jane Smith", email = "jane@torqueempire.co.za")
    )
  )
}

#* Finance endpoint
#* @get /api/finance
function() {
  list(
    totalRevenue = 250000,
    expenses = 80000,
    profit = 170000
  )
}
