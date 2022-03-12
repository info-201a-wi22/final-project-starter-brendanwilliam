# Date: March 7th, 2022
# Author: Brendan Keane
# Purpose: Visualization tab for this user interface

# Libraries
library("shiny")
library("leaflet")

# Controls
sidepanel <- sidebarPanel(
  h2("Key"),
  strong("RED"),
  p("COVID-19 mortality rate"),
  strong("GREEN"),
  selectInput(
    inputId = "food_cat",
    label = "Food Group",
    choices = list("Vegetable Products" = "Vegetal.Products",
                   "Animal Products" = "Animal.Products",
                   "Animal Fats" = "Animal.fats",
                   "Sugar" = "Sugar...Sweeteners",
                   "Legumes (Beans, Chickpeas, Lentils, etc)" = "Pulses",
                   "Cereals" = "Cereals...Excluding.Beer"),
    selected = "Vegetal.Products"
  )
)

# Visualization
mainpanel <- mainPanel(
  leafletOutput("foodMap"),
  p("All food values are normalized between 0 and 1")
)

# UI for this tab
vis4_tab <- tabPanel(
  "Food Map",
  h1("Food Consumption Patterns and COVID-19 Mortality"),
  sidebarLayout(
    sidepanel,
    mainpanel,
    position = c("right")
  ),
  h2("What to look for in this visualization"),
  p("This visualization contextualizes different geographies and their eating 
  habits. On this map, a country’s eating habits are compared to their COVID-19 
  mortality. If there is a positive correlation, both the red and green country 
  dots will appear the same size. If there is a negative correlation, dots will 
  appear mostly red or mostly green."),
  p("Each category option answers a different question about dietary health. 
  First, plant and animal product consumption aims to understand if better gut 
  health from a plant-based diet improves immune responses. This map shows that 
  greater consumption of animal products reduces COVID-19 mortality. We theorize 
  that this might be because animal product consumption is a proxy to 
  industrialization and national wealth."),
  p("Next, both animal fats and sugars are mapped to test if a traditionally 
  unhealthy diet contributes to COVID-19 mortality. Again, there is no significant 
  correlation besides Europe consuming large amounts of animal fats."),
  p("Last, we played with other food variables to see how they correlated with 
  COVID-19 mortality. Of the categories in the dataset, cereal and legumes had 
  the strongest correlations with COVID-19 mortality. We theorize that cereal’s 
  positive correlation with COVID-19 mortality is due to high cereal consumption 
  in Sub-Saharan Africa. Legumes have a negative correlation with COVID-19 
  mortality. The greatest consumers of legumes are in central Africa which, when 
  compared with their low-legume-consuming neighbors, have a significantly lower 
  COVID-19 mortality rate."),
  p("While this dataset hardly provides enough evidence to declare legumes the 
    next great superfood, it does call to question why this inexpensive, 
    plant-based food category correlates with lower COVID-19 mortality. 
    Understanding this correlation requires more observational studies and 
    potentially experimental studies.")
)