load = function (..., isolate = FALSE, renv = TRUE, dotenv = TRUE, dev = TRUE) {
  check_dots_empty()

  if (renv) {
    load_renv()
  }
  if (dotenv) {
    load_project_dotenv()
  }
  if (! isolate && ! load_user_rprofile()) {
    return(invisible(FALSE))
  }
  if (dev) {
    load_dev_package()
  }

  invisible(TRUE)
}
