
# -------------------------------------------------------
# Defining ui and server
# -------------------------------------------------------
ui_leafMap_Page <- function(id) {
  ns <- NS(id)
  tabsetPanel(
    tabPanel(
      "Confirmed",
      ui_leafMap(ns("map_case_ord_country"))
    ),
    tabPanel(
      "Death",
      ui_leafMap(ns("map_death_ord_country"))
    ),
    tabPanel(
      "Recovered",
      ui_leafMap(ns("map_recovered_ord_country"))
    )
  )
}

server_leafMap_Page <- function(input, output, session, data) {
  data2 <- compute_cum_ranks(data)
  callModule(server_leafMap, "map_case_ord_country", data2, var2show = "case")
  callModule(server_leafMap, "map_death_ord_country", data2, var2show = "death")
  callModule(server_leafMap, "map_recovered_ord_country", data2, var2show = "recovered")
}

# -------------------------------------------------------
# just for testing File
# -------------------------------------------------------
ui <- fluidPage(
  ui_leafMap_Page("f_1")
)
server <- function(input, output) {
  data <- DataDownload()
  callModule(server_leafMap_Page, "f_1", data)
}
shinyApp(ui, server)
