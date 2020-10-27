#' wrangle UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @export
#' @importFrom shiny NS tagList
mod_wrangle_ui <- function(id) {
  ns <- shiny::NS(id)

  names <- ls("package:datasets")

  shiny::tagList(
    shiny::fluidPage(
      shiny::fluidRow(
        shiny::column(
          width = 4,
          shiny::selectInput(ns("dataset"), "Pick a dataset", choices = names),
          rhandsontable::rHandsontableOutput(ns("data_pre"))
        ),
        shiny::column(
          width = 8,
          rhandsontable::rHandsontableOutput(ns("data_pre_result"))
        )
      )

    )
  )
}


#' wrangle Server Function
#' @export
#' @noRd
mod_wrangle_server <- function(input, output, session, data) {
  sessionval <- session$ns("")

  # default parameters ----
  def_params <- tibble::tibble(params = c("#Example Comment", rep_len(NA_character_, 19)))

  # reactive values----
  reac_values <- shiny::reactiveValues(
    data_pre = def_params
  )

  # reactive data ----
  reac_data <- shiny::reactive({
    base::get(input$dataset, "package:datasets") %>%
      tibble::as_tibble()
  })

  # screening table output ----
  output$data_pre <- rhandsontable::renderRHandsontable({
    def_params %>%
      rhandsontable::rhandsontable(stretchH = "all", width = "200px")
  })

  # update screening code reactive values ----
  shiny::observe({
    if (!is.null(input$data_pre)) {
      reac_values$data_pre <- rhandsontable::hot_to_r(input$data_pre)
    }
  })

  # process data ----
  filt_df <- shiny::reactive({
    data_pre <- reac_values$data_pre

    data_series <- reac_data()

    params <- data_pre %>%
      dplyr::filter(
        !is.na(params),
        !is.null(params),
        params != "",
        stringr::str_sub(params, 1, 1) != "#"
      )

    if (length(params$params) > 0) {
      params <- params %>%
        dplyr::mutate(
          row_n = 1:nrow(.),
          params = ifelse(
            row_n == max(row_n, na.rm = T),
            params,
            paste0(params, "%>%")
          )
        ) %>%
        dplyr::pull(params) %>%
        stringr::str_c(collapse = "")
    } else {
      params <- NULL
    }



    if (length(params) >= 1) {
      eval(parse(text = paste0("filt_df <- data_series %>%", params)))
    } else {
      filt_df <- data_series
    }

    print(paste0("filt_df <- data_series %>%", params))
    print(filt_df)

    filt_df
  })

  # output filtered results ----
  output$data_pre_result <- rhandsontable::renderRHandsontable({
    filt_df() %>%
      rhandsontable::rhandsontable(stretchH = "all") %>%
      rhandsontable::hot_cols(fixedColumnsLeft = 1) %>%
      rhandsontable::hot_table(highlightCol = TRUE, highlightRow = TRUE)
  })
}

## To be copied in the UI
# mod_wrangle_ui("wrangle_ui_1")

## To be copied in the server
# callModule(mod_wrangle_server, "wrangle_ui_1")
