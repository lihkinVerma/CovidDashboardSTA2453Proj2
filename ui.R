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
source("Modules/MainBody_Page.R")
source("Modules/OverviewBody_Page.R")
source("Modules/RankBody_Page.R")
source("Modules/compute_proportion.R")
source("Modules/compute_cum_ranks.R")
source("Modules/filter.R")
source("Modules/barCharts.R")
source("Modules/pieCharts.R")
source("Modules/MainBody.R")
source("Modules/RankBody.R")
source("Modules/OverviewBody.R")
source("Modules/Country_property.R")
source("Modules/Logistic_Growth_Model_with_ggplot2.R")
source("Modules/timeSeriesPlots.R")
source("Modules/timeSeriesPlotPage.R")
source("Modules/leafMap_data_computation.R")
source("Modules/leafletMap.R")
source("Modules/leafletMap_Page.R")
source("Modules/weight_matrices.R")
source("Modules/Moran.R")
source("Modules/Moran_Page.R")
source("Modules/Moran_Main_Page.R")
source("Modules/Logistic_Growth_Model_Page.R")

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
        menuItem("Our Team", tabName = "OurTeam", icon = icon("fa-solid fa-user-plus")),
        menuItem("Data Set", tabName = "table", icon = icon("table")),
        menuItem("Quick Counts", tabName = "overview_page", icon = icon("fa-solid fa-briefcase-medical")),
        menuItem(
          "Rank countries",
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
          "Rank continents",
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
          "Case count timelines", icon = icon("bars"),
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
                 Welcome to the COVID-19 Dashboard! 
                 
                 The goal of this dashboard is to monitor the spread of COVID-19 all over the world and visualize the key metrics related to COVID-19,
                 such as Number of Confirmed Cases and Number of Death Cases. <hr>
                 </p>
                 <p>
                 <span style= 'font-weight:bold;font-size:18px'>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> Who: </div>
                 This dashboard is built for a large group of audience and there is no restriction on audience's background.
                 The target audience includes but not limited to researchers, students, and front-line workers.
                 <hr>
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> What: </div>
                 This dashboard showcases information about the data source and key metrics to monitor the spread of COVID-19. Main features are the followings: <br>
                 Counts of Confirmed Cases, Death Cases, Recovered Cases <br>
                 Ranks in Confirmed Cases, Death Cases, Recovered Cases <br>
                 Time series plot of Confirmed Cases, Death Cases, Recovered Cases <br>
                 Global map with Confirmed Cases, Death Cases, Recovered Cases visualized by circles <br>
                 <hr>
                 
                 <div style= 'font-size: 16px;color:midnightblue;font-weight:bold'> Why: </div>
                 With a large amount of data related to COVID-19 available, it is crucial to understand the trends and metric information about the spread of COVID-19. 
                 Dashboard, as a tool for data visualization, is a web application that ingest data on daily basis and provide updated metric information automatically.
                 With the goal of better reporting and story-telling on COVID-19 data, we build this dashboard to gain insights on the current situation of COVID-19
                 and facilitate with governmental and public health decisions.
                 <hr>
                 </span>
                 </p>
                 
                 "), br(),
          
        ),
        fluidRow(
          column(width = 1),
          column(
            width = 1,
            img(src = "MSCAC_uoft.png", height = "100px", width = "350px")
          ),
          
          column(width = 8),
          column(
            width = 1,
            img(src = "uoft.png", height = "100px", width = "100px")
          )
        )
      ),
      tabItem(
        tabName = "OurTeam",

        HTML(
          "<center><h1 style = 'color:midnightblue;font-weight: bold;font-size: 40px'>Our Team</h1></center>"
        ), hr(),
        HTML("
                      <p style = 'font-size:15px;font-weight:bold'>
            We are a team of two MScAC (Master of Science in Applied Computing) students from University of Toronto. 
            This dashboard also serves as a project required by STA2453: Data Science Methods, Collaboration, and Communication.
            </p>
               "),
        
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
        'color:midnightblue'; href = https://github.com/lihkinVerma/CovidDashboardSTA2453Proj2/tree/main> Github")
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
               To save a copy to your local machine, you can press the 'CSV' button to download the entire up-to-date dataset. 
               You can also filter the dataset by country or by date: <br>

               To filter the dataset by county: enter the country's name in the search bar <br>
               To filter the dataset by date: enter the date in the format of 'yyyy-mm-dd' in the search bar.  </div>
               </p>
               "),
        withSpinner(DTOutput(outputId = "tblData"), type = 6)
      ),
      tabItem(
        tabName = "mainPage_Over",
        HTML("
          <h1 style= 'font-size: 28px;color:green;font-weight:bold'> Demographic </h1> <br>
               <p style = 'font-size:15px;font-weight:bold'>
               Here we present bar charts that can indicate how different
               countries compare in terms of reported numbers of positive diagnoses
               (confirmed), deaths, and recovery counts.<br>
               You can choose between \"Absolute counts\" and \"Relative counts\".<br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> What is the difference? </a>
               Absolute counts represent the actual counted number of cases 
               (confirmed, deaths, recoveries) for each region/country.
               Relative counts places the absolute counts in context with
               regards to the population size of that region 
               (per 1 million residents). 
               For example, if a region/country A has a population of 60 million people
               and 3000 infected cases, then it has (on a relative scale) 50 infected cases
               per 1 million people.<br><br>
               You can use the bar above each graph to
               \"shift the date backwards\" and explore how the data changed over time,
               up to the date the WHO declared the COVID-19 outbreak a PHEIC 
               (Public Health Emergency of International Concern).<br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> Tip: </a> Use the play button
               below the bar to observe an interactive plot over time! <br> 
               <a style= 'font-size: 16px;color:green;font-weight:bold'> Note:</a>  Please be mindful
               that the count of confirmed cases <a style= 'font-size: 16px;color:black;font-weight:italic'> includes </a>
               count of recovered cases!
               </p>
               ")
      ),
      #------------------------------------------------------------
      # Rank countries by case counts
      #------------------------------------------------------------
      tabItem(
        tabName = "overview_page",
        ui_overviewBody_Page("overview__page")
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
        tabName = "mainPage_country",
        ui_mainBody_Page("mainPage__country")
      ),
      tabItem(
        tabName = "tim_over",
        HTML("
          <h1 style= 'font-size: 28px;color:green;font-weight:bold'> Time Series Analysis </h1> <br>
               <p style = 'font-size:15px;font-weight:bold'> 
               Here we present plots of the different counts over time (commonly called a time series plot).
               You can choose between \"Absolute counts\" and \"Relative counts\".
                 <br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> What is the difference? </a>
               Absolute counts represent the actual counted number of cases (confirmed, deaths, recoveries)
               for each region/country. Relative counts places the absolute counts in context with regards to
               the population size of that region (per 1 million residents). For example,
               if a region/country A has a population of 60 million people and 3000 infected cases,
               then it has (on a relative scale) 50 infected cases per 1 million people. <br><br>
               
               On the cumulative scale, you can choose it to display the data using a 
               <a style= 'font-size: 16px;color:black;font-weight:bold'> logarithmic</a>
               scale as well.<br><br>
               
               This changes the y-axis (vertical axis) to 
               <a style= 'font-size: 16px;color:black;font-weight:bold'> display</a>
               the data differently. On the usual scale (non-logarithmic), numbers are equal distances apart - 10, 20, 30, and so on. On a logarithmic scale, numbers 10, 100, 1000 and so on, are equal distances apart. This type of adjustment to how the data are displayed is often employed when a curve grows exponentially - it prevents the graph from getting too big too soon.<br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> Note:</a>  
               Please be mindful that the cumulative count of confirmed cases
               <a style= 'font-size: 16px;color:black;font-weight:bold'> includes </a>
               recovered cases! <br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> Prediction of the future of the pandemic:</a>  
               In this menu, we have also provided a shortcut for fitting some dynamic growth models
               on the absolute cumulative counts of the confirmed cases in the following address <br>
               <a style= 'font-size: 15px;color:blue;font-weight:bold;text-align:center;'> Absolute counts > Confirmed > Cumulative > Prediction of the future.</a><br><br>
               To see more details on the dynamic growth models employed in this dashboard,
                refer to the 'Dynamic growth models' main menu and its overview.
             "),
      ),
      tabItem(
        tabName = "tim_Country",
        ui_timPage("tim_CountryPage")
      ),
      tabItem(
        tabName = "map_over",
        HTML("
          <h1 style= 'font-size: 28px;color:green;font-weight:bold'> Spatial Analysis </h1> <br>
               <p style = 'font-size:15px;font-weight:bold'> Here we present a spatial map indicating counts of confirmed cases and death cases.
               You can choose between \"Absolute counts\" and \"Relative counts\".
                 <br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> What is the difference? </a>
               Absolute counts represent the actual counted number of cases (confirmed,
               deaths, recoveries) for each region/country. Relative counts places the absolute
               counts in context with regards to the population size of that region
               (per 1 million residents). For example, if a region/country A has a population 
               of 60 million people and 3000 infected cases, then it has (on a relative scale) 
               50 infected cases per 1 million people. <br><br>
               </p>
               <p style= 'font-size: 15px;color:black;font-weight:bold'>
               <br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> Moran's Index:  </a>
               The Moran's index, originally defined by Moran, P. A. (1950), is a measure of spatial association or spatial autocorrelation which can be used to find spatial hotspots or clusters and is available in many software applications.  This index has been defined as the measure of choice for scientists, specifically in environmental sciences, ecology and public health.
               Moran's Index has a local and global representation.  The global Moran's I is a global measure for spatial autocorrelation while the local Moran's I index examines the individual locations, enabling hotspots to be identified based on comparisons to the neighbouring samples. 
               The Moran index I takes value on [-1,1] and I=0 shows no spatial correlation between
               the sub-regions for the underlying feature. According to  Gittleman and Kot (1990), there are two ways to identify the weights; 
               by adjacency approach and geographical distance method.<br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> How to interpret the outputs?:  </a>
               In this module, we compute the global Moran's index and test its significance for countries of a given continent based on daily confirmed cases.   
               Both weight matrices mentioned above are employed for this purpose. 
               The null hypothesis of the mentioned two-sided test indicates that there is no significance spatially correlation between the countries, while the alternative hypothesis indicates a significant autocorrelation. 
               Hence, if the corresponding p-value of a test is less than 0.05 (the horizontal dashed line of the first graph), then we have a significant spatial correlation for the countries of that continent, otherwise, there is no strong evidence for making such a decision.
               More precisely, based on the second graph, if the observed value of Moran's Index is significantly greater than the expected value, then the regions
               are positively autocorrelated, whereas if observed << expected, this will indicate negative autocorrelation. 
               In order to see and download the corresponding outputs in detail, you can see the 'Data table' tab.
               <br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> Note: </a>
               In the method using the geographical distance matrix, there is a parameter called 'distance threshold'. 
              Here we have set it to be the sample median of all distances between every two countries of a given continent.
               There is also a possibility to change it to other percentiles as well.<br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> References:</a><br>
               [1] Gittleman JL, Kot M (1990) Adaptation: statistics and a null model for estimating phylogenetic effects, Systematic Zoology 39:227-241.<br>
               [2] Moran, P. A. (1950). Notes on continuous stochastic phenomena. Biometrika, 37(1/2), 17-23.<br>               
               </p>
               ")
      ),
      tabItem(
        tabName = "map_ord_country",
        ui_leafMap_Page("Ordinary_map")
      ),
      tabItem(
        tabName = "moran",
        ui_moran_page("moran")
        #        ui_leafMap_Page("Ordinary_map")
      ),

      #------------------------------------------------------------
      # per Continent Pages
      #------------------------------------------------------------
      tabItem(
        tabName = "mainPage_continent",
        ui_mainBody_Page("mainPage__continent")
      ),
      tabItem(
        tabName = "tim_Continent",
        ui_timPage("tim_ContinentPage")
      ),
      tabItem(
        tabName = "DGM_over",
        HTML("<p style= 'font-size: 15px;color:black;font-weight:bold'><a style= 'font-size: 16px;color:green;font-weight:bold'> Dynamic growth models:</a>  
               In this menu, we have provided two dynamic models for
               forecasting the future of the pandemic. To this end, 
               the logistic growth model (LGM) as well as the Gomperts growth model (GGM), as two special cases of the 
               generalized logistic curve [1], are fitted on the absolute cumulative counts of the confirmed cases (denoted by N(t)).
               More precisely, the following three paramters non-linear mathematical models have been utilized
       as the LGM and GGM, respectively:</p>"),
        shiny::withMathJax(helpText("$$N(t) = \\frac{\\alpha}{1+\\beta\\exp(-kt)} + \\epsilon,$$")),
        shiny::withMathJax(helpText("$$N(t) = \\alpha\\exp(- \\beta\\exp(-kt)) + \\epsilon.$$")),
        HTML("<p style= 'font-size: 15px;color:black;font-weight:bold'>
The generalized logistic curve is commonly used for dynamic modeling in many branches of science including chemistry,
               physics, material science, forestry, disease progression, sociology, etc. See [1] and [2] for more details and applications. <br><br>
                 <a style= 'font-size: 16px;color:green;font-weight:bold'> Note 1:</a>  
  Please be informed that in the plots of this module, 
  the points stand for the observed values 
  and the solid lines show the fitted dynamic models on them.<br>
  <a style= 'font-size: 16px;color:green;font-weight:bold'> Note 2:</a>  
  It is to be noted that the above-mentioned models are not fitted just on
  a few countries data due to the presence of some outliers. In such a situation you may encountor to the following message:<br>
  <a style= 'font-size: 14px;color:red;font-weight:normal;text-align:center'> An error has occurred. Check your logs or contact the app author for clarification.</a>
               <br><br>
               <a style= 'font-size: 16px;color:green;font-weight:bold'> References:</a><br>
               [1] Lei, Y.C.; Zhang, S.Y. Features and partial derivatives of Bertalanffy-Richards growth model in forestry, Nonlinear Anal. Model. Cont. 2004 Volume 9(1), pp. 65-73.<br>
               [2] Richards, F.J. A flexible growth function for empirical use, J. Experimental Botany 1959 Volume 10(2), pp. 290-300.
              </p>"),
      ),

      tabItem(
        tabName = "reg_Country",
        ui_regression("RegCountry")
      ),
      tabItem(
        tabName = "reg_Continent",
        ui_regression("RegContinent")
      )
    )
  })
)

#------------------------------------------------------------
# refernces: 1. https://www.frontiersin.org/articles/10.3389/fpubh.2020.623624/full
#            2. https://pomber.github.io/covid19/timeseries.json
#            3. https://art-bd.shinyapps.io/covid19canada/
#------------------------------------------------------------
