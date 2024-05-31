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
  title = HTML("Kantonale Abstimmungen<br><small>Stand: 2024-04-27</small>"),
 
  
  
  theme = bslib::bs_theme(
    version = 4,
    bootswatch = "minty"
  ),
  
  tabPanel(
    title = "Abstimmungsübersicht",
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
  ), 
  
  # create a second tab where i show a table called tags_table, without a sidebar
  tabPanel(
    title = "Themenübersicht",
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
        h3("Übersicht Themen"),
        tableOutput("tags_table")
      )
    )
  
  )
)



# 2.0 SERVER ----

server <- function(input, output) {
  
  # tab 1
  # Reactive expression to filter data based on selected canton
  filtered_data <- reactive({
    app_table %>%
      filter(canton == input$selected_canton) %>% 
      select(-canton) %>% # Exclude the "canton" column
      group_by() # # Group by all remaining columns
  })
  
  # tab 2
  # Reactive expression to filter data based on selected canton
  grouped_data <- reactive({
    tags_df %>%
      filter(canton == input$selected_canton) %>% 
      select(-canton) %>% # Exclude the "canton" column
      group_by() # # Group by all remaining columns
  })
  

  # tab 1  
  # Render the filtered data as a table
  output$canton_table <- renderTable({
    filtered_data()
  })
  
  # tab 2
  # Render the filtered data as a table
  output$tags_table <- renderTable({
    grouped_data()
  })    
  
}

# Run the application
shinyApp(ui = ui, server = server)