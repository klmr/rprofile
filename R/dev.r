load_dev_package = function () {
  if (! interactive()) {
    return()
  }
  if (! file.exists('DESCRIPTION')) {
    return()
  }

  # `pkgload::load_all()` needs to be executed *after* other packages have been
  # attached. Otherwise the order in the search path is wrong, and some names
  # might be shadowed.

  # We want to load (but ideally not attach!) ‘pkgload’, *if* it is installed.
  # Simply adding it to the `defaultPackages` would cause a failure if it is not
  # installed. And checking whether it is installed here may also fail, since
  # this code is run before a potential ‘renv’ environment is set up, which may
  # or may not have ‘pkgload’.
  # We also cannot (re-)hook `.First`, because that is also executed before the
  # default packages are loaded.
  # To work around this, we hook into the last package that will be loaded, and
  # check *from there* whether ‘pkgload’ is now available or not.
  # Note that this may fail if the user — for whatever reason — manually loads
  # the last package from the `defaultPackages` inside .Rprofile (this may
  # happen inadvertently!).

  default_pkgs = getOption('defaultPackages')
  if (length(default_pkgs) == 0L) {
    # Something weird is going on, give up.
    warning(
      'Unable to load development package.\n',
      'ℹ `options("defaultPackages")` is empty, which should never happen! Please check your configuration.'
    )
    return()
  }
  last_pkg = default_pkgs[length(default_pkgs)]

  setHook(
    packageEvent(last_pkg, 'attach'),
    \(...) {
      if (requireNamespace('pkgload', quietly = TRUE)) {
        pkgload::load_all(export_all = FALSE)
      }
    },
    'append'
  )
}
