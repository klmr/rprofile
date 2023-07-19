\name{load}
\alias{load}
\title{Initialize an R session by loading the all relevant R profile configurations}
\description{
  \code{rprofile::load()} attempts to load the global R profile configuration and any other common project configuration.
}
\usage{
  \special{rprofile::load(..., renv = TRUE, dotenv = TRUE, dev = TRUE)}
}
\arguments{
  \item{...}{ignored; forces named argument passing}
  \item{renv}{[\code{logical(1)}] whether to activate an \pkg{renv}, if present (default: \code{TRUE})}
  \item{dotenv}{[\code{logical(1)}] whether to load environment variables defined in a local \file{.env} file (default: \code{TRUE})}
  \item{dev}{[\code{logical(1)}] whether to run \code{devtools::load_all()} if the current project is a development package}
}
\value{
  \code{rprofile::load()} will invisibly return whether loading the user R profile file succeeded: in case of an error, it returns \code{FALSE} and converts the error into a warning.
}
\details{
  This function should be the first thing that gets executed inside a project \file{.Rprofile} file, and it should usually be written exactly as follows: \code{requireNamespace("rprofile", quietly = TRUE) && rprofile::load()}.

  The user R profile configuration is preferentially looked up in the \env{R_PROFILE_USER} environment variable. If that is unset, it is instead loaded from \file{~/.Rprofile}. It is loaded (mostly) \emph{as-if} its code was directly copied into the project \file{.Rprofile} file.

  \code{rprofile::load()} will by default also activate the \pkg{renv} associated with the current project, if any, and will also load environment variables defined in a local \file{.env} file. These two actions will happen \emph{before} the user profile is loaded.

  Lastly, \code{rprofile::load()} will check if the code is being run from an interactive session. If so, and if the project contains a \file{DESCRIPTION} file, \pkg{rprofile} will attempt to load \pkg{devtools} and then execute \code{devtools::load_all(export_all = FALSE)}. This will happen inside the session’s \code{\link[base:Startup]{.First}} hook function, to ensure that the package load order is not disrupted by prematurely loading \pkg{devtools} or any of the package dependencies. If a \code{.First} hook function already exists (i.e. because it was defined in the system or user profile), that existing definition will be executed \emph{first}.
}
