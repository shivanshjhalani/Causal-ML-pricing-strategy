# --- Final Version: The Segmented Pricing Simulator ---

library(shiny)

# --- 1. Define the User Interface (UI) ---
ui <- fluidPage(
  
  titlePanel("Segmented OJ Pricing Strategy Simulator 🍊"),
  
  sidebarLayout(
    
    sidebarPanel(
      h4("Instructions:"),
      p("First, select a customer segment. Then, adjust the price slider to see the predicted impact on that specific group."),
      
      # Input: Dropdown to select the customer cluster
      selectInput(inputId = "cluster_select",
                  label = "Select Customer Segment:",
                  choices = c("Cluster 1" = 1, "Cluster 2" = 2, "Cluster 3" = 3,
                              "Cluster 4" = 4, "Cluster 5" = 5, "Cluster 6" = 6,
                              "Cluster 7" = 7)),
      
      # Input: Slider for price change percentage
      sliderInput(inputId = "price_change_slider",
                  label = "Select Price Change (%):",
                  min = -25, max = 25, value = 0, step = 1, post = "%")
    ),
    
    mainPanel(
      h3(textOutput("selected_cluster_title")),
      
      h4("Predicted Change in Sales:"),
      verbatimTextOutput("sales_output"),
      
      h4("Predicted Change in Revenue:"),
      verbatimTextOutput("revenue_output"),
      
      hr(),
      
      p(strong("Segment-Specific Price Elasticity:")),
      verbatimTextOutput("elasticity_display")
    )
  )
)


# --- 2. Define the Server Logic ---
server <- function(input, output) {
  
  # Store our calculated elasticities in a named vector for easy lookup
  elasticities <- c("-8.55", "-7.95", "-9.25", "-8.19", "-7.74", "-7.69", "-6.56")
  names(elasticities) <- 1:7 # Name them by cluster number
  
  # Get the elasticity for the currently selected cluster
  current_elasticity <- reactive({
    as.numeric(elasticities[input$cluster_select])
  })
  
  # Create a dynamic title based on the selected cluster
  output$selected_cluster_title <- renderText({
    paste("Predicted Impact for Cluster", input$cluster_select)
  })
  
  # Display the elasticity for the selected cluster
  output$elasticity_display <- renderText({
    paste("Elasticity:", current_elasticity())
  })
  
  # Calculate the change in sales
  sales_change_pct <- reactive({
    current_elasticity() * (input$price_change_slider / 100)
  })
  
  # Calculate the change in revenue
  revenue_change_pct <- reactive({
    (1 + (input$price_change_slider / 100)) * (1 + sales_change_pct()) - 1
  })
  
  # Render the sales output
  output$sales_output <- renderText({
    paste0(round(sales_change_pct() * 100, 2), "%")
  })
  
  # Render the revenue output
  output$revenue_output <- renderText({
    paste0(round(revenue_change_pct() * 100, 2), "%")
  })
  
}


# --- 3. Run the Application ---
shinyApp(ui = ui, server = server)