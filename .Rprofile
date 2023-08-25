requireNamespace('rprofile', quietly = TRUE) && rprofile::load()

# Define some development utilities.

local({
  .pkgdir = getwd()

  build = function () {
    build_vignette()
    .write_license_file()
    .rcmd('build', .pkgdir)
  }

  check = function (as_cran = TRUE) {
    .rcmd('check', if (as_cran) '--as-cran', .bundle())
  }

  install = function (lib = NULL) {
    lib_arg = if (! is.null(lib)) paste0('--library=', lib)
    .rcmd('INSTALL', lib_arg, .bundle())
  }

  reload = function (export_all = FALSE) {
    devtools::load_all(.pkgdir, export_all = export_all)
  }

  build_vignette = function () {
    src_path = file.path(.pkgdir, 'README.md')
    target_path = file.path(.pkgdir, 'inst', 'doc', paste0(.desc()$Package, '.html'))

    dir.create(dirname(src_path), showWarnings = FALSE, recursive = TRUE)
    markdown::mark_html(src_path, target_path)
  }

  .write_license_file = function () {
    license_text = sprintf('YEAR: 2023\nCOPYRIGHT HOLDER: %s authors', .desc()$Package)
    license_path = file.path(.pkgdir, 'LICENSE')
    writeLines(license_text, license_path)
  }

  .desc = function () {
    as.list(read.dcf(file.path(.pkgdir, 'DESCRIPTION'))[1L, ])
  }

  .bundle = function () {
    desc = .desc()
    bundle = file.path(.pkgdir, paste0(desc$Package, '_', desc$Version, '.tar.gz'))
    if (! file.exists(bundle)) build()
    bundle
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
