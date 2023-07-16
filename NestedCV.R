## we show in the html the code of the implementation since it was explicitly requested

# create k folds given the training set
makeFolds<-function(training,K){
  folds<-createFolds(training$y,k = K, returnTrain = FALSE,list = T)
  folder <- lapply(folds, function(idx) training[idx, ])
  return(folder)
}

#Nested Cross-V (outer function)
nested.cv2<-function(training,R,K,d,q, alpha, lambda){
  es <- c()
  a.list<- c()
  b.list<- c()
  #outer cv
  for (r in 1:R){
    folds <- makeFolds(training,K)
    
    for (k in 1:K){
      # take all the folds except the k-th one
      training.folds <- folds[-k]     ## list of dataframe
      
      holdout.fold <- folds[[k]]      
      
      # prediction error estimates with the inner-cv on the training set
      e.in<- inner.cv2(training.folds, d, q,alpha,lambda)
      
      # evaluate coefficients on the training folds
      training.folds <- bind_rows(folds[-k])      ## map list of dataframes in a unique dataframe 
      
      model <- my_spline3(training.folds, d, q, alpha, lambda)
      coeffs <- model$beta
      
      # evaluate the loss (in terms of residuals) on the hold-out set
      predictions <- predict(model, as.matrix(build_dm(holdout.fold$x,d,q)), type="response")
      e.out <- (predictions - holdout.fold$y)^2  # error on the k-th hold-out set
      
      # populate our vectors for final aggregation of the results
      temp1 <- (mean(e.in) - mean(e.out))^2
      a.list <- c(a.list, temp1)
      
      temp2 <- var(e.out)/length(holdout.fold$x)
      b.list <- c(b.list, temp2)
      
      es <- c(es, e.in)
    }
  }
  rmse <- sqrt(mean(a.list) - mean(b.list))
  err.ncv <- mean(es)
  return(list("rmse"=rmse, "err.ncv"=err.ncv))#, "es"=es))
}

#inner loop
inner.cv2 <- function(folds, d, q, alpha, lambda){
  k <- length(folds) # number of folds from the previous partitioning
  # init the losses for each fold set
  e.in <- c()
  for(i in 1:k){
    # leave one set out for validation
    training.set <- bind_rows(folds[-i])
    holdout.set <- folds[[i]]
    # evaluate the coefficients on the new training set
    model <- my_spline3(training.set, d, q, alpha, lambda)
    coeffs <- model$beta
    
    # evaluate the loss (in terms of residuals) on the new hold-out set
    predictions <- predict(model, as.matrix(build_dm(holdout.set$x,d,q)), type="response")
    true.vals <- holdout.set$y 
    # define the loss between the predicted value and the true value as the squared difference
    temp <- (predictions - true.vals)^2
    e.in <- c(e.in, temp) # add the error on the i-th hold-out set
  }
  return(e.in)
}