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

load_renv = function () {
  if (file.exists('renv/activate.R')) {
    sys.source('renv/activate.R', envir = .GlobalEnv)
  }
}

load_user_rprofile = function () {
  user_rprofile = Sys.getenv('R_PROFILE_USER', '~/.Rprofile')

  if (file.exists(user_rprofile)) {
    tryCatch(
      {
        sys.source(user_rprofile, envir = .GlobalEnv)
        TRUE
      },
      error = function (e) {
        warning(simpleWarning(conditionMessage(e), conditionCall(e)))
        FALSE
      }
    )
  }
}

load_project_dotenv = function () {
  if (file.exists('.env')) {
    readRenviron('.env')
  }
}

load_dev_package = function () {
  if (! interactive()) {
    return()
  }
  if (! file.exists('DESCRIPTION')) {
    return()
  }

  # `devtools::load_all()` needs to be executed *after* other packages have been
  # attached. Otherwise the order in the search path is wrong, and some names
  # might be shadowed.

  # We want to load (but ideally not attach!) ‘devtools’, *if* it is installed.
  # Simply adding it to the `defaultPackages` would cause a failure if it is not
  # installed. And checking whether it is installed here may also fail, since
  # this code is run before a potential ‘renv’ environment is set up, which may
  # or may not have ‘devtools’.
  # To work around this, we hook into the last package that will be loaded,
  # and check *from there* whether ‘devtools’ is now available or not:

  default_pkgs = getOption('defaultPackages')
  if (length(default_pkgs) == 0L) {
    # Something weird is going on, but okay.
    return()
  }
  last_pkg = default_pkgs[length(default_pkgs)]

  setHook(
    packageEvent(last_pkg, 'attach'),
    \(...) {
      if (requireNamespace('devtools', quietly = TRUE)) {
        devtools::load_all(export_all = FALSE)
      }
    },
    'append'
  )
}
