# fitting function for AGLM model
# written by Kenji Kondo @ 2019/1/1


#' fit an AGLM model
#'
#' @param x An input matrix or data.frame to be fitted.
#' @param y An integer or numeric vector which represents response variable.
#' @param qualitative_vars_UD_only A list of indices or names for specifying which columns are qualitative and need only U-dummy representations.
#' @param qualitative_vars_both A list of indices or names for specifying which columns are qualitative and need both U-dummy and O-dummy representations.
#' @param qualitative_vars_OD_only A list of indices or names for specifying which columns are qualitative and need only O-dummy representations.
#' @param quantitative_vars A list of indices or names for specyfying which columns are quantitative.
#' @param use_LVar A boolean value which indicates whether this function uses L-variable representations or not.
#' @param extrapolation A character value which indicates how contribution curves outside bins are extrapolated.
#'   * "default": No extrapolations.
#'   * "flat": Extrapolates with flat lines.
#' @param add_linear_columns A boolean value which indicates whether this function uses linear effects or not.
#' @param add_OD_columns_of_qualitatives A boolean value which indicates whether this function use O-dummy representations for qualitative and ordinal variables or not.
#' @param add_interaction_columns A boolean value which indicates whether this function uses intersection effects or not.
#' @param OD_type_of_quantitatives A character value which indicates how O-dummy matrices of quantitative
#'   values are constructed. Choose "C"(default) or "J".
#'   * "C": Continuous-type dummies, which result continuous contribution curves.
#'   * "J": Jump-type dummies, which result contribution curves with jumps.
#'   * "N": No use of O-dummies
#' @param family Response type. Currently "gaussian", "binomial", and "poisson" are supported.
#' @param nbin.max a maximum number of bins which is automatically generated. Only used when `breaks` is not set.
#' @param bins_list A list of numeric vectors, each element of which is used as breaks when binning of a quantitative variable or a qualitative variable with order.
#' @param bins_names A list of column name or column index, each name or index of which specifies which column of `x` is binned used with an element of `bins_list` in the same position.
#' @param ... Other arguments are passed directly to backend (currently glmnet() is used), and if not given, backend API's default values are used to call backend functions.
#'
#' @return An AccurateGLM object, fitted to the data (x, y)
#'
#' @export
#' @importFrom assertthat assert_that
#' @importFrom glmnet glmnet
aglm <- function(x, y,
                 qualitative_vars_UD_only=NULL,
                 qualitative_vars_both=NULL,
                 qualitative_vars_OD_only=NULL,
                 quantitative_vars=NULL,
                 use_LVar=FALSE,
                 extrapolation="default",
                 add_linear_columns=TRUE,
                 add_OD_columns_of_qualitatives=TRUE,
                 add_interaction_columns=FALSE,
                 OD_type_of_quantitatives="C",
                 nbin.max=NULL,
                 bins_list=NULL,
                 bins_names=NULL,
                 family=c("gaussian","binomial","poisson","cox"),
                 ...) {
  # Create an input object
  x <- newInput(x,
                qualitative_vars_UD_only=qualitative_vars_UD_only,
                qualitative_vars_both=qualitative_vars_both,
                qualitative_vars_OD_only=qualitative_vars_OD_only,
                quantitative_vars=quantitative_vars,
                use_LVar=use_LVar,
                extrapolation=extrapolation,
                add_linear_columns=add_linear_columns,
                add_OD_columns_of_qualitatives=add_OD_columns_of_qualitatives,
                add_interaction_columns=add_interaction_columns,
                OD_type_of_quantitatives=OD_type_of_quantitatives,
                nbin.max,
                bins_list,
                bins_names)

  # Check y
  y <- drop(y)
  if (family[1] != "cox") {
    y <- as.numeric(y)
  }
  #assert_that(class(y) == "integer" | class(y) == "numeric")
  assert_that(length(y) == dim(x@data)[1])

  # Check family
  if (is.character(family))
    family <- match.arg(family)

  # Create a design matrix which is passed to backend API
  x_for_backend <- getDesignMatrix(x)

  # Data size
  nobs <- dim(x_for_backend)[1]
  nvars <- dim(x_for_backend)[2]
  assert_that(length(y) == nobs)

  # Call backend
  args <- list(x=x_for_backend,
               y=y,
               family=family,
               ...)
  glmnet_result <- do.call(glmnet, args)

  return(new("AccurateGLM", backend_models=list(glmnet=glmnet_result), vars_info=x@vars_info, call=match.call()))
}
