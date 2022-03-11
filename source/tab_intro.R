# Date: March 7th, 2022
# Author: Brendan Keane
# Purpose: Introduction tab for this user interface

# Libraries
library("shiny")

# Intro tab
intro_tab <- tabPanel(
  "Introduction",
  h1("Introduction"),
  img(src="https://www.cdc.gov/coronavirus/2019-ncov/images/global-covid-19/global_response.jpg", width = 800, height = 480),
  h4("Background research"),
  fluidRow("Within this data analysis of COVID-19 and macronutrient consumption, we can 
     explore the effects of food on our immune system and susceptibility to viruses.
     Academic journals, like the ", 
     a("Indian Journal of Microbiology ", href="https://pubmed.ncbi.nlm.nih.gov/33012868/"), 
     "explored theories as to why India's mortality rate is significantly lower 
     rates before the introduction of a vaccine. Rishi et al. believe that
     since India shut down food processing facilities at the start of the
     pandemic, Indians were forced to eat home-cooked, unprocessed food which
     would create a healthier microbiome in their gut."),
  fluidRow("Our food data comes from ", 
           a("Food Supply kcal on Kaggle ", href="https://www.kaggle.com/mpwolke/food-supply-kcal/data"),
           "which sources food data from the ",
           a("United Nations FAO website, ", href="https://www.fao.org/faostat/en/#home"),
           "and our COVID-19 data comes from ",
           a("Johns Hopkins Coronavirus Resource Center", href="https://coronavirus.jhu.edu/map.html"),
           ". By combining these two datasets, we are able to connect country
           COVID data with country food data."),
  h4("Contextualizing our data"),
  fluidRow("In statistics, it is essential to remember that correlation does not
           equate to causality. So while there are some strong correlations
           between a country's COVID-19 mortality rate and dietary habits, 
           a country's dietary habits are dependent on local availability. This
           contributes to Europe consuming more animal products, the Gulf Coast
           consuming more sugar, and Africa/Asia consuming more vegetable 
           products."),
  h4("Our investigation"),
  fluidRow(p("By combining global COVID and food data, we are able to connect country
    food habits to their COVID-19 outcomes. In this research we will attempt to
    answer the following questions:"),
    p(strong("1) Is there a relationship between diet and COVID-19 mortality?")),
  p(strong("2) Does a conventionally healthy diet (low sugar, low sodium, low fat), 
         high produce) strengthen the immune system, reducing COVID-19 mortality?")),
  p(strong("3) Does a high quantity of processed food relate to high COVID-19 mortality?")))
)


