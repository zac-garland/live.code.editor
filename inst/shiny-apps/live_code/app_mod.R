

devtools::load_all()




# app ---------------------------------------------------------------------
ui <- tagList(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "default.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style_slim.css")
  ),
  bootstraplib::bootstrap(),
  navbarPage(
    collapsible = TRUE,
    title = app_title(),
    tabPanel(
      "Tab 1",
      mod_wrangle_ui("wrangle_ui_1")
    ),
    tabPanel(
      "Tab 2"
    )
  )
)

server <- function(input, output) {


  callModule(mod_wrangle_server, "wrangle_ui_1")


}

shinyApp(ui, server)
