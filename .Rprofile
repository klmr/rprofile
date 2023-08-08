requireNamespace('rprofile', quietly = TRUE) && rprofile::load()

# Define some development utilities.

local({
  .pkgdir = getwd()

  build = function () {
    .rcmd('build', .pkgdir)
  }

  check = function (as_cran = TRUE) {
    bundle = .bundle()
    if (! file.exists(bundle)) build()
    .rcmd('check', if (as_cran) '--as-cran', bundle)
  }

  install = function (lib = NULL) {
    lib_arg = if (! is.null(lib)) paste0('--library=', lib)
    .rcmd('INSTALL', lib_arg, .bundle())
  }

  reload = function (export_all = FALSE) {
    devtools::load_all(.pkgdir, export_all = export_all)
  }

  .bundle = function () {
    desc = as.list(read.dcf(file.path(.pkgdir, 'DESCRIPTION'))[1L, ])
    file.path(.pkgdir, paste0(desc$Package, '_', desc$Version, '.tar.gz'))
  }

  .rcmd = function (...) {
    .r('CMD', ...)
  }

  .r = function (...) {
    rbin = file.path(R.home('bin'), 'R')
    system2(rbin, shQuote(c(...)))
  }

  # Attach only non-hidden names.
  attach(mget(ls()), name = 'rprofile-utils')
})
