# Date: March 7th, 2022
# Author: Brendan Keane
# Purpose: Shiny App to visualize CO2 data


# Libraries
library("rsconnect")
library("dplyr")
library("rgeos")
library("rworldmap")
library("tidyr")
library("ggplot2")
library("plotly")

# Source files
source("app_ui.R")
source("app_server.R")  


shinyApp(ui = ui, server = server)

