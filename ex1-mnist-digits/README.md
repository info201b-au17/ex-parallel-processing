# Predict MNIST handwritten digits with kNN

Here we ask you to play with MNIST handwritten digits recognition
using kNN.  The exercise includes 3 files: 

* _load\_mnist.R_ handles MNIST data conversion.  You should not be
  concerned about this and instead load the ready made data from
  canvas. 
* _utils.R_ includes a function `showDigit` that displays the digits
  in the data as images.
* _ml.R_ includes a ready-packaged function `knn` to run the kNN
  predictor using this data.  The function expects two datasets,
  `train` and `test`, and two numbers of observations, `n1` for test
  data and `n2` for training data.  It takes a random sample of both
  datasets of the corresponding size, and returns the true and
  predicted labels for the test data, and the corresponding row number
  (called `i`).

You also need a kNN package, such as _FNN_.

Proceed as follows:

1. load the datasets _mnist\_test.csv_ and _mnist\_train.csv_.  Become
   familiar with the broad characteristics of the datasets. 
   
2. plot a few digits using the `showDigit` function.

3. use the supplied `knn` function to do some test predictions.  Use
   small number of cases (n1=1000, n2=20 for instance).
   
4. inspect the results.  How many digits are classified correctly?
   Which cases are wrong?
   
5. inspect the images of some of the wrong cases.  Do these look good?
   Ambiguous? 
   
6. Now run the predictions on larger dataset sizes.  Increase the size
   slowly as the full size data may take several minutes to process.
   
7. Analyze what is the percentage of correct predictions.

8. Repeat the exercise with different $k$ values.  Which $k$ value
   gives you the best precision?  
   Note: as we are taking a random subset, the precision on the
   subsequent runs with the same parameter values may differ.
   
   
