



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' RGB or RGBA Array to Raster
#'
#' @param arr array
#'
#' @return raster
#'
#' @importFrom grDevices as.raster
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
convert_array_to_raster <- function(arr) {
  as.raster(arr)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Raster to RGBA array
#'
#' @param ras raster
#'
#' @return array
#'
#' @importFrom grDevices col2rgb
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
convert_raster_to_array <- function(ras) {

  h <- nrow(ras)
  w <- ncol(ras)

  arr <- as.vector(t(col2rgb(ras, alpha = TRUE)))/255

  arr <- array(arr, dim = c(w, h, 4))
  arr <- aperm(arr, c(2, 1, 3))

  arr
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Decode a raster
#'
#' @param ras raster
#'
#' @return raw vector
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
convert_raster_to_bytes <- function(ras) {
  arr <- convert_raster_to_array(ras) * 255
  as.raw(arr)
}



