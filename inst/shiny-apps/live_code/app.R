

devtools::load_all()




# app ---------------------------------------------------------------------
ui <- tagList(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "default.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style_slim.css")
  ),
  bootstrap(),
  navbarPage(
    collapsible = TRUE,
    title = app_title(),
    tabPanel(
      "Tab 1",
      boot_side_layout(
        boot_sidebar(
          sliderInput(
            inputId = "bins",
            label = "Number of bins:",
            min = 1,
            max = 50,
            value = 30
          )
        ),
        boot_main(
          fluidRow(column(6, h1("Plot 1")), column(6, h1("Plot 2"))),
          fluidRow(
            column(6, plotOutput(outputId = "distPlot")),
            column(6, plotOutput(outputId = "distPlot2"))
          )
        )
      )
    ),
    tabPanel(
      "Tab 2",
      boot_side_layout(
        boot_sidebar(h1("sidebar input")),
        boot_main(h1("main output"))
      )
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    hist(x,
         breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times"
    )
  })

  output$distPlot2 <- renderPlot({
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    hist(x,
         breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times"
    )
  })
}

shinyApp(ui, server)
