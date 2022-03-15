#------------------------------------------------------------
# Project submitted by:
# Nikhil Verma and Yang Qu
#------------------------------------------------------------

options(rsconnect.max.bundle.size = 8.192e+9)

library(shiny)
library(DT)
library(shinydashboardPlus)

source("Modules/CountryName_wrangling.R")
source("Modules/DataDownload.R")
source("Modules/Continent.R")
source("Modules/OverviewBody_Page.R")
source("Modules/RankBody_Page.R")
source("Modules/compute_cum_ranks.R")
source("Modules/filter.R")
source("Modules/barCharts.R")
source("Modules/pieCharts.R")
source("Modules/RankBody.R")
source("Modules/OverviewBody.R")
source("Modules/Country_property.R")
source("Modules/timeSeriesPlots.R")
source("Modules/timeSeriesPlotPage.R")
source("Modules/leafMap_data_computation.R")
source("Modules/leafletMap.R")
source("Modules/leafletMap_Page.R")

#------------------------------------------------------------
# Main UI of the dashboard
#------------------------------------------------------------
ui <- dashboardPage(
  title = "SARS-COV-19-Dashboard",
  #------------------------------------------------------------
  # Dashboard header
  #------------------------------------------------------------
  dashboardHeader(titleWidth = 220, 
                  title = span(img(src = "SARS-CoV-2_without_background.png", 
                                   width = 50)), disable = FALSE),
  #------------------------------------------------------------
  # Dashboard sidebar
  #------------------------------------------------------------
  {
    dashboardSidebar(
      width = 210,
      sidebarMenu(
        id = "tabs",
        menuItem("Home Page", tabName = "homepage", icon = icon("th")),
        menuItem("Quick Counts", tabName = "overview_page", icon = icon("fa-solid fa-briefcase-medical")),
        menuItem(
          "Rank Countries",
          icon = icon("fa-regular fa-globe"),
          menuItem("Overview", tabName = "rankPage_Over"),
          menuItem(
            "Case Type",
            menuSubItem("Confirmed", tabName = "rankPage_confirmed", icon = icon("fa-regular fa-flag")),
            menuSubItem("Deaths", tabName = "rankPage_deaths", icon = icon("fa-solid fa-flag")),
            menuSubItem("Recovered", tabName = "rankPage_recovered", icon = icon("fa-duotone fa-flag"))
          )
        ),
        menuItem(
          "Rank Continents",
          icon = icon("fa-regular fa-globe"),
          menuItem("Overview", tabName = "rankPage_Over_cont"),
          menuItem(
            "Case Type",
            menuSubItem("Confirmed", tabName = "rankPage_confirmed_cont", icon = icon("fa-regular fa-flag")),
            menuSubItem("Deaths", tabName = "rankPage_deaths_cont", icon = icon("fa-solid fa-flag")),
            menuSubItem("Recovered", tabName = "rankPage_recovered_cont", icon = icon("fa-duotone fa-flag"))
          )
        ),
        menuItem(
          "Case Count Timelines", icon = icon("bars"),
          menuItem("Overview", tabName = "tim_over"),
          menuItem(
            "Time Series Plots",
            menuSubItem("Country", tabName = "tim_Country"),
            menuSubItem("Continent", tabName = "tim_Continent")
          )
        ),
        menuItem(
          "Map", icon = icon("map"),
          menuItem("Overview", tabName = "map_over"),
          menuSubItem("Map", tabName = "map_ord_country")
        ),
        menuItem("Data Set", tabName = "table", icon = icon("table")),
        menuItem("Team members", tabName = "OurTeam", icon = icon("fa-solid fa-user-plus")),
        br(),
        br()
      )
    )
  },
  #------------------------------------------------------------
  # Dashboard body
  #------------------------------------------------------------
  dashboardBody({
    tabItems(
      #------------------------------------------------------------
      # Home Page
      #------------------------------------------------------------
      tabItem(
        "homepage",
        tags$img(src = "techcoronav.gif", style = "position: absolute; opacity: 0.2"),
        column(
          width = 12,
          
          HTML(
            "<center>
              <h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>COVID-19 Dashboard</h1>
            </center>"
          ), 
          HTML("
                 <p style = 'font-size:15px;font-weight:bold'>
                 Welcome to the COVID-19 Dashboard! <br><br>
                 
                 The goal of this dashboard is to monitor the spread of COVID-19 all over the world and visualize the key metrics related to COVID-19. 
                 The data is collected by Johns Hopkins University Center for Systems Science and Engineering (CSSEGISandData/COVID-19) and stored as a JSON file in the online Github repository (more information in the data set page). 
                 Similar to other COVID-19 dashboards, it provides daily updated information about the number of cases in each country and continent in various visualizations.
                 </p>
                 <p>
                 <span style= 'font-weight:bold;font-size:18px'>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> Who can use this dashboard: </div>
                 This dashboard is built for a large group of audience and there is no restriction on audience's background.
                 The target audience includes but not limited to researchers, students, and front-line workers.
                 Also it is useful for media houses to compare trends in Covid-19 affected nations across the world.
                 <hr>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> What information is provided: </div>
                 This dashboard provides information about the data source and key metrics to monitor the spread of COVID-19 all over the world.
                 To navigate this dashboard, use the tabs on the left to go to the section based on what information you’d like to retrieve: <br>
                 To see more information about the data source and download the dataset as a CSV file, go to the Data Set section <br>
                 To see the number of new cases in the past 24 hours and the total number of cases, go to the Quick Counts section <br>
                 To see the top 50 countries ranked by the number of new cases and cumulative cases of Confirmed, Deaths, and Recovered per day, go to the Rank Countries section <br>
                 To see the percentage of the number of new cases and cumulative cases of Confirmed, Deaths, and Recovered per continent per day, go to the Rank Continents section <br>
                 To see the plot of the number of new cases and cumulative cases of Confirmed, Deaths, and Recovered versus date per country, go to the Case Count Timelines section <br>
                 To see the world map with circles with various sizes representing the number of new cases of Confirmed, Deaths, and Recovered per day, go to the Map section <br>
                 <hr>
                 
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> Why is this dashboard important: </div>
                 With a large amount of data related to COVID-19 available, it is crucial to understand the trends and metric information about the spread of COVID-19. 
                 Dashboard, as a tool for data visualization, is a web application that ingest data on daily basis and provide updated metric information automatically.
                 With the goal of better reporting and story-telling on COVID-19 data, we build this dashboard to gain insights on the current situation of COVID-19
                 and facilitate with governmental and public health decisions.
                 <hr>
                 </span>
                 </p>
                 
                 "), br()
          
        ),
        fluidRow(
          column(width = 5),
          column(
            width = 1,
            img(src = "uoft.png", height = "150px", width = "80px")
          )
        )
      ),
      tabItem(
        tabName = "OurTeam",
        HTML(
          "<center><h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>Our Team</h1></center>"
        ), hr(),
        HTML("<p style = 'font-size:15px;font-weight:bold'>
            We are a team of two MScAC (Master of Science in Applied Computing) students from University of Toronto.
            This dashboard also serves as a project required by STA2453: Data Science Methods, Collaboration, and Communication.
            </p>"),
        HTML("<div style = 'font-size: 14.5px;color:black;font-weight:bold'> 
             <a style = 'font-size: 16px;color:midnightblue;font-weight:bold'> 
             Nikhil Verma </a>: 
             Department of Computer Science - University of Toronto, Canada </div>"),
        br(),
        HTML("<div style = 'font-size: 14.5px;color:black;font-weight:bold'> 
             <a style = 'font-size: 16px;color:midnightblue;font-weight:bold'> 
             Yang Qu </a>: 
             Department of Computer Science - University of Toronto, Canada </div>"),
        br(),
        HTML("<div style = 'color:midnightblue'> Code:</div> Codes are available on  <a style = 
        'color:midnightblue'; href = https://github.com/lihkinVerma/CovidDashboardSTA2453Proj2> Github </a>"), 
        br(), 
        br(),
        HTML("<a style= 'font-size: 16px;color:green;font-weight:bold'> References:</a><br>
               [1] Salehi, M., Arashi, M., Bekker, A., Ferreira, J., Chen, D., Esmaeili, F. and Frances, M. (2020). A synergetic R-Shiny portal for modeling and tracking of COVID-19 data, Front. Public Health, doi: 10.3389/fpubh.2020.623624.")
      ),
      tabItem(
        tabName = "table",
        HTML(
          "<center><h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>Data Set</h1></center>"
        ), hr(),
        HTML("
               <p style='color:black;font-size:15px'>
               The data used in this dashboard is from the public Github repository (<a href = https://pomber.github.io/covid19/timeseries.json>
               https://pomber.github.io/covid19/timeseries.json</a>). It includes information (shown below) from 2020-01-22 up to the past 24 hours (excluding today) per country per day. As international and government authorities report new data on a daily basis and more data are available, this dataset is automatically updated to the latest one. Population data per country is available on <a href = https://www.worldometers.info/world-population/population-by-country/>
               www.worldometers.info</a>.
               
               <div style='color:black;font-size:15px'> 
               Below is an overview of the entire dataset. Noted that it is a large dataset, it may take a few seconds to load. 
               Each row contains information of date, country name, COVID-19 related information (Cumulative confirmed cases, Cumulative Deaths, Cumulative recoveries, New cases, New deaths, New recoveries), and population. 
               While COVID-19 related information are displayed in absolute values, population information is given to calculate the relative values per million population. <br><br>
               To save a copy to your local machine, you can press the 'CSV' button to download the entire up-to-date dataset. <br><br>
               You can also filter the dataset by country or by date: <br> <br>
               To filter the dataset by county: enter the country's name in the search bar. <br> <br>
               To filter the dataset by date: enter the date in the format of 'yyyy-mm-dd' in the search bar.  </div>
               </p>
               "),
        withSpinner(DTOutput(outputId = "tblData"), type = 6)
      ),
      #------------------------------------------------------------
      # Rank countries by case counts
      #------------------------------------------------------------
      tabItem(
        tabName = "overview_page",
        ui_overviewBody_Page("overview__page")
      ),
      tabItem(
        tabName = "rankPage_Over",
        HTML(
          "<center><h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>Rank Countires</h1></center>"
        ),
        hr(),
        HTML("<p style = 'font-size:16px;font-weight:bold'>
                 In this section, we show the top 50 countries ranked by the number of confirmed cases, the number of death cases, and the number of recovered cases.
                 Ranking by new cases per day is displayed on the left and ranking by cumulative cases is displayed on the right. All countries are sorted in decreasing order of their case type. <br> <br>
                  </p>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> You have the following options to interact with the dashboard: </div> <br>
                 <p style = 'font-size:16px'>
                 To view the rank based on specific type of cases (confirmed, death, recovery), go to the <b>left sidebar</b> and select the case type. <br> <br>
                 To view the proportion for a certain date, drag the <b>timeline bar</b> at the top of the dashboard to set the date. <br> <br>
                 <hr>
                 </p>
                 "),
        br()
      ),
      tabItem(
        tabName = "rankPage_confirmed",
        ui_rankBody_Page("rankPage__confirmed", 'Cases')
      ),
      tabItem(
        tabName = "rankPage_deaths",
        ui_rankBody_Page("rankPage__deaths", 'Deaths')
      ),
      tabItem(
        tabName = "rankPage_recovered",
        ui_rankBody_Page("rankPage__recovered", 'Recovered')
      ),
      #------------------------------------------------------------
      # Rank continents by case counts
      #------------------------------------------------------------
      tabItem(
        tabName = "rankPage_Over_cont",
        HTML(
          "<center><h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>Rank Continents</h1></center>"
        ), hr(),
        HTML("
                 <p style = 'font-size:16px;font-weight:bold'>
                 In this section, we show the percentage of confirmed cases, percentage of death cases, and percentage of recovered cases among the 6 continents.
                 All countries are mapped to their respective continents to count cases type for continents and then assigned a percentage share of the area in the pie.
                 Proportion by new cases per day is displayed on the left and Proportion by cumulative cases is displayed on the right. <br> <br>
                </p>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> You have the following options to interact with the dashboard:  </div> <br> 
                <p style = 'font-size:16px'>
                 To view the rank based on specific type of cases (confirmed, death, recovery), go to the <b>left sidebar</b> and select the case type. <br> <br>
                 To view the proportion for a certain date, drag the <b>timeline bar</b> at the top of the dashboard to set the date. <br> <br>
                 <hr>
                 </p>
                 "),
        br()
      ),
      tabItem(
        tabName = "rankPage_confirmed_cont",
        ui_rankBody_Page("rankPage__confirmed__cont", 'Cases', TRUE)
      ),
      tabItem(
        tabName = "rankPage_deaths_cont",
        ui_rankBody_Page("rankPage__deaths__cont", 'Deaths', TRUE)
      ),
      tabItem(
        tabName = "rankPage_recovered_cont",
        ui_rankBody_Page("rankPage__recovered__cont", 'Recovered', TRUE)
      ),
      #------------------------------------------------------------
      # Per country pages
      #------------------------------------------------------------
      tabItem(
        tabName = "tim_over",
        HTML(
          "<center><h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>Cases Count Timelines</h1></center>"
        ),hr(),
        HTML("
                 <p style = 'font-size:16px;font-weight:bold'>
                 In this section, we display the time series plots of number of confirmed cases, number of death cases, and number of recovered cases in either absolute values or relative values (per million population).
                 The plots show the number of cases (y-axis) versus the date (x-axis) which shows the trends of the number of cases up to now. 
                 Lines are created by marking polygon for case count, which helps in visualizing if the curve of cases is increasing or decreasing with respect to previous dates. <br> <br>
                 </p>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> You have the following options to interact with the dashboard:  </div> <br> 
                 <p style = 'font-size:16px'> 
                 To view the time series plot of specific type of cases (confirmed, death, recovery), select the <b>type of cases</b> on the top of the page. <br> <br>
            
                 To add a country into the plot, search for the country in the <b>selection box</b>. <br><br>
                 
                 To remove a country from the plot, click on the country name in the <b>selection box</b>.
                 <hr>
                 </p>
                 ")
      ),
      tabItem(
        tabName = "tim_Country",
        ui_timPage("tim_CountryPage")
      ),
      #------------------------------------------------------------
      # World map
      #------------------------------------------------------------
      tabItem(
        tabName = "map_over",
        HTML(
          "<center><h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>Map</h1></center>"
        ),hr(),
        HTML("
                 <p style = 'font-size:16px;font-weight:bold'>
                 In this section, we display the number of confirmed cases, number of death cases, and number of recovered cases in either absolute values or relative values (per million population) on a world map.
                 You will see multiple circles on a world map and each of them represents a country.
                 The bigger the circle is, the greater the number of cases in the corresponding country.
                 If you hover the mouse over the circles, a text box showing the number of confirmed cases, the number of deaths, and the number of recoveries will be shown next to the circle. <br> <br>
                </p>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> You have the following options to interact with the dashboard: </div> <br> 
                 <p style = 'font-size:16px'>
                 To view the world COVID-19 map for specific type of cases (confirmed, death, recovery), select the <b>type of cases</b> on the top of the page. <br> <br>

                 To change the date, use the <b>slider</b> to select the date of interest.
                 <hr>
                 </p>
                 ")
      ),
      tabItem(
        tabName = "map_ord_country",
        ui_leafMap_Page("Ordinary_map")
      ),
      #------------------------------------------------------------
      # per Continent Pages
      #------------------------------------------------------------
      tabItem(
        tabName = "tim_Continent",
        ui_timPage("tim_ContinentPage")
      )
    )
  })
)

#------------------------------------------------------------
# refernces: 1. https://www.frontiersin.org/articles/10.3389/fpubh.2020.623624/full
#            2. https://pomber.github.io/covid19/timeseries.json
#            3. https://art-bd.shinyapps.io/covid19canada/
#------------------------------------------------------------