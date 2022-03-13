
ui_overviewBody_Page <- function(id) {
  ns <- NS(id)
  tagList(
    ui_overviewBody(ns("uiOverview_ord"))
  )
}
server_overviewBody_Page <- function(input, output, session, data) {
  data2 <- compute_cum_ranks(data)

  callModule(server_overviewBody, "uiOverview_ord", data = data2)
}
