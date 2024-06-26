library(shiny)
source('global.R')

# Defining UI
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(
    title = tags$div(
      style = "width: 100%; text-align: center;",
      "Outer Space Object Launch Prediction & Forecasting"
    ),
    titleWidth = 750
  ),
  
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .main-header .logo {
          text-align: center;
          width: 100%;
          margin: 0 auto;
        }
        .main-header .navbar {
          display: flex;
          justify-content: center;
        }
      "))
    ),
    fluidRow(
      box(
        title = "Settings", 
        status = "primary", 
        solidHeader = TRUE, 
        collapsible = TRUE,
        selectInput("model", "Choose A Prediction Model :", choices = available_models),
        sliderInput("years", "Number of Years to Forecast :", min = 1, max = 27, value = 10),
        actionButton("predict", "Predict", icon = icon("chart-line")),
        br(),
        uiOutput("forecastText")
      ),
      box(
        title = "Forecast Plot", 
        status = "primary", 
        solidHeader = TRUE, 
        collapsible = TRUE,
        plotOutput("forecastPlot")
      )
    )
  )
)

# Defining Server Logic
server <- function(input, output) {
  
  observeEvent(input$predict, {
    req(input$model, input$years)
    
    forecast_data <- forecast_model(yearly_data, input$model, input$years)
    
    output$forecastPlot <- renderPlot({
      autoplot(forecast_data) +
        ggtitle(paste("Prediction & Forecast using :", input$model, "Model.")) +
        xlab("Year") +
        ylab("Total Objects Launched")
    })
    
    output$forecastText <- renderUI({
      HTML(paste("Forecast for the Next <b>", input$years, "</b> Years using <b>", input$model, "</b> Model."))
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)