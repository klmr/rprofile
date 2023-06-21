load = function (renv = TRUE, env = TRUE) {
  if (renv) {
    load_renv()
  }
  if (env) {
    load_project_env()
  }
  load_user_rprofile()
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
