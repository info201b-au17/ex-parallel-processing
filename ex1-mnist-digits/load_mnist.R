### Load the MNIST digit recognition dataset into R
### http://yann.lecun.com/exdb/mnist/
###
### This file is under MIT license!
###
### assume you have all 4 files and gunzip'd them
### creates train$n, train$x, train$y  and test$n, test$x, test$y
### e.g. train$x is a 60000 x 784 matrix, each row is one digit (28x28)
### call:  show_digit(train$x[5,])   to see a digit.
### brendan o'connor - gist.github.com/39760 - anyall.org
### Stolen from: https://gist.github.com/brendano/39760

load_image_file <- function(filename) {
   f = file(filename,'rb')
   readBin(f,'integer',n=1,size=4,endian='big')
   n = readBin(f,'integer',n=1,size=4,endian='big')
   nrow = readBin(f,'integer',n=1,size=4,endian='big')
   ncol = readBin(f,'integer',n=1,size=4,endian='big')
   x = readBin(f,'integer', n=n*nrow*ncol,size=1,signed=FALSE)
   close(f)
   x = matrix(x, ncol=nrow*ncol, byrow=TRUE)
   colnames(x) <- paste0("px", seq(length=ncol(x)) - 1)
   x
}

load_label_file <- function(filename) {
   f = file(filename,'rb')
   readBin(f,'integer',n=1,size=4,endian='big')
   n = readBin(f,'integer',n=1,size=4,endian='big')
   y = readBin(f,'integer',n=n,size=1,signed=FALSE)
   close(f)
   y
}

train <- load_image_file('train-images-idx3-ubyte')
label <- load_label_file('train-labels-idx1-ubyte')
train <- cbind(label, as.data.frame(train))
write.table(train, file=bzfile("mnist_train.csv"),
            sep="\t", row.names=FALSE, header=TRUE) 
               
test <- load_image_file('t10k-images-idx3-ubyte')
label <<- load_label_file('t10k-labels-idx1-ubyte')  
test <- cbind(label, as.data.frame(test))
data.table::fwrite(test, file="mnist_test.csv", sep="\t")




