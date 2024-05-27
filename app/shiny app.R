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
  
  theme = bslib::bs_theme(
    version = 4,
    bootswatch = "minty",
  ),
  
  tabPanel(
    title = "Explore",
           sidebarLayout(
             
             sidebarPanel(
               width = 3,
               h1("Data Explorer"),
               
               selectInput(
                 inputId = "", 
                 label = "Choose a dataset", 
                 choices = c("iris", "mtcars")),
               uiOutput("variable"),
               uiOutput("plot")
             ), # input tbd (two filters, canton and topic)
             
             mainPanel(
               h3("Data Summary"),
               verbatimTextOutput("summary"),
               h3("Data Structure"),
               verbatimTextOutput("structure")
             ) # output tbd (table)
           )
  ),
)



# 2.0 SERVER ----

server <- function(input, output) {
  
  rv <- reactiveValues()
  
  observe({
    
    rv$dataset <- data_list %>% pluck(input$dataset_choice)
  })
  
  output$variable <- renderUI({
    
    selectInput(
      inputId = "variable_choice",
      label = "Choose a variable",
      choices = names(rv$dataset),
      selected = names(rv$dataset)[1]
    ) # output tbd (table)
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)