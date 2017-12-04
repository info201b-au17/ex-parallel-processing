### only for data prep!

extractData <- function() {
   ## use this function to read the original large data only.
   ## In production, use the already extracted small dataset
   ## 
   data <- data.table::fread("pbzip2 -dc data/temp_prec_1960+.csv.bz2") %>%
      dplyr::filter(dplyr::between(longitude, 190, 350),
                    dplyr::between(latitude, 10, 80)) %>%
      dplyr::filter(time %in% c("1960-07-01", "1987-07-01", "2014-07-01"))
}
