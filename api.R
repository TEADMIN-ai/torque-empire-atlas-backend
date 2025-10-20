# 🚀 Torque Empire API
library(plumber)

#* @apiTitle Torque Empire API
#* @apiDescription REST endpoints for CRM frontend.

#* @get /api/clients
function() {
  list(
    list(id = 1, name = "John Doe", email = "john@torqueempire.co.za"),
    list(id = 2, name = "Jane Smith", email = "jane@torqueempire.co.za"),
    list(id = 3, name = "Ava Moyo", email = "ava@torqueempire.co.za")
  )
}

#* @get /api/finance
function() {
  list(
    revenue = 154230,
    expenses = 65800,
    profit = 88430
  )
}