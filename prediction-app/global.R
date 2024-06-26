library(shiny)
library(ggplot2)
library(dplyr)
library(forecast)
library(shinydashboard)

# Load and prepare the data
space_data <- read.csv("data/outer_space_objects.csv")

# Data preparation
yearly_data <- space_data %>%
  group_by(Year) %>%
  summarize(total_objects = sum(num_objects))

# Define available prediction models
available_models <- c("ARIMA", "ETS", "TBATS")

# Helper function for forecasting
forecast_model <- function(data, model, h) {
  ts_data <- ts(data$total_objects, start = min(data$Year), frequency = 1)
  
  if (model == "ARIMA") {
    fit <- auto.arima(ts_data)
  } else if (model == "ETS") {
    fit <- ets(ts_data)
  } else if (model == "TBATS") {
    fit <- tbats(ts_data)
  }
  
  forecast(fit, h = h)
}