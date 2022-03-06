library(shiny)
library(plotly)
library(dplyr)
library(shinycssloaders)

f_labels <- function(x) {
  switch(x,
    "Cases" = return("New cases"),
    "cum_cases" = return("Cumulative confirmed cases"),
    "Deaths" = return("New deaths"),
    "cum_death" = return("Cumulative deaths"),
    "Recovered" = return("New recovereis"),
    "cum_recovered" = return("Cumulative recoveries")
  )
}

ui_pieCharts <- function(id) {
  ns <- NS(id)
  tagList(
    sliderInput(ns("inp"), label = "Day", min = 1, max = 10, value = 10, step = 2, width = "400px", animate = TRUE),
    withSpinner(plotlyOutput(ns("plt")), type = 6)
  )
}

server_pieCharts <- function(input, output, session, data, Var2show) {
  #print(Var2show)
  ns <- session$ns
  observe(
    updateSliderInput(
      session = session, inputId = "inp", step = 2,
      label = paste0("Day (", f_labels(Var2show), ")"), min = 1, max = length(unique(data$DateRep)), value = length(unique(data$DateRep))
    )
  )
  data_new <- reactive({
    data %>%
      filter(as.character(DateRep) %in% as.character(max(ordered(DateRep))), Countries != "World") %>%
      arrange(get(Var2show)) %>%
      tail(10)
  })

  data_2tal_cases <- reactive({
    data %>% filter(as.character(DateRep) %in% as.character(unique(data$DateRep)[input$inp]), Countries != "World")
  })
  
  output$plt <- renderPlotly({
    df <- data_2tal_cases() %>%
      arrange(get(Var2show)) %>%
      tail(10) %>%
      mutate(Countries2 = factor(Countries, levels = Countries))
    values_for_pie = as.list(df[[Var2show]])
    labels_for_pie = as.list(df[['Countries']])
    #list2env(list(df = df),.GlobalEnv)
    data_new() %>%
      plot_ly( marker =list(color = ~Countries,colorscale = 'Accent')) %>%
      add_pie(values = values_for_pie, labels = labels_for_pie, textinfo='label+percent',
              insidetextorientation='radial', hole = 0.5) %>%
      layout(#title = "Put some specific title here",  
             showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
  })
}

ui <- fluidPage(
  ui_pieCharts("f_1")
)
server <- function(input, output) {
  data <- DataDownload()
  data2 <- compute_cum_ranks(data)
  callModule(server_pieCharts, "f_1", data2, "Cases")
}
shinyApp(ui, server)
