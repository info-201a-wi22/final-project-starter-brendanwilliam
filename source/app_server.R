# Date: March 7th, 2022
# Author: Brendan Keane
# Purpose: Server for INFO 201 final deliverable

# Libraries

library("shiny")
library(ggplot2)
library(dplyr)
library(leaflet)
library("plotly")
library(knitr)
library(htmltools)
library(tidyverse)
library(ExPanDaR)

# Source files
source("data_access.R")
  
server <- function(input, output, session) {
  
  # Visualization 1
 df <- read.csv("https://raw.githubusercontent.com/info-201a-wi22/final-project-starter-foood/main/data/global_food_and_covid.csv")
  ret <- prepare_correlation_graph(df[,c(2,3,4,5,6,9,10,11,12,13,14,
                                         15,16,17,18,19,20,21,22,23,24,
                                         25,26,27,28,29,30,31,32,34)])

  # covid_specific <- food_and_covid %>%
  #   select(Country_Region, country_deaths, country_cases, country_fatality_ratio)
  # food_and_covid_new <- food_and_covid%>%
  #   rename("Cases" = "country_cases",
  #          "Deaths" = "country_deaths")
  # Country_Region <- food_and_covid_new$Country_Region
  food_and_covid_new_1<-  food_and_covid_new%>%
     group_by(Country_Region)%>%
     summarise(Country_Region,Cases,Deaths) %>%
     slice_max(order_by =Cases , n = 5)%>%
     pivot_longer(c(Cases,Deaths), names_to = "type", values_to = "population")
  
  # Server
  # Visualization 3
    data<-reactive({
      food_and_covid_new_1[food_and_covid_new_1$Country_Region == input$bar,]
    })
    output$chart2 <- renderPlotly({
      ggplot(
        data = data(),
        mapping = aes(x = input$bar, y = population, group = type, fill = type)
      ) +
        geom_col(position = "dodge",width=0.3)+
        labs(x="Country", y="the number of people",title = "Covid Cases and Deaths in each country")
    })
  
    
  # Visualization 4 - Interactive map
  output$foodMap <- renderLeaflet({
    
    # Renaming the changing variable to the standard name "rad"
    # This allows me to easily reference a variable based on an input
    # While there might be an easier way, I couldn't figure it out
    factor <- input$food_cat
    map_vis <- norm_foodcovid_data %>%
      rename(rad = factor)
    
    # Creating leaflet map
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = 0, lat = 20, zoom = 2) %>%
      
      # Circles for catagorical variable, marked in green
      addCircleMarkers(
        lat = map_vis$country_lat,
        lng = map_vis$country_long, 
        radius = 25 * map_vis$rad,
        popup = paste(map_vis$Country_Region, "| Normalized Food Factor: ", round(map_vis$rad, 5)),
        color = "#0F9458",
        opacity = 1,
        stroke = FALSE
      ) %>%
      
      # Circles for fatality ratio, marked in red
      addCircleMarkers(
        lat = map_vis$country_lat,
        lng = map_vis$country_long, 
        radius = 25 * map_vis$fatality_ratio_norm,
        popup = paste(map_vis$Country_Region, "| Fatality Ratio: ", round(map_vis$country_fatality_ratio, 5)),
        color = "#E00064",
        opacity = 1,
        stroke = FALSE
      )
  })
  
  # Visualization 2
  output$chart1 <- renderPlotly({
    plot <-  global_foodcovid_data %>%
      ggplot() +
      geom_point(aes(x = country_deaths, y = .data[[input$x_var]]))
    plot
  })
}


  