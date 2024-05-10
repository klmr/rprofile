\name{load}
\alias{load}
\title{Initialize an R session by loading the all relevant R profile configurations}
\description{
  \code{rprofile::load()} attempts to load the global R profile configuration and any other common project configuration.
}
\usage{
  \special{rprofile::load(..., isolate = FALSE, renv = TRUE, dotenv = TRUE, dev = TRUE)}
}
\arguments{
  \item{...}{ignored; forces named argument passing}
  \item{isolate}{[\code{logical(1)}] whether to isolate the project from the global configuration (default: \code{FALSE})}
  \item{renv}{[\code{logical(1)}] whether to activate an \pkg{renv}, if present (default: \code{TRUE})}
  \item{dotenv}{[\code{logical(1)}] whether to load environment variables defined in a local \file{.env} file (default: \code{TRUE})}
  \item{dev}{[\code{logical(1)|call}] whether to run \code{pkgload::load_all()} if the current project is a development package (default: \code{TRUE}; see \strong{Details})}
}
\value{
  \code{rprofile::load()} will invisibly return whether loading the user R profile file succeeded: in case of an error, it returns \code{FALSE} and converts the error into a warning.
}
\details{
  This function should be the first thing that gets executed inside a project \file{.Rprofile} file, and it should usually be written exactly as follows: \code{try(rprofile::load())} (the \code{try()} is present to ensure that \verb{R CMD} can still run in the current directory when  \pkg{rprofile} is not installed).

  Unless \code{isolate = TRUE} is set, the user R profile configuration is preferentially looked up in the \env{R_PROFILE_USER} environment variable. If that is unset, it is instead loaded from \file{~/.Rprofile}. It is loaded (mostly) \emph{as-if} its code was directly copied into the project \file{.Rprofile} file. By contrast, if \code{isolate = TRUE} is set, no attempt to load any further \file{.Rprofile} files is made.

  \code{rprofile::load()} will by default also activate the \pkg{renv} associated with the current project, if any, and will also load environment variables defined in a local \file{.env} file. These two actions will happen \emph{before} the user profile is loaded. See the \strong{Note} below.

  Lastly, \code{rprofile::load()} will check if the code is being run from an interactive session. If so, and if the project contains a \file{DESCRIPTION} file, \pkg{rprofile} will attempt to load \pkg{pkgload} and then execute \code{pkgload::load_all(export_all = FALSE)}. To avoid disrupting the regular package load order, this action will be deferred until after all default packages (given by \code{getOption('defaultPackages')}) have been loaded and attached. Users can customize which code should be run by passing an unevaluated expression (instead of \code{TRUE}) in the \code{dev} argument. Since this code will be evaluated \emph{after} the remaining \file{.Rprofile} code has been run, the argument may refer to functions defined afterwards (see \strong{Examples}).
}
\note{
  You need to ensure that \pkg{renv} is not loaded redundantly in your \file{.Rprofile} file. In other words, please make sure that the line \code{source("renv/activate.R")}, which \pkg{renv} adds automatically, is \emph{not} present in the file. \code{rprofile::load()} prevents \pkg{renv} from subsequently adding this line to the project \file{.Rprofile} file.
}
\examples{
# Each option is configurable; in the extreme case, the function does nothing:
rprofile::load(isolate = TRUE, renv = FALSE, dotenv = FALSE, dev = FALSE)

\dontrun{
# In general, the following code should be the first line of a project’s
# `.Rprofile` file (using `try()` ensures that R code can still run in the
# current directory even if ‘rprofile’ is not installed — this is important in
# particular to allow `R CMD CHECK` to run successfully on CI/CD without having
# to first install ‘rprofile’):
try(rprofile::load())
}

\dontrun{
# We can customize how to load development packages, .e.g.:
try(rprofile::load(dev = quote(reload())))

reload = function () {
  devtools::document()
  devtools::load_all(quiet = TRUE)
}
}
}
