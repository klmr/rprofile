load = function (renv = TRUE, env = TRUE, dev = TRUE) {
  if (renv) {
    load_renv()
  }
  if (env) {
    load_project_env()
  }
  if (! load_user_rprofile()) {
    return(FALSE)
  }
  if (dev) {
    load_dev_package()
  }

  TRUE
}

load_renv = function () {
  if (file.exists("renv/activate.R")) {
    sys.source("renv/activate.R", envir = .GlobalEnv)
  }
}

load_user_rprofile = function () {
  user_rprofile = Sys.getenv("R_PROFILE_USER", "~/.Rprofile")

  if (file.exists(user_rprofile)) {
    tryCatch({
        sys.source(user_rprofile, envir = .GlobalEnv)
        TRUE
      },
      error = function (e) {
        warning(conditionMessage(e))
        FALSE
      }
    )
  }
}

load_project_env = function () {
  if (file.exists(".env")) {
    readRenviron(".env")
  }
}

load_dev_package = function () {
  if (! interactive()) {
    return()
  }
  if (! file.exists("DESCRIPTION")) {
    return()
  }

  first = get0(".First", envir = .GlobalEnv, mode = "function", ifnotfound = function () {})

  .GlobalEnv$.First = function () {
    first()

    if (requireNamespace("devtools", quietly = TRUE)) {
      devtools::load_all(export_all = FALSE)
    }
  }
}
