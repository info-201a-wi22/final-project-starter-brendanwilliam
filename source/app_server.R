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
  output$lethal_foods <- renderPlot(
    
    ggplot(global_foodcovid_data) +
      geom_point(mapping = aes(x = global_foodcovid_data$country_fatality_ratio, 
                               y = global_foodcovid_data$Alcoholic.Beverages, 
                               size = Population)) +
      #geom_smooth(mapping = aes(x = global_foodcovid_data$country_fatality_ratio, 
                               # y = global_foodcovid_data$Alcoholic.Beverages,
      labs(title = "Alcohol in relation to COVID-19",
                                x = "Fatality Ratio",
                                y = "Alcoholic Bev. Consumed")
                                    
    
  )
  
  
  food_and_covid <- read.csv("https://raw.githubusercontent.com/info-201a-wi22/final-project-starter-foood/main/data/global_food_and_covid.csv")
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
  output$veg_animal_covid <- renderPlot(
    
    ggplot(global_foodcovid_data) +
      geom_point(mapping = aes(x = Animal.Products,
                               y = Vegetal.Products, 
                               size = global_food_df$country_fatality_ratio / 10)) +
      geom_smooth(mapping = aes(x = global_foodcovid_data$Animal.Products, 
                                y = global_foodcovid_data$Vegetal.Products,
                                ))
  )
}

  