library(MASS) # For Boston
library(aglm)

# Function to produce a data.frame of O-dummies
make.bins <- function(data, max.nbin = 100){
  temp <- apply(data, 2, function(x){as.vector(quantile(x, seq(0, 1, 1 / (min(max.nbin, length(x)) - 1))))})
  apply(temp, 2, unique)
}

## Read data
xy <- Boston # xy is a data.frame to be processed.
colnames(xy)[ncol(xy)] <- "y" # Let medv be the objective variable, y.

## Split data into train and test
n <- nrow(xy) # Sample size.
set.seed(2018) # For reproducibility.
test.id <- sample(n, round(n/4)) # ID numbders for test data.
test <- xy[test.id,] # test is the data.frame for testing.
train <- xy[-test.id,] # train is the data.frame for training.
x <- train[-ncol(xy)]
y <- train$y
newx <- test[-ncol(xy)]
y_true <- test$y

## Create bins
bins_list <- make.bins(x[, colnames(x) != "chas"])
bins_names <- colnames(x)[colnames(x) != "chas"]

## Set chas and rad variables as factors
x$chas <- as.factor(x$chas)
x$rad <- as.ordered(x$rad)
newx$chas <- factor(newx$chas, levels=levels(x$chas))
newx$rad <- ordered(newx$rad, levels=levels(x$rad))


## Select the best lambda by `cv.aglm()`, fixing `alpha=1` (LASSO)
cv.model <- cv.aglm(x, y, bins_list=bins_list, bins_names=bins_names)
lambda.min <- cv.model@lambda.min
cat("lambda.min: ", lambda.min, "\n")

# Predict y for newx
y_pred <- predict(cv.model, newx=newx, s="lambda.min")
cat("RMSE: ", sqrt(mean((y_true - y_pred)^2)), "\n")
plot(y_true, y_pred)


## Select the best (alpha, lambda) simultaneously by `cva.aglm()`
cva.model <- cva.aglm(x, y, bins_list=bins_list, bins_names=bins_names)

alpha.min <- cva.model@alpha.min
lambda.min <- cva.model@lambda.min
cat("alpha.min: ", alpha.min, "\n")
cat("lambda.min: ", lambda.min, "\n")

## Predict y for newx
best_model <- aglm(x, y, lambda=lambda.min, alpha=alpha.min,bins_list=bins_list, bins_names=bins_names)
y_pred <- predict(best_model, newx=newx)
cat("RMSE: ", sqrt(mean((y_true - y_pred)^2)), "\n")
plot(y_true, y_pred)
