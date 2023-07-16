# monomial transformation - useful for the power expansion in polynomial regression
monom <- function(x, d)(x^d)

# truncated power expansion - useful for the natural spline basis extension
trunc.power <- function(x, q, d) (max(c(0, x - q)))^d

spline.func <- function(x, beta, d, q){
  # init power expansion vector
  expans <- beta[[1]]
  for(i in 1:d){
    expans <- expans + (beta[[i+1]]*monom(x, i))
  }
  # initialize knots intervals
  knots <- seq(0,1,length.out = q+2)
  knots <- knots[-c(1,length(knots))]
  
  for(k in 1:q){
    expans <- expans + (beta[[k+d+1]]*trunc.power(x, knots[k], d))
  }
  
  return(expans)
} 


## build a new design matrix [ncols=(d+1)+q] mapping our starting feature
build_dm <- function(x,d,q){
  
  data <- data.frame(x = x)
  
  # polynomial expansion
  X_prime <- matrix(NA,nrow(data),(d+1))
  for (j in 1:(ncol(X_prime))){
    X_prime[,j] <- unlist(lapply(data$x, monom, j-1))
  }
  
  # initialize knots intervals
  knots <- seq(0,1,length.out = q+2)
  knots <- knots[-c(1,length(knots))]
  
  # design matrix extension over the q knots values (to merge it with x_prime)
  X_second <- matrix(NA,nrow(X_prime), q)
  for (j in 1:(ncol(X_second))){
    X_second[,j] <- unlist(lapply(data$x, trunc.power, knots[j], d))
  }
  
  # final design Matrix where ncols=(d+1)+q
  X <- data.frame(cbind(X_prime,X_second))
  return(X)
}

# implement our natural spline model using a combo of feature map in truncated power basis plus lm model
my_spline <- function(data, d, q){
  
  # use our function to map the feature in a new space
  X <- build_dm(data$x, d, q)
  df <- data.frame(y = data$y, X)
  
  # pass the brand new design matrix to a simple regression model
  model <- lm(y ~ .-1, data = df )
  
  return(model)
}


# implement our natural spline model using a combo of feature map in truncated power basis plus glmnet model
my_spline2 <- function(data, d, q, alpha, lambda){
  
  # use our function to map the feature in a new space
  X <- build_dm(data$x, d, q)
  df <- data.frame(y = data$y, X)
  
  # pass the brand new design matrix to a simple regression model
  model <- glmnet(X, df$y, alpha = alpha, lambda = lambda)
  
  return(model)
}



my_spline3 <- function(data, d, q, alpha, lambda){
  
  # use our function to map the feature in a new space
  X <- build_dm(data$x, d, q)
  df <- data.frame(y = data$y, X)
  
  pre <- scale(X[,-1]) 
  
  X <- cbind(X[,1],pre)  
  
  # pass the brand new design matrix to a simple regression model
  model <- glmnet(X, df$y, alpha = alpha, lambda = lambda)
  
  return(model)
}


### First implementation of our spline model is based on the lm function from stats
# a named list that well defines the structure of our lm model and the associated functions 
my_method <- list(
  library = c("dplyr", "tidyr", "stats"), # used libraries
  type = "Regression",                    # type of the problem we want to solve
  parameters = data.frame(                # space of parameters we want to test
    parameter = c("d", "q"),
    class = c("numeric", "numeric"),
    label = c("Polynomial degree", "Number of knots")),
  grid = function(x, y, len = NULL, search = "grid") {
    expand.grid(
      d = c(1,3),
      q = c(3,10)
    )
  }
  ,
  
  # custom fit function to define the model
  fit = function(x,y,wts = NULL, param = NULL, lev = NULL, last = NULL, weights = NULL, classProbs = NULL , ...){
    data <- data.frame(y = y, x = x)
    index <- unique(sapply(c(row.names(data)), as.numeric))
    # create the design matrix with the custom function
    X <- build_dm(x, param$d, param$q)
    
    # build dataframe
    df <- data.frame(y = data$y,X)
    
    # pass the brand new design matrix to a simple regression model
    model <- lm(y ~.-1, data = df)
    
    # other callable attributes
    model$design <- X
    
    model$index <- index
    
    tot <- build_dm(training$x, param$d, param$q)
    
    X_new <- tot[-c(index),]
    
    model$X_new <- X_new
    
    return(model)
  }
  ,
  
  # custom predict function
  predict  = function(modelFit, newdata, preProc = NULL, submodels = NULL){
    
    newdata <- modelFit$X_new
    
    return (predict(modelFit, newdata))
  },
  
  prob = NULL
  
)

