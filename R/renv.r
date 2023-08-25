load_renv = function () {
  if (file.exists('renv/activate.R')) {
    sys.source('renv/activate.R', envir = .GlobalEnv)
  }
}
