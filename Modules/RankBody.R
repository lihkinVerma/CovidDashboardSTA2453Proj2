library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(plotlyGeoAssets)

# -------------------------------------------------------
# Defining ui and server
# -------------------------------------------------------
ui_rankBody <- function(id, var_to_view, is_continent = FALSE) {
  ns <- NS(id)
  if(!is_continent){
    tagList(
      if (var_to_view == 'Cases'){
        box(
          title = "Confirmed", 
          width = 26, 
          status = "warning", 
          solidHeader = TRUE,
          height = 1200,
          column(
            width = 6,
            ui_barCharts(ns("Cases"))
          ),
          column(
            width = 6,
            ui_barCharts(ns("cum_cases"))
          )
        )
      }
      else if(var_to_view == 'Deaths'){
        box(
          title = "Death", width = 26, status = "warning", solidHeader = TRUE, height = 1200,
          column(
            width = 6,
            ui_barCharts(ns("Deaths"))
          ),
          column(
            width = 6,
            ui_barCharts(ns("cum_death"))
          )
        )
      }
      else if (var_to_view == 'Recovered'){
        box(
          title = "Recovered", width = 26, status = "warning", solidHeader = TRUE, height = 1200,
          column(
            width = 6,
            ui_barCharts(ns("Recovered"))
          ),
          column(
            width = 6,
            ui_barCharts(ns("cum_recovered"))
          )
        ) 
      }
    ) 
  }
  else{
    tagList(
      if (var_to_view == 'Cases'){
        box(
          title = "Confirmed", width = 26, status = "warning", solidHeader = TRUE, height = 600,
          column(
            width = 6,
            ui_pieCharts(ns("Cases"))
          ),
          column(
            width = 6,
            ui_pieCharts(ns("cum_cases"))
          )
        )
      }
      else if(var_to_view == 'Deaths'){
        box(
          title = "Death", width = 26, status = "warning", solidHeader = TRUE, height = 600,
          column(
            width = 6,
            ui_pieCharts(ns("Deaths"))
          ),
          column(
            width = 6,
            ui_pieCharts(ns("cum_death"))
          )
        )
      }
      else if (var_to_view == 'Recovered'){
        box(
          title = "Recovered", width = 26, status = "warning", solidHeader = TRUE, height = 600,
          column(
            width = 6,
            ui_pieCharts(ns("Recovered"))
          ),
          column(
            width = 6,
            ui_pieCharts(ns("cum_recovered"))
          )
        ) 
      }
    )
  }
}

server_rankBody <- function(input, output, session, data, var2show, is_continent = FALSE) {
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
  if(!is_continent){
    # Show top 50 countries
    if(var2show == 'Cases'){
      callModule(server_barCharts, "Cases", data_2(), "Cases", how_many = 50)
      callModule(server_barCharts, "cum_cases", data_2(), "cum_cases", how_many = 50)
    }
    else if(var2show == 'Deaths'){
      callModule(server_barCharts, "Deaths", data_2(), "Deaths", how_many = 50)
      callModule(server_barCharts, "cum_death", data_2(), "cum_death", how_many = 50)
    }
    else if(var2show == 'Recovered'){
      callModule(server_barCharts, "Recovered", data_2(), "Recovered", how_many = 50)
      callModule(server_barCharts, "cum_recovered", data_2(), "cum_recovered", how_many = 50)
    }
  }
  else{
    if(var2show == 'Cases'){
      callModule(server_pieCharts, "Cases", data_2(), "Cases")
      callModule(server_pieCharts, "cum_cases", data_2(), "cum_cases")
    }
    else if(var2show == 'Deaths'){
      callModule(server_pieCharts, "Deaths", data_2(), "Deaths")
      callModule(server_pieCharts, "cum_death", data_2(), "cum_death")
    }
    else if(var2show == 'Recovered'){
      callModule(server_pieCharts, "Recovered", data_2(), "Recovered")
      callModule(server_pieCharts, "cum_recovered", data_2(), "cum_recovered")
    } 
  }
}
