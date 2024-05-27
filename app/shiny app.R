# LIBRARIES ----

# Shiny
library(shiny)
library(bslib)

# Modeling
library(modeldata)
library(DataExplorer)

# Widgets
library(plotly)

# Core
library(tidyverse)

# LOAD DATASETS ----

# insert script 01_Preprocess data here

# 1.0 USER INTERFACE ----

ui <- navbarPage(
  title = "Cantonal Voting",
  tabPanel("Data Explorer",
           sidebarLayout(
             sidebarPanel(
               selectInput("dataset", "Choose a dataset", choices = c("iris", "mtcars")),
               uiOutput("variable"),
               uiOutput("plot")
             ),
             mainPanel(
               h3("Data Summary"),
               verbatimTextOutput("summary"),
               h3("Data Structure"),
               verbatimTextOutput("structure")
             )
           )
  ),
  tabPanel("Modeling",
           sidebarLayout(
             sidebarPanel(
               selectInput("dataset2", "Choose a dataset", choices = c("iris", "mtcars")),
               uiOutput("variable2"),
               uiOutput("model")
             ),
             mainPanel(
               h3("Model Summary"),
               verbatimTextOutput("model_summary")
             )
           )
  )
)



# 2.0 SERVER ----

server <- function(input, output) {
  
  # insert code for Server here
  
}

# Run the application
shinyApp(ui = ui, server = server)