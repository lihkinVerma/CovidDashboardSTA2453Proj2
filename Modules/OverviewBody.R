library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(plotlyGeoAssets)
library(dplyr)

# -------------------------------------------------------
# Defining ui and server
# -------------------------------------------------------
ui_overviewBody <- function(id, ProportionShow = TRUE) {
  ns <- NS(id)
  tagList(
      if (ProportionShow) {
        tagList(
          h1("New Case count (during the past 24 hours)", align = "center"),
          fluidRow(
            column(4,valueBoxOutput("box1foroverview", width = 12)),
            withSpinner(infoBoxOutput(ns("inf_this_day_case"), width = 4), type = 6), 
            align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box2foroverview", width = 12)),
            infoBoxOutput(ns("inf_this_day_death"), width = 4), align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box3foroverview", width = 12)),
            infoBoxOutput(ns("inf_this_day_recovered"), width = 4), align = 'center'),
          h1("Total Case count", align = "center"),
          fluidRow(
            column(4,valueBoxOutput("box4foroverview", width = 12)),
            infoBoxOutput(ns("inf_2tal_case"), width = 4), align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box5foroverview", width = 12)),
            infoBoxOutput(ns("inf_2tal_death"), width = 4), align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box6foroverview", width = 12)),
            infoBoxOutput(ns("inf_2tal_recovered"), width = 4), align = 'center')
        )
      } else {
        tagList(
          h1("New Case count (during the past 24 hours)", align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box1", width = 12)),
            withSpinner(infoBoxOutput(ns("inf_this_day_case"), width = 4), type = 6), 
            align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box2", width = 12)),
            infoBoxOutput(ns("inf_this_day_death"), width = 4), align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box3", width = 12)),
            infoBoxOutput(ns("inf_this_day_recovered"), width = 4), align = 'center'),
          h1("Total Case count", align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box4", width = 12)),
            infoBoxOutput(ns("inf_2tal_case"), width = 4), align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box5", width = 12)),
            infoBoxOutput(ns("inf_2tal_death"), width = 4), align = 'center'),
          fluidRow(
            column(4,valueBoxOutput("box6", width = 12)),
            infoBoxOutput(ns("inf_2tal_recovered"), width = 4), align = 'center')
        )
      }
  )
}

server_overviewBody <- function(input, output, session, data, ProportionShow = TRUE) {
  ns <- session$ns



  data_summary <- reactive({
    data %>%
      filter(data$Countries == "World", as.character(max(ordered(data$DateRep))) == as.character(data$DateRep)) %>%
      select(-starts_with("rank"))
  })
  data_2 <- reactive({
    data %>%
      mutate(Recovered = round(Recovered, 2), cum_recovered = round(cum_recovered, 2))
  })

  output$inf_this_day_case <- renderValueBox({
    valueBox(
      value = tags$p(data_summary()$Cases, style = "font-size: 70%;"),
      subtitle = "Confirmed", color = "purple"
    )
  })
  output$inf_this_day_death <- renderValueBox({
    valueBox(
      value = tags$p(data_summary()$Deaths, style = "font-size: 70%;"),
      subtitle = "Death", color = "black"
    )
  })
  output$inf_this_day_recovered <- renderValueBox({
    valueBox(
      value = tags$p(round(data_summary()$Recovered, 2), style = "font-size: 70%;"),
      subtitle = "Recovered", color = "green"
    )
  })
  # 2tal value boxes
  output$inf_2tal_case <- renderValueBox({
    valueBox(
      value = tags$p(data_summary()$cum_cases, style = "font-size: 70%;"),
      subtitle = "Confirmed", color = "purple"
    )
  })
  output$inf_2tal_death <- renderValueBox({
    valueBox(
      value = tags$p(data_summary()$cum_death, style = "font-size: 70%;"),
      subtitle = "Death", color = "black"
    )
  })
  output$inf_2tal_recovered <- renderValueBox({
    valueBox(
      value = tags$p(round(data_summary()$cum_recovered, 2), style = "font-size: 70%;"),
      subtitle = "Recovered", color = "green"
    )
  })
  print("All values rendered")
}
