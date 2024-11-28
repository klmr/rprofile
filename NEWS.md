# development version

## Breaking changes

* ‘rprofile’ now loads a package in development even in non-interactive mode; this was always the intended behavior, despite the previous (documented) diverging behavior.


## Enhancements

* New function `rprofile::install(...)` prepends `try(rprofile::load(...), silent = TRUE)` to the current project’s R profile.


# rprofile 0.4.0

## Bug fixes

* Prevent ‘rprofile’ from being included in the `renv.lock` file when a new ‘renv’ project is initialized.
* Prevent breaking when no user R profile configuration exists.


## Enhancements

* Clean up hook function after invoking ‘rprofile’ dev package loader.
* Disable the ‘renv’ auto-loader to prevent it from writing the autoload code, which conflicts with ‘rprofile’, to the project `.Rprofile`.
* Warn if no default packages are configured or if they are already all attached after the user profile is run.
* Allow users to customize how development packages are loaded (instead of `pkgload::load_all(export_all = FALSE)`).
* Ensure that ‘methods’ is ignored during lazy-loading of dev packages, since it is loaded too early.


# rprofile 0.3.0

## Enhancements

* Make ‘renv’ ignore ‘rprofile’ as a dependency by ‘renv’ to avoid polluting the `renv::status()` output.
* Fix the package load order so that `pkgload::load_all()` is called *after* all default packages are attached (if at all).
* Use `pkgload::load_all()` instead of `devtools::load_all()` to reduce dependency count.
* Load development package using `attach = FALSE` argument instead of `export_all = TRUE`. This behaviour might become configurable in the future to better suit various development workflows.
