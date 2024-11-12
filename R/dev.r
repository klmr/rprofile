load_dev_package = function (what) {
  load_wrapper = if (isTRUE(what)) {
    pkgload_loader
  } else {
    if (! is.call(what)) {
      cnd = simpleError(
        'Invalid type for argument `dev`: expected logical or call.',
        call = sys.call(sys.parent())
      )
      stop(cnd)
    }

    \() eval(what, envir = .GlobalEnv)
  }

  if (! file.exists('DESCRIPTION')) {
    return()
  }

  # `pkgload::load_all()` (or equivalent) needs to be executed *after* the default packages have been attached, otherwise the order in the search path is wrong, and some names might be shadowed.
  # We cannot (re-)hook `.First`, because that is executed before the default packages are loaded. Furthermore, CRAN forbids overriding `.First`, since it is defined in the global environment. To work around this, we register an `attach` hook for the last default package that will be loaded.
  # Note that this may fail if either (a) the default packages list gets modified after this code executes but before `.First.sys` is executed; or (b) the “last” default package got attached out-of-order. This can happen if either the user-provided `.First` function or another package loading code (or load hook) modifies the default packages list or attaches packages.

  default_pkgs = getOption('defaultPackages')

  if (length(default_pkgs) == 0L) {
    # Something weird is going on, give up.
    warning(
      'Unable to load development package.\n',
      '\u2139 `options("defaultPackages")` is empty, which should never happen! Please check your configuration.'
    )
    return()
  }

  attached_pkgs = sub('package:', '', grep('^package:', search(), value = TRUE))
  pkgs_to_load = setdiff(default_pkgs, attached_pkgs)

  if (length(pkgs_to_load) == 0L) {
    warning(
      'Unable to load development package.\n',
      '\u2139 All `options("defaultPackages")` are already loaded and attached before `.First.sys()` was run, which',
      ' should never happen! Please check your configuration.'
    )
    return()
  }

  # De-prioritize ‘methods’, since that is loaded earlier than other packages, regardless of its position in the vector.
  last_pkg = utils::tail(c('methods', setdiff(pkgs_to_load, 'methods')), 1L)
  setHook(
    packageEvent(last_pkg, 'attach'),
    \(pkgname, libpath) {
      # Clean up after ourselves — just in case the package subsequently gets detached and reattached.
      remove_hook(packageEvent(pkgname, 'attach'), sys.function())
      load_wrapper()
    }
  )
}

pkgload_loader = function () {
  if (requireNamespace('pkgload', quietly = TRUE)) {
    pkgload::load_all(export_all = FALSE)
  }
}

remove_hook = function (hook_name, hook) {
  other_hooks = Filter(\(f) ! identical(f, hook), getHook(hook_name))
  setHook(hook_name, other_hooks, action = 'replace')
}
