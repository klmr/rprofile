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
  \item{dev}{[\code{logical(1)}] whether to run \code{pkgload::load_all()} if the current project is a development package}
}
\value{
  \code{rprofile::load()} will invisibly return whether loading the user R profile file succeeded: in case of an error, it returns \code{FALSE} and converts the error into a warning.
}
\details{
  This function should be the first thing that gets executed inside a project \file{.Rprofile} file, and it should usually be written exactly as follows: \code{requireNamespace("rprofile", quietly = TRUE) && rprofile::load()}.

  Unless \code{isolate = TRUE} is set, the user R profile configuration is preferentially looked up in the \env{R_PROFILE_USER} environment variable. If that is unset, it is instead loaded from \file{~/.Rprofile}. It is loaded (mostly) \emph{as-if} its code was directly copied into the project \file{.Rprofile} file. By contrast, if \code{isolate = TRUE} is set, no attempt to load any further \file{.Rprofile} files is made.

  \code{rprofile::load()} will by default also activate the \pkg{renv} associated with the current project, if any, and will also load environment variables defined in a local \file{.env} file. These two actions will happen \emph{before} the user profile is loaded.

  Lastly, \code{rprofile::load()} will check if the code is being run from an interactive session. If so, and if the project contains a \file{DESCRIPTION} file, \pkg{rprofile} will attempt to load \pkg{pkgload} and then execute \code{pkgload::load_all(export_all = FALSE)}. To avoid disrupting the regular package load order, this action will be deferred until after all default packages (given by \code{getOption('defaultPackages')}) have been loaded and attached.
}
\examples{
# Each option is configurable; in the extreme case, the function does nothing:
rprofile::load(isolate = TRUE, renv = FALSE, dotenv = FALSE, dev = FALSE)

\dontrun{
# In general, the following code should be the first line of a project
# `.Rprofile` file, which first tests whether the package is installed, and then
# loads it and runs the chosen initializations:
requireNamespace("rprofile", quietly = TRUE) && rprofile::load()
}
}
