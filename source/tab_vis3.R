# Date: March 8th, 2022
# Author: Jerry Zhang
# Purpose: Visualization tab for this user interface

# Libraries
library("shiny")
library(dplyr)

# Prepare for the data
food_and_covid <- read.csv("https://raw.githubusercontent.com/info-201a-wi22/final-project-starter-foood/main/data/global_food_and_covid.csv")
food_and_covid_new <- food_and_covid%>%
  rename("Cases" = "country_cases",
         "Deaths" = "country_deaths")
Country_Region <- food_and_covid_new$Country_Region

# UI for this tab
vis3_tab <- tabPanel(
  "COVID chart",
  h1("Interactive Page 3"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "bar",
                  label = "Country",
                  choices = list(
                    "Country"=Country_Region
                  ),
                  selected = "Vanuatu "),
    ),
    mainPanel(
      plotlyOutput("chart2"),
    )
  ),
  widths = c(2,12),
  p("The purpose of this chart is to explore the relationship between the number of cases and deaths across countries and to derive their ratios. In addition, another aspect is to calculate the ratio between them and explore the relationship between the ratio and the ratio of nutritious food intake. I consider that the intake of food nutrition is related to immunity, which in turn will affect people's resistance to COVID, so I want to explore the relationship between COVID cases and deaths and food nutrition intake, so I am doing both Before the relationship, I first choose to show the number of cases and deaths of COVID in each country to find the pattern.")
)

