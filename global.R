library(shiny)
library(shinydashboard)
library(tidyverse)
library(data.table)
library(ggplot2)
library(plotly)
library(caret)
library(randomForest)
library(DT)
library(jsonlite)

# Load Default Dataset

default_data <- read.csv(
  "C:/Users/Owner/OneDrive/Desktop/healthcare-risk-platform/data/reactive.csv"
)

# Convert Outcome column into factor

default_data$Outcome <- as.factor(
  default_data$Outcome
)