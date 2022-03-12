# Date: March 7th, 2022
# Author: Brendan Keane
# Purpose: Downloading and cleaning all data for project

## Importing Data----------------

# Libraries used
library("dplyr")
library("knitr")
library("caret")


get_covid_data <- function() {
  # Loading global COVID data
  global_covid_data <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/03-08-2022.csv")
  
  return(global_covid_data)
}

get_food_data <- function() {
  # Loading global food supply in kg
  global_food_data <- read.csv("https://storage.googleapis.com/kagglesdsdata/datasets/618335/1108595/Food_Supply_Quantity_kg_Data.csv?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20220309%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20220309T225008Z&X-Goog-Expires=259199&X-Goog-SignedHeaders=host&X-Goog-Signature=8eeaf1ba4c75ea0b4e7e1e053b48755af9c80642a8233b7950f8a54a5f793d65da0c676a77d24b417ed93f40aa3014b2a7aeaa3d8f56badbe2d74a50a5500c24cb1d99a4d2530aeb4bbf3bf25072a2e06dc1b9a64ab9afa9c86eeffa1d57f5f053854da299ae43ce8026993e1db612acc818ce021c8b43178e7ddf4338b930d22b358a9d47842c7b3af5747c255026b69baa1d2bf82b09124bef034a6c5d1f0a5d43c1df45da29fcff71e26a011e70c67855ae585d1b175b5a2cca51e2e77e71146fe81cf79133571501a8142384c2787d385616a3ab0848daad8586c3962d96a86e57b6a233f8c7e2c056f9afbb8ef052f0e248e79f4bdfe6dcc702766d8e46")
  
  return(global_food_data)
}

## Grouping and Summarizing ----

# Makes covid data usable with the food data frame
wrangle_covid_data <- function(global_covid_data) {
  revised_data <- global_covid_data %>%
    # Group by country and filter for most recent information
    group_by(Country_Region) %>%
    filter(Last_Update == max(Last_Update, na.rm = TRUE)) %>%
    
    # Creating new columns that represent sums and averages for countries
    mutate(country_cases = sum(Confirmed, na.rm = TRUE)) %>%  # Sum of cases
    mutate(country_deaths = sum(Deaths, na.rm = TRUE)) %>%    # Sum of deaths
    mutate(country_lat = mean(Lat, na.rm = TRUE)) %>%         # Average latitude
    mutate(country_long = mean(Long_, na.rm = TRUE)) %>%      # Average longitude
    
    # Average incident rate and fatality ratio by country
    mutate(country_incident_rate = mean(Incident_Rate, na.rm = TRUE)) %>% 
    
    # Recalculating the fatality ratio with summarized cases and deaths by country
    mutate(country_fatality_ratio = country_deaths / country_cases) %>%
    
    # Grabbing the columns that are relevant to our further analysis
    select(Country_Region, country_lat, country_long, country_cases, 
           country_deaths, country_incident_rate, country_fatality_ratio, 
           Last_Update) %>%
    
    # Eliminating any duplicate information
    unique()
  
  return(revised_data)
}



