
ui_overviewBody_Page <- function(id) {
  ns <- NS(id)
  tagList(
    radioGroupButtons(ns("ordinary_Proportion1"), 
                      choices = c("Absolute counts", "Relative counts"), 
                      selected = "Absolute counts", 
                      justified = TRUE, 
                      status = "primary"),
    conditionalPanel("input.ordinary_Proportion1 == 'Absolute counts'",
      ns = ns,
      ui_overviewBody(ns("uiOverview_ord"))
    ),
    conditionalPanel("input.ordinary_Proportion1 == 'Relative counts'",
      ns = ns,
      ui_overviewBody(ns("uiOverview_prop"), FALSE)
    )
  )
}
server_overviewBody_Page <- function(input, output, session, data) {
  data2 <- compute_cum_ranks(data)
  data_prop <- compute_proportion(data, pop = data$Population, n = 1e6)
  data_prop <- compute_cum_ranks(data_prop)

  callModule(server_overviewBody, "uiOverview_ord", data = data2)
  callModule(server_overviewBody, "uiOverview_prop", data_prop)
}
