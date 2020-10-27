#' wrangle UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
wrangle_ui_mod <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      boot_side_layout(
        boot_sidebar(
          searchInput(
            inputId = ns("data_id"),
            label = "Data:",
            placeholder = "mtcars, diamonds, ...",
            btnSearch = icon("search"),
            btnReset = icon("remove"),
            width = "100%"
          ),
          rHandsontableOutput(ns("data_pre"))
        ),
        boot_main(
          rHandsontableOutput(ns("data_pre_result"), height = "900px")
        )
      )
    )
  )
}


#' wrangle Server Function
#'
#' @noRd
wrangle_server_mod <- function(input, output, session) {
  sessionval <- session$ns("")

  # default parameters ----
  def_params <- tibble(params = c("#Example Comment", rep_len(NA_character_, 19)))

  # reactive values----
  reac_values <- reactiveValues(
    data_pre = def_params
  )

  # reactive data ----
  reac_data <- reactive({
    get(input$data_id)
  })

  # screening table output ----
  output$data_pre <- renderRHandsontable({
    def_params %>%
      rhandsontable(stretchH = "all",width = "200px")
  })

  # update screening code reactive values ----
  observe({
    if (!is.null(input$data_pre)) {
      reac_values$data_pre <- hot_to_r(input$data_pre)
    }
  })

  # process data ----
  filt_df <- reactive({
    data_pre <- reac_values$data_pre

    bbg_series <- reac_data()

    params <- data_pre %>%
      filter(
        !is.na(params),
        !is.null(params),
        params != "",
        str_sub(params,1,1) != "#"
      )

    if (length(params$params) > 0) {
      params <- params %>%
        mutate(
          row_n = 1:nrow(.),
          params = ifelse(
            row_n == max(row_n, na.rm = T),
            params,
            paste0(params, "%>%")
          )
        ) %>%
        pull(params) %>%
        str_c(collapse = "")
    } else {
      params <- NULL
    }



    if (length(params) >= 1) {
      eval(parse(text = paste0("filt_df <- bbg_series %>%", params)))
    } else {
      filt_df <- bbg_series
    }

    print(paste0("filt_df <- bbg_series %>%", params))
    print(filt_df)

    filt_df
  })

  # output filtered results ----
  output$data_pre_result <- renderRHandsontable({
    filt_df() %>%
      rhandsontable(stretchH = "all") %>%
      hot_cols(fixedColumnsLeft = 1) %>%
      hot_table(highlightCol = TRUE, highlightRow = TRUE)
  })
}

## To be copied in the UI
# mod_wrangle_ui("wrangle_ui_1")

## To be copied in the server
# callModule(mod_wrangle_server, "wrangle_ui_1")