# Combines food and covid data
combine_food_and_covid <- function (global_food_data, global_covid_data) {
  # Altering the food data (measured as percentage of diet by mass) to be compatible
  # with global COVID-19 data frame
  global_food_data_kg <- global_food_data %>%
    select(-Confirmed, -Deaths, -Active, -Recovered, -Unit..all.except.Population.)
  
  # Before computing summary statistics, we need to adjust naming conventions
  # to match the food data
  
  # Laos / Lao People's Democratic Republic
  global_food_data_kg[global_food_data_kg$Country == 
                        "Lao People's Democratic Republic", "Country"] <- "Laos"
  
  # Congo / Congo (Brazzaville) / Congo (Kinshasa)
  global_covid_data[global_covid_data$Country_Region == "Congo (Brazzaville)"
                    , "Country_Region"] <- "Congo"
  global_covid_data[global_covid_data$Country_Region == "Congo (Kinshasa)"
                    , "Country_Region"] <- "Congo"
  
  # Iran / Iran (Islamic Republic of)
  global_food_data_kg[global_food_data_kg$Country == 
                        "Iran (Islamic Republic of)", "Country"] <- "Iran"
  
  # Myanmar / Burma
  global_covid_data[global_covid_data$Country_Region == "Burma"
                    , "Country_Region"] <- "Myanmar"
  
  # Moldova / Republic of Moldova
  global_food_data_kg[global_food_data_kg$Country == 
                        "Republic of Moldova", "Country"] <- "Moldova"
  
  # Russia / Russian Federation
  global_food_data_kg[global_food_data_kg$Country == 
                        "Russian Federation", "Country"] <- "Russia"
  
  # Tanzania / United Republic of Tanzania
  global_food_data_kg[global_food_data_kg$Country == 
                        "United Republic of Tanzania", "Country"] <- "Tanzania"
  
  # United States of America / US
  global_covid_data[global_covid_data$Country_Region == "US"
                    , "Country_Region"] <- "United States of America"
  
  # Venezuela / Venezuela (Bolivarian Republic of)
  global_food_data_kg[global_food_data_kg$Country == 
                        "Venezuela (Bolivarian Republic of)", "Country"] <- "Venezuela"
  
  # Combining both of the data frames
  global_food_and_covid <- inner_join(global_covid_data, global_food_data_kg, 
                                      by = c("Country_Region" = "Country"))
  
  return(global_food_and_covid)
}


## Data Retrieval Functions ------

# Creating data frame for global food and COVID data
get_foodcovid_data <- function() {
  
  # COVID data
  covid_data <- get_covid_data() %>%
    wrangle_covid_data()
  
  # Food data
  food_data <- get_food_data()
  
  # Combine data sets
  full_data <- combine_food_and_covid(food_data, covid_data)
  
  return(full_data)
}

# Creating a summary table from our full data frame
get_foodcovid_summary <- function(full_data) {
  foodcovid_summary <- full_data %>%
    select(Country_Region, Population, country_cases, country_deaths, 
           country_fatality_ratio, Obesity, Undernourished, Animal.Products, 
           Vegetal.Products) %>%
    rename("Country" = Country_Region, "Cases" = country_cases, 
           "Deaths" = country_deaths, "Fatality Ratio (Deaths to Cases)" = country_fatality_ratio,
           "Obesity (%)" = Obesity, "Malnourished (%)" = Undernourished,
           "Animal Producs (kg)" = Animal.Products, 
           "Vegetable Products (kg)" = Vegetal.Products) %>%
    arrange(-Population) %>%
    head(15)
  
  summary_table <- kable(foodcovid_summary, format = "pipe", digits = 3)
  
  return(foodcovid_summary)
}

# Data frame and summary table to be used as reference through the project
global_foodcovid_data <- get_foodcovid_data()
global_foodcovid_summary <- get_foodcovid_summary(global_foodcovid_data)

# Normalized values ----
normalize_data <- function(full_data) {
  
  full_data <- full_data %>%
    filter(Country_Region != "Yemen") %>%
    filter(Country_Region != "Vanuatu")
  
  # Normalizing function for data. Brings values between 0 and 1
  process <- preProcess(as.data.frame(full_data), method = c("range"))
  norm_data <- predict(process, as.data.frame(full_data)) %>%
    select(country_fatality_ratio, Obesity, Animal.Products, Vegetal.Products,
           Animal.fats, Sugar...Sweeteners, Pulses, Cereals...Excluding.Beer) %>%
    rename(Obesity.Norm = Obesity, fatality_ratio_norm = country_fatality_ratio)
  
  # Selecting countries and coordinates
  geo_data <- full_data %>%
    select(Country_Region, country_lat, country_long, Obesity, country_fatality_ratio) 
  
  # Joining normalized data
  combo_data <- merge(geo_data, norm_data, by = "row.names", all = TRUE)

}

# Normalized, map graphable food and covid data frame
norm_foodcovid_data <- normalize_data(global_foodcovid_data)