### Second implementation of the strucuture with glmnet from glmnet package
# a named list that well defines the structure of our glmnet model and the associated functions 
my_method2 <- list(library = c("dplyr", "tidyr", "stats","glmnet"),
                   type = "Regression",
                   parameters = data.frame(
                     parameter = c("d", "q", "alpha", "lambda"),
                     class = c("numeric", "numeric", "numeric", "numeric"),
                     label = c("Polynomial degree", "Number of knots", "alpha", "regularization")
                   ),
                   grid = function(x, y, len = NULL, search = "grid") {
                     expand.grid(
                       d = c(1,3),
                       q = c(3,10),
                       alpha = c(0,0.5,1),
                       lambda = seq(0.0001, 1, length = 10)
                     )
                   }
                   ,
                   
                   fit = function(x,y,wts = NULL, param = NULL, lev = NULL, last = NULL, weights = NULL, classProbs = NULL , ...){
                     
                     data <- data.frame(y = y, x = x)
                     
                     index <- unique(sapply(c(row.names(data)), as.numeric))
                     
                     # build a new design matrix mapping our starting feature 
                     # polynomial expansion
                     
                     X <- build_dm(x, param$d, param$q)
                     
                     df <- data.frame(y = data$y,X)
                     
                     
                     # pass the brand new design matrix to a simple regression model
                     model <- glmnet(X, df$y, alpha = param$alpha, lambda = param$lambda)
                     
                     model$design <- as.matrix(X)
                     
                     model$index <- index
                     
                     tot <- as.matrix(build_dm(training$x, param$d, param$q))
                     
                     X_new <- tot[-c(index),]
                     
                     model$X_new <- X_new
                     
                     print(X_new)
                     
                     return(model)
                   }
                   ,
                   
                   predict  = function(modelFit, newdata, preProc = NULL, submodels = NULL){
                     
                     
                     newdata <- modelFit$X_new
                     
                     return (predict(modelFit, newdata))},
                   
                   prob = NULL
)


### Third implementation with glmnet function and pre-processing techniques on our data
# a named list that well defines the structure of our glmnet model and the associated functions 
my_method3 <- list(library = c("dplyr", "tidyr", "stats","glmnet"),
                   type = "Regression",
                   parameters = data.frame(
                     parameter = c("d", "q", "alpha", "lambda"),
                     class = c("numeric", "numeric", "numeric", "numeric"),
                     label = c("Polynomial degree", "Number of knots", "alpha", "regularization")
                   ),
                   grid = function(x, y, len = NULL, search = "grid") {
                     expand.grid(
                       d = c(1,3),
                       q = c(3,10),
                       alpha = c(0,0.5,1),
                       lambda = seq(0.0001, 1, length = 10)
                     )
                   }
                   ,
                   
                   fit = function(x,y,wts = NULL, param = NULL, lev = NULL, last = NULL, weights = NULL, classProbs = NULL , ...){
                     
                     
                     data <- data.frame(y = y, x = x)
                     
                     
                     index <- unique(sapply(c(row.names(data)), as.numeric))
                     
                     # build a new design matrix mapping our starting feature 
                     # polynomial expansion
                     X <- build_dm(x, param$d, param$q)
                     
                     pre <- scale(X[,-1])                                            
                     
                     X <- cbind(X[,1],pre)                                             
                     
                     df <- data.frame(y = data$y,X)
                     
                     
                     # pass the brand new design matrix to a simple regression model
                     model <- glmnet(X, df$y, alpha = param$alpha, lambda = param$lambda)
                     
                     model$design <- as.matrix(X)
                     
                     model$index <- index
                     
                     tot <- as.matrix(build_dm(training$x, param$d, param$q))
                     
                     X_new <- tot[-c(index),]
                     
                     pre <- scale(X_new[,-1])                                             
                     
                     X_new <- cbind(X_new[,1],pre)                         
                     
                     model$X_new <- X_new
                     
                     return(model)
                   }
                   ,
                   
                   predict  = function(modelFit, newdata, preProc = NULL, submodels = NULL){
                     
                     newdata <- modelFit$X_new
                     
                     return (predict(modelFit, newdata))},
                   
                   prob = NULL
                   
)
