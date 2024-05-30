# LIBRARIES ----

# Shiny
library(shiny)
library(bslib)

# Core
library(tidyverse)

# LOAD DATASETS ----

load("app_data.RData")

# 1.0 USER INTERFACE ----

ui <- navbarPage(
  title = "Kantonale Abstimmungen",
  
  theme = bslib::bs_theme(
    version = 4,
    bootswatch = "minty"
  ),
  
  tabPanel(
    title = "Tabellenansicht",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h1("Filter"),
        
        selectInput(
          inputId = "selected_canton", 
          label = "Kanton:", 
          choices = unique(filters$cantons)
        )
      ),
      
      mainPanel(
        h3("Übersicht Abstimmungen"),
        tableOutput("canton_table")
      )
    )
  )
)



# 2.0 SERVER ----

server <- function(input, output) {
  
  # Reactive expression to filter data based on selected canton
  filtered_data <- reactive({
    app_table %>%
      filter(canton == input$selected_canton) %>% 
      select(-canton) %>% # Exclude the "canton" column
      group_by() # # Group by all remaining columns
  })
  
  # Render the filtered data as a table
  output$canton_table <- renderTable({
    filtered_data()
  })
    
  
}

# Run the application
shinyApp(ui = ui, server = server)