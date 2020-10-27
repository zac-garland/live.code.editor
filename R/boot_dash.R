boot_side_layout <- function(...) {
  div(class = "d-flex wrapper", ...)
}

boot_sidebar <- function(...) {
  div(
    class = "bg-light border-right sidebar-wrapper",
    div(class = "list-group list-group-flush", ...)
  )
}

boot_main <- function(...) {
  div(
    class = "page-content-wrapper",
    div(class = "container-fluid", ...)
  )
}
