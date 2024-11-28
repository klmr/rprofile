# rprofile

<span class="pkg">rprofile</span> stream-lines project `.Rprofile` configuration loading.


## Installation

<span class="pkg">rprofile</span> is on CRAN. Install it via

```r
install.packages('rprofile')
```

or install the development version from my R-Universe via

```r
install.packages('rprofile', repos = 'https://klmr.r-universe.dev')
```


## Usage

To use the package, call `rprofile::install()` in the directory of your project to add the following as the first line in the project `.Rprofile` file:

```r
try(rprofile::load(), silent = TRUE)
```

In most cases, that’s it. See the documentation for available parameters to customize the configuration, or have a look at this project’s own `.Rprofile` file.

At the moment, <span class="pkg">rprofile</span> performs the following actions, in order, unless disabled via arguments:

1. If the project is using an <span class="pkg">renv</span> environment, it will be activated.
2. If the project contains a `.env` file in its current path, it will be loaded via `readRenviron()`.
3. The user profile (that is, the file `~/.Rprofile`, or a file set via the `R_PROFILE_USER` environment variable) is loaded. Any errors that occur while loading this file will be converted into warnings, and `rprofile::load()` will invisibly return whether the file loaded without errors.
4. If the project is an R package, load it via `pkgload::load_all(export_all = FALSE)`. To avoid disrupting the regular package load order, this action will be deferred until after all default packages (given by `getOption('defaultPackages')`) have been loaded and attached.
