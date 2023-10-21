load_user_rprofile = function () {
  user_rprofile = Sys.getenv('R_PROFILE_USER', '~/.Rprofile')

  if (file.exists(user_rprofile)) {
    tryCatch(
      {
        sys.source(user_rprofile, envir = .GlobalEnv)
        TRUE
      },
      error = \(e) {
        warning(simpleWarning(conditionMessage(e), conditionCall(e)))
        FALSE
      }
    )
  } else {
    TRUE
  }
}
