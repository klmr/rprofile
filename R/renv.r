load_renv = function () {
  if (file.exists('renv/activate.R')) {
    # First, make ‘renv’ ignore ‘rprofile’ to avoid polluting the ‘renv’ status.
    renv_ignored_pkgs = getOption(
      'renv.settings.ignored.packages',
      default = getOption('renv.settings', list())$ignored.packages
    )
    options(renv.settings.ignored.packages = c(renv_ignored_pkgs, .packageName))

    sys.source('renv/activate.R', envir = .GlobalEnv)
  }
}
