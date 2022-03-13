
library(shiny)
library(DT)
library(shinycssloaders)

server <- function(input, output) {
  data <- DataDownload()
  output$tblData <- renderDT(
    server = F,
    datatable(
      data,
      colnames = c(
        "Date Reported", "Country", "Cumulative confirmed cases", "Cumulative deaths",
        "Cumulative recoveries", "New cases", "New deaths", "New recoveries", "Population"
      ), extensions = "Buttons",
      options = list(
        dom = "Bfrtip",
        buttons = list(extend = "csv", text = "download"),
        filename = "data",
        exportOptions = list(
          modifier = list(page = "all")
        )
      )
    )
  )
  data_cont <- continent_data(data)
  observeEvent(input$tabs,
    switch(input$tabs,
      "mainPage_country" = callModule(server_mainBody_Page, "mainPage__country", data),
      "mainPage_continent" = callModule(server_mainBody_Page, "mainPage__continent", data_cont),
      "overview_page" = callModule(server_overviewBody_Page, "overview__page", data),
      "rankPage_confirmed" = callModule(server_rankBody_Page, "rankPage__confirmed", data, 'Cases'),
      "rankPage_deaths" = callModule(server_rankBody_Page, "rankPage__deaths", data, 'Deaths'),
      "rankPage_recovered" = callModule(server_rankBody_Page, "rankPage__recovered", data, 'Recovered'),
      "rankPage_confirmed_cont" = callModule(server_rankBody_Page, "rankPage__confirmed__cont", data_cont, 'Cases', TRUE),
      "rankPage_deaths_cont" = callModule(server_rankBody_Page, "rankPage__deaths__cont", data_cont, 'Deaths', TRUE),
      "rankPage_recovered_cont" = callModule(server_rankBody_Page, "rankPage__recovered__cont", data_cont, 'Recovered', TRUE),
      "tim_Country" = callModule(server_timPage, "tim_CountryPage", data),
      "tim_Continent" = callModule(server_timPage, "tim_ContinentPage", data_cont),
      "map_ord_country" = callModule(server_leafMap_Page, "Ordinary_map", data),
      # "moran" = callModule(server_moran_page, "moran", data)
    ),
    ignoreNULL = TRUE, ignoreInit = TRUE
  )
}
