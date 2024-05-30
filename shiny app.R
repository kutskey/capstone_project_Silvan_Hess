# LIBRARIES ----

# Shiny
library(shiny)
library(bslib)

# Core
library(tidyverse)

# LOAD DATASETS ----

load("data_prep/app_data.RData")

# 1.0 USER INTERFACE ----

ui <- navbarPage(
  title = "Cantonal Voting",
  
  theme = bslib::bs_theme(
    version = 4,
    bootswatch = "minty"
  ),
  
  tabPanel(
    title = "Explore",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h1("Data Explorer"),
        
        selectInput(
          inputId = "selected_canton", 
          label = "Select Canton:", 
          choices = unique(app_table$canton)
        )
      ),
      
      mainPanel(
        h3("Table Summary"),
        tableOutput("canton_table")
      )
    )
  )
)



# 2.0 SERVER ----

server <- function(input, output) {
  
  filtered_data <- reactive({
    app_table[app_table$canton == input$selected_canton, ]
  })
  
  # Render the filtered data as a table
  output$canton_table <- renderTable({
    filtered_data()
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)