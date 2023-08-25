# development version

## Enhancements

* Fix the package load order so that `devtools::load_all()` is called *after* all default packges are attached (if at all).
* Use `pkgload::load_all()` instead of `devtools::load_all()` to reduce dependency count.
* Load development package using `attach = FALSE` argument instead of `export_all = TRUE`. This behaviour might become configurable in the future to better suit various development workflows.
