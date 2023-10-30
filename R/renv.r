load_renv = function () {
  if (file.exists('renv/activate.R')) {
    sys.source('renv/activate.R', envir = .GlobalEnv)
  }
}

configure_renv = function () {
  renv_ignored_pkgs = getOption(
    'renv.settings.ignored.packages',
    default = getOption('renv.settings', list())$ignored.packages
  )

  options(
    # Have ‘renv’ ignore ‘rprofile’ to avoid polluting the ‘renv’ status.
    renv.settings.ignored.packages = c(renv_ignored_pkgs, .packageName),
    # Disable the loading of a global `.Rprofile` file via ‘renv’ (if set by the user) since that conflicts with ‘rprofile’.
    renv.config.user.profile = FALSE
  )
}

disable_renv_autoloader = function () {
  # Disable the addition of `source("renv/activate.R")` to new `.Rprofile` scripts.
  # This has the side-effect of disabling ‘renv’ auto-loading entirely, but since we set this option *after* ‘renv’ was loaded, this does not matter.
  options(renv.config.autoloader.enabled = FALSE)
}
