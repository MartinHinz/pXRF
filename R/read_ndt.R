# filename <- "~/Downloads/XL3t-91903_Knochen.ndt"
# fileSize <- file.info(filename)$size;
#
# test <- readBin(filename, "raw", n=fileSize)
# begin_data_pattern <- as.raw(c(0X83, 0XE0, 0XC3, 0X43))
# begin_image_pattern <- as.raw(c(0XFF, 0xD8, 0xFF, 0XE0, 0X00, 0X10, 0X4A, 0X46, 0X49, 0X46))
# end_image_pattern <- as.raw(c(0XFF, 0xD9))
#
# find_seq <- function(v,x){
#   idx <- which(v == x[1])
#   idx[sapply(idx, function(i) all(v[i:(i+(length(x)-1))] == x))]
# }
#
# begin_data <- find_seq(test, begin_data_pattern)-1
# measurements <- list()
# for(entry in begin_data[1]){
#   measurement_raw <- test[entry+5:6]
#   measurement_number <- readBin(measurement_raw, "integer", n=2, size = 2)
#   end <- begin_data[begin_data>entry][1]-1
#   measurements[measurement_number] <- list(test[entry:end])
# }
#
# measurements[77]
#
# images_begin <- find_seq(test, begin_image)-1
# find_seq(test, end_image)
#
# test_bild1 <- test[23037:27225]
#
# tail(test_bild1)
# library(jpeg)
#
# img <- readJPEG(test_bild1)
# plot(1:2, type='n')
# rasterImage(img, 1, 1.25, 1.1, 1)
