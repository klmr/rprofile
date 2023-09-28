# rprofile (development version)

## Enhancements

* Warn when no default packages are configured.
* Allow users to customize how development packages are loaded (instead of `pkgload::load_all(export_all = FALSE)`).
* Ensure that ‘methods’ is ignored during lazy-loading of dev packages, since it is loaded too early.

# rprofile 0.3.0

## Enhancements

* Make ‘renv’ ignore ‘rprofile’ as a dependency by ‘renv’ to avoid polluting the `renv::status()` output.
* Fix the package load order so that `pkgload::load_all()` is called *after* all default packages are attached (if at all).
* Use `pkgload::load_all()` instead of `devtools::load_all()` to reduce dependency count.
* Load development package using `attach = FALSE` argument instead of `export_all = TRUE`. This behaviour might become configurable in the future to better suit various development workflows.
