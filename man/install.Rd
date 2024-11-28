\name{install}
\alias{install}
\title{Invoke \pkg{rprofile} in a project R profile}
\description{
  \code{install()} sets up \pkg{rprofile} in a project R profile.
}
\usage{
  install(project = '.', ...)
}
\arguments{
  \item{project}{The project directory (defaults to the current working directory)}
  \item{...}{Additional, named arguments passed to \code{\link{load}()}}
}
\details{
  Invoking this function prepends the following line to the project’s R profile (creating the file, if it does not yet exist):

  \preformatted{try(rprofile::load(...), silent = TRUE)}

  Where \code{...} are the additional arguments passed to \code{install()}.

  \code{install()} will do nothing if it detects that \pkg{rprofile} is already installed in the project’s R profile.
}
