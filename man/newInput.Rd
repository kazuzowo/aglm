% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aglm-input.R
\name{newInput}
\alias{newInput}
\title{Create a new AGLM_Input object}
\usage{
newInput(
  x,
  qualitative_vars_UD_only = NULL,
  qualitative_vars_both = NULL,
  qualitative_vars_OD_only = NULL,
  quantitative_vars = NULL,
  use_LVar = FALSE,
  extrapolation = "default",
  add_linear_columns = TRUE,
  add_OD_columns_of_qualitatives = TRUE,
  add_interaction_columns = TRUE,
  OD_type_of_quantitatives = "C",
  nbin.max = NULL,
  bins_list = NULL,
  bins_names = NULL
)
}
\description{
Create a new AGLM_Input object
}
