# rprofile 0.3.0

## Enhancements

* Make ‘renv’ ignore ‘rprofile’ as a dependency by ‘renv’ to avoid polluting the `renv::status()` output.
* Fix the package load order so that `devtools::load_all()` is called *after* all default packges are attached (if at all).
* Use `pkgload::load_all()` instead of `devtools::load_all()` to reduce dependency count.
* Load development package using `attach = FALSE` argument instead of `export_all = TRUE`. This behaviour might become configurable in the future to better suit various development workflows.
