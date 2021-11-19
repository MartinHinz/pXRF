#' @export
fine_calibration_mineral <- function(x) {
  # get calibration data
  data("fine_calibration", envir=environment())

  for (element in fine_calibration$symbol) {
    this_calibration_factor <- fine_calibration[fine_calibration$symbol==element,"calibration_factor"]
    x[,element] <- x[,element] * this_calibration_factor
  }

  return(x[fine_calibration$symbol])
}
