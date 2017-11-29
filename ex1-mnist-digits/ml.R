library(dplyr)
library(foreach)
library(doParallel)

knn1 <- function(train, test, n=nrow(test), k=1) {
   ## prepare data for knn
   ## train: training data
   ## test: testing data, unknown label
   ## n: now many training data examples to compute
   ##
   test <- test %>% sample_n(n)
   trainPixels <- train %>% select(-label)
   testPixels <- test %>% select(-label)
   trainLabels <- train$label
   testLabels <- test$label
   ##
   predLabels <- foreach(pixels = iter(testPixels, by="row"), .combine=c, .verbose=FALSE) %do% {
      FNN::knn(trainPixels, pixels, trainLabels, k=k)
   }
   print(predLabels)
   data.frame(i=row.names(test),
                           # original row number for the test data
              true=testLabels, predicted=predLabels)
}
