library(shiny)
library(shinydashboard)
library(ggplot2)

# Assuming this is your weather dataset
weather <- read.csv(text = "https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv")

# User interface
ui <- dashboardPage(
  dashboardHeader(title = "Kokshe"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Instructions", tabName = "instructions", icon = icon("info")),
      menuItem("Graphs", tabName = "graphs", icon = icon("chart-line")),
      menuItem("Chat with GPT", tabName = "chat", icon = icon("comments"))
    )
  ),
  dashboardBody(
    tabItems(
      # Instructions Page
      tabItem("instructions",
              fluidRow(
                box(
                  title = "Instructions",
                  width = 12,
                  solidHeader = TRUE,
                  status = "primary",
                  textInput("region", "Укажите регион", ""),
                  textInput("crop", "Укажите вид овощной культуры", ""),
                  actionButton("submit_button", "Отправить")
                )
              )
      ),
      
      # Graphs Page
      tabItem("graphs",
              fluidRow(
                box(
                  title = "Температура",
                  width = 6,
                  plotOutput("temp_plot")
                ),
                box(
                  title = "Влажность почвы",
                  width = 6,
                  plotOutput("humidity_plot")
                ),
                box(
                  title = "Осадки",
                  width = 6,
                  plotOutput("precipitation_plot")
                ),
                box(
                  title = "Солнечная радиация",
                  width = 6,
                  plotOutput("radiation_plot")
                )
              )
      ),
      
      # Chat Page
      tabItem("chat",
              fluidRow(
                box(
                  title = "Chat with GPT",
                  width = 12,
                  height = "500px",
                  textOutput("chat_output"),
                  textInput("user_input", "Your message"),
                  actionButton("send_button", "Send")
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Placeholder for server logic
  
  # Generate random data based on selected region and crop
  reactive_data <- reactive({
    data.frame(
      Date = seq(Sys.Date(), length.out = 100, by = "days"),
      Temperature = rnorm(100, mean = 25, sd = 5),
      Humidity = rnorm(100, mean = 60, sd = 10),
      Precipitation = rpois(100, lambda = 5),
      Radiation = rnorm(100, mean = 200, sd = 50)
    )
  })
  
  # Render the temperature plot
  output$temp_plot <- renderPlot({
    ggplot(reactive_data(), aes(x = Date, y = Temperature)) +
      geom_line() +
      labs(title = "Температура", y = "Температура (Celsius)")
  })
  
  # Render the humidity plot
  output$humidity_plot <- renderPlot({
    ggplot(reactive_data(), aes(x = Date, y = Humidity)) +
      geom_line() +
      labs(title = "Влажность почвы", y = "Влажность почвы (mm)")
  })
  
  # Render the precipitation plot
  output$precipitation_plot <- renderPlot({
    ggplot(reactive_data(), aes(x = Date, y = Precipitation)) +
      geom_bar(stat = "identity") +
      labs(title = "Осадки", y = "Осадки (mm)")
  })
  
  # Render the radiation plot
  output$radiation_plot <- renderPlot({
    ggplot(reactive_data(), aes(x = Date, y = Radiation)) +
      geom_line() +
      labs(title = "Солнечная радиация", y = "Солнечная радиация (W)")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
