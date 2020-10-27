#' this_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_this_data_ui <- function(id, filter = NULL){
  ns <- NS(id)

  names <- ls("package:datasets")
  if (!is.null(filter)) {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, filter, logical(1))]
  }




  tagList(
    selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
  )
}







#' this_data Server Function
#'
#' @noRd
mod_this_data_server <- function(input, output, session){
  ns <- session$ns

  reactive(get(input$dataset, "package:datasets"))


}

## To be copied in the UI
# mod_this_data_ui("this_data_ui_1")

## To be copied in the server
# callModule(mod_this_data_server, "this_data_ui_1")

