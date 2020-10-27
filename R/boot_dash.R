boot_side_layout <- function(...) {
  shiny::div(class = "d-flex wrapper", ...)
}

boot_sidebar <- function(...) {
  shiny::div(
    class = "bg-light border-right sidebar-wrapper",
    shiny::div(class = "list-group list-group-flush", ...)
  )
}

boot_main <- function(...) {
  shiny::div(
    class = "page-content-wrapper",
    shiny::div(class = "container-fluid", ...)
  )
}
