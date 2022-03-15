
# -------------------------------------------------------
# Defining ui and server
# -------------------------------------------------------
ui_rankBody_Page <- function(id, var2View, is_continent=FALSE) {
  ns <- NS(id)
  tagList(
    ui_rankBody(ns("uiRank_country"), var2View, is_continent)
  )
}

server_rankBody_Page <- function(input, output, session, data, var2show, is_continent = FALSE) {
  data2 <- compute_cum_ranks(data)

  callModule(server_rankBody, "uiRank_country", data = data2, var2show, is_continent)
}
