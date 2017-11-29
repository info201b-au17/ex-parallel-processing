library(dplyr)

showDigit <- function(data, i, col=gray(12:1/12), ...) {
   ## data: a data frame, holding the mnist digits data.
   ## i    which digit: row in the data frame
   ## col  colors (need 12 colors)
   cat("label is", data$label[i], "\n")
   data <- data %>%
      select(-label)
                           # remove the label
   pixels <- as.numeric(data[i,]) %>%
      matrix(nrow=28)
                           # transform data to 28x28 matrix (upside down)
   pixels <- pixels[,28:1]
                           # flip the digit upward
   image(z=pixels, col=col, asp=1, ...)
}

