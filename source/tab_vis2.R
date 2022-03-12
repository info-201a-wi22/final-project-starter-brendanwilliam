# Date: March 7th, 2022
# Author: Brendan Keane
# Purpose: Visualization tab for this user interface

# Libraries
library("shiny")
library(dplyr)


vis2_tab <- tabPanel(
  "Animal and Vegetable Products",
  h1("Animal and Vegetable Consumption in Relation to Covid Deaths"),
  plotlyOutput(outputId = "chart1"),
  
# Controls 
  selectInput(
    inputId = "x_var",
    label = "Select X Variables",
    choices = list("Animal Products" = "Animal.Products",
                   "Vegetable Products" = "Vegetal.Products",
                   "Animal Fats" = "Animal.fats",
                   "Vegetable Oils" = "Vegetable.Oils"),
    selected = "Animal.Products"
  ),
  
  p("The purpose of this chart is to explore the relationship between the consumption of Animal and Vegetable products, and how it correspondes to
  covid-19 deaths. Finland has the largest ratio of animal product to plant product, almost equal to 1, nigeria has the 
    smallest ratio of animal products to plant products, and the difference between animal products and plant products is almost 40 times that. 
    According to the research and the questions we answered (animal products in developed countries are high), it can be concluded that the 
    national development in Nigeria is not good, so there is no strong immunity against COVID. While the correlation with Animal and Vegetable Products
    compared to Covid Deaths is extremely interesting, according to the chart displayed, there does not appear to be a relationship between the 
    variables and Covid deaths. ")
  
)