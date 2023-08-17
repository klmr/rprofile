# development version

## Enhancements

* Fix the package load order so that `devtools::load_all()` is called *after* all default packges are attached (if at all).
* Use `pkgload::load_all(attach = FALSE)` instead of `devtools::load_all(export_all = TRUE)` to reduce dependency count.
