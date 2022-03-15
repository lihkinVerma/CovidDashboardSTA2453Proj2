
ui_timeSeriesPlotPage_Ordinary <- function(id) {
  ns <- NS(id)
  tagList(
    tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: aqua;  color:black}
    .tabbable > .nav > li[class=active]    > a {background-color: black; color:white}
  ")),
    tabsetPanel(
      tabPanel(
        "Confirmed",
        box(
          title = "New Cases (past 24 hours)", status = "warning", solidHeader = TRUE, closable = FALSE, collapsible = TRUE, collapsed = FALSE, width = 22,
          ui_timeSeriesPlot(ns("timeSeriesPlt_confirmed_country"))
        ),
        box(
          title = "Cumulative", status = "warning", solidHeader = TRUE, closable = FALSE, collapsible = TRUE, collapsed = FALSE, width = 22,
          ui_timeSeriesPlot(ns("timeSeriesPlt_cumConfirmed_country"))
        )
      ),
      tabPanel(
        "Death",
        box(
          title = "New Cases (past 24 hours)", status = "warning", solidHeader = TRUE, closable = FALSE, collapsible = TRUE, collapsed = FALSE, width = 22,
          ui_timeSeriesPlot(ns("timeSeriesPlt_death_country"))
        ),
        box(
          title = "Cumulative", status = "warning", solidHeader = TRUE, closable = FALSE, collapsible = TRUE, collapsed = FALSE, width = 22,
          ui_timeSeriesPlot(ns("timeSeriesPlt_cumDeath_country"))
        )
      ),
      tabPanel(
        "Recovered",
        box(
          title = "New Cases (past 24 hours)", status = "warning", solidHeader = TRUE, closable = FALSE, collapsible = TRUE, collapsed = FALSE, width = 22,
          ui_timeSeriesPlot(ns("timeSeriesPlt_recovered_country"))
        ),
        box(
          title = "Cumulative", status = "warning", solidHeader = TRUE, closable = FALSE, collapsible = TRUE, collapsed = FALSE, width = 22,
          ui_timeSeriesPlot(ns("timeSerisPlt_cumRecovered_country"))
        )
      )
    )
  )
}

server_timeSeriesPlotPage_Ordinary <- function(input, output, session, data) {
  callModule(server_timeSeriesPlot, "timeSeriesPlt_confirmed_country",
    data = data,
    var2show = "Cases", "confirmed_country", FALSE, n = 1
  )

  callModule(server_timeSeriesPlot, "timeSeriesPlt_cumConfirmed_country",
    data = data,
    var2show = "cum_cases", "cumConfirmed_country", FALSE, n = 1, showLog = TRUE
  )

  callModule(server_timeSeriesPlot, "timeSeriesPlt_death_country",
    data = data,
    var2show = "Deaths", "death_country", FALSE, n = 1
  )

  callModule(server_timeSeriesPlot, "timeSeriesPlt_cumDeath_country",
    data = data,
    var2show = "cum_death", "ordcum_death", FALSE, n = 1
  )

  callModule(server_timeSeriesPlot, "timeSeriesPlt_recovered_country",
    data = data,
    var2show = "Recovered", "cumDeath_country", FALSE, n = 1
  )

  callModule(server_timeSeriesPlot, "timeSerisPlt_cumRecovered_country",
    data = data,
    var2show = "cum_recovered", "cumRecovered_country", FALSE, n = 1
  )
}

ui_timPage <- function(id) {
  ns <- NS(id)
  ui_timeSeriesPlotPage_Ordinary(ns("Ordinary"))
}

server_timPage <- function(input, output, session, data) {
  callModule(server_timeSeriesPlotPage_Ordinary, "Ordinary", data)
  #callModule(server_timeSeriesPlotPage_Proportion, "Proportion", data)
}

ui <- dashboardPage(header = dashboardHeader(), sidebar = dashboardSidebar(), dashboardBody(
  ui_timPage("f_1")
))
server <- function(input, output) {
  data <- DataDownload()
  callModule(server_timPage, "f_1", data)
}

shinyApp(ui, server)
