# CovidDashboardSTA2453Proj2
This dashboard(https://lihkin.shinyapps.io/covidDashboard/) is for the Covid data showcasing to a larger audience (World population), and also as a course requirement for STA2453 as a project 2 for Data Science Collaboration and Communication

## Data Source
The data used in this dashboard is from the public Github repository (https://pomber.github.io/covid19/timeseries.json) where data is collected by Johns Hopkins University Center for Systems Science and Engineering (CSSEGISandData/COVID-19).

## Framework
The framework used for building the dashboard is Shiny, which is an open-source R package for building interactive web applications. The components in shiny applications have a polished look and are accessible cross-platforms (device portability). Also, the dashboards made using this framework are versatile, provide the capability to integrate well with different visualization modules and advanced graphical libraries of R .

## Data ingestion
The API updates the data three times a day using Github actions, so the data is updated automatically. The JSON obtained is directly consumed by dashboard backend code along with merging of information with some static data files. This includes mapping of countries to the continent on earth and some demographic information such as longitude and latitude for each country and its population.
