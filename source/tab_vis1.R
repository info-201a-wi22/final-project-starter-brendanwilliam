# Date: March 7th, 2022
# Author: Brendan Keane
# Purpose: Visualization tab for this user interface

# Libraries
library("shiny")

# UI for this tab
vis1_tab <- tabPanel(
  "Visualization 1",
  h1("Correlation between Alcolohic beverages and COVID 19"),
  plotOutput("lethal_foods"),
  p("Alcohol is generally to be consumed in moderation, and copious amount is
     not healthy for anyone, however since alcohol has this unhealthy reputation,
     it would be easy to assume that people who consume more alcohol are more
     susceptible to COVID-19 exposure. Contradictaory to this misconception,
     the data we explored, shows no clear pattern of alcohol consumption and fatality.
     In addition, It appears as though even if the alcoholic beverage consumption
     is over fifteen, there is no correleation with the fatality ratio. This
     does not mean that alcohol actually helps with the immune system avioding 
     COVID, but it does not have any clear data/patterns that it hurts either."),

  shinyUI(fluidPage(
    sidebarLayout(
      sidebarPanel(
        helpText("Plots that show correlation between Alcoholic beverages and
                 the global COVID-19 fatality ratio"),
        
        selectInput("var",
                    label = "Choose Alcohol or stimulants",
                    choices = c("Alcohol"=1, "Stimulants"=2),
                    selected = 1)
      ),
      
      mainPanel(plotOutput('AlcoholPlot'))
    )
  ))
)