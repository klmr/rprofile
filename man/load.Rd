\name{load}
\alias{load}
\title{Initialize R session by loading the all relevant R profile configurations}
\description{
    \code{rprofile::load()} attempts to load the global R profile configuration and any other common project configuration.
}
\usage{
    \special{rprofile::load()}
}
\arguments{
    \item{renv}{[\code{logical(1L)}] whether to activate an \pkg{renv}, if present (default: \code{TRUE})}
    \item{env}{[\code{logical(1L)}] whether to load environment variables defined in a local \file{.env} file (default: \code{TRUE})}
}
\value{
    \code{rprofile::load()} will return whether loading the user R profile file succeeded: in case of an error, it returns \code{FALSE} and converts the error into a warning. If no user R profile file was found, it invisibly returns \code{NULL}.
}
\details{
    This function should be the first thing that gets executed inside a project \file{.Rprofile} file.

    The user R profile configuration is preferentially looked up in the \env{R_PROFILE_USER} environment variable. If that is unset, it is instead loaded from \file{~/.Rprofile}. It is loaded (mostly) \emph{as-if} its code was directly copied into the project \file{.Rprofile} file.

    As of now, \code{rprofile::load()} will by default also activate the \pkg{renv} associated with the current project, if any, and will also load environment variables defined in a local \file{.env} file.
}
