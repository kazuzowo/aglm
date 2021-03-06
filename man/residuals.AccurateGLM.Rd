% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/residuals-aglm.R
\name{residuals.AccurateGLM}
\alias{residuals.AccurateGLM}
\title{Calculate residuals for AGLM model}
\usage{
\method{residuals}{AccurateGLM}(
  model,
  x = NULL,
  y = NULL,
  offset = NULL,
  weights = NULL,
  type = c("working", "pearson", "deviance"),
  s = NULL
)
}
\arguments{
\item{model}{An AccurateGLM object.}

\item{type}{Type of prediction required.
\itemize{
\item Type \code{"working"} Working residuals.
\item Type \code{"pearson"} Pearson residuals.
\item Type \code{"deviance"} Devian residuals.
}}

\item{s}{A numeric value specifying lambda value at which plotting is required.}
}
\value{
The object returned depends on type.
}
\description{
Calculate residuals for AGLM model
}
