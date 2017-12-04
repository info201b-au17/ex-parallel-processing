#!/usr/bin/env Rscript
library(dplyr)
library(doParallel)
library(foreach)

## jpg figure size
width <- 1100
height <- 1000

mapPlot <- function(data,
                    year = "1960-07-01",
                    var="airtemp",
                    title="Temperature in North America",
                    legend="Temperature\nMonthly mean, C",
                    fName="map.pdf") {
   ##
   library(ggplot2)
                           # we have to load it here for the cluster workers
   yData <- dplyr::filter(data, time == year)
   ##
   p <- ggplot(yData, aes(longitude,latitude)) +
      geom_tile(aes_string(fill=var)) +
      ## coord_map("lambert", lat0=30, lat1=50) +
                           # this take approx 5 min to run
      coord_quickmap() +
      scale_fill_gradient(low="gray10", high="orangered1", na.value="slateblue3", name=legend) +
      labs(x = "longitude (deg E)", y = "latitude (deg N)", title = title)
   pdf(file=fName, width=180/15.4, height=180/25.4)
   print(p)
   dev.off()
   "success :-)"
}

extractData <- function() {
   ## use this function to read the original large data only.
   ## In production, use the already extracted small dataset
   ## 
   data <- data.table::fread("pbzip2 -dc data/temp_prec_1960+.csv.bz2") %>%
      dplyr::filter(dplyr::between(longitude, 190, 350),
                    dplyr::between(latitude, 10, 80)) %>%
      dplyr::filter(time %in% c("1960-07-01", "1987-07-01", "2014-07-01"))
}

loadData <- function() {
   read.delim("data/temp_prec_3years.csv.bz2")
}

### data for years, titles, variables for creating all 6 maps in parallel
plotData <- data.frame(year = c("1960-07-01", "1987-07-01", "2014-07-01", "1960-07-01", "1987-07-01", "2014-07-01"),
                       var = c(rep("airtemp", 3), rep("precipitation", 3)),
                       title = c(rep("Temperature in North America", 3), rep("Precipitation in North America", 3)),
                       legend = c(rep("Temperature\nMonthly mean, C", 3), rep("Precipitation\nMonthly sum, cm", 3)),
                       fName = paste0("map", 1:6, ".pdf"),
                       stringsAsFactors = FALSE
                           # we have to keep these strings as strings!
                       )

loopPlot <- function() {
   l <- foreach(pd = iter(plotData, "row")) %do% {
      mapPlot(data, pd$year, pd$var, pd$title, pd$legend, pd$fName)
   }
}
   
mcLoopPlot <- function(n) {
   registerDoParallel(cores=n)
   l <- foreach(pd = iter(plotData, "row")) %dopar% {
      mapPlot(data, pd$year, pd$var, pd$title, pd$legend, pd$fName)
   }
}

clusterLoopPlot <- function() {
   cl <- makePSOCKcluster(c(rep("localhost", 2), rep("info201", 4)),
                          homogeneous=FALSE,
                          rscript="/usr/bin/Rscript",
                          master="172.28.100.25")
   clusterExport(cl, c("data", "mapPlot"))
   registerDoParallel(cl)
   l <- foreach(pd = iter(plotData, "row")) %dopar% {
      mapPlot(data, pd$year, pd$var, pd$title, pd$legend, pd$fName)
   }
   stopCluster(cl)
   l
}   
