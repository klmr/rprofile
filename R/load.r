load = function (..., isolate = FALSE, renv = TRUE, dotenv = TRUE, dev = TRUE) {
  check_dots_empty()

  if (renv) {
    configure_renv()
    load_renv()
    disable_renv_autoloader()
  }

  if (dotenv) {
    load_project_dotenv()
  }

  if (! isolate && ! load_user_rprofile()) {
    return(invisible(FALSE))
  }

  if (! isFALSE(dev)) {
    load_dev_package(dev)
  }

  invisible(TRUE)
}
