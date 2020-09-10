

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Encode an R object as a rasterGrob
#'
#' The object is serialized and compressed and put into the RGB elements of
#' an RGBA array that is wrapped in a \code{rasterGrob}
#'
#' @param robj Any R object
#' @param alpha alpha channel value. default: 0, i.e. raster is invisible.
#'        This option  may be useful in debugging
#'        i.e. set to non-zero value so raster is visible.  Valid range [0, 1]
#' @param ... other arguments passed to \code{grid::rasterGrob()}
#'
#' @importFrom grid rasterGrob
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encode_robj_to_rasterGrob <- function(robj, alpha = 0, ...) {
  ras <- encode_robj_to_raster(robj, alpha = alpha)
  grid::rasterGrob(image=ras, interpolate = FALSE, ...)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Decode a rasterGrob to an R object
#'
#' @param raster_grob a \code{grid::rasterGrob()} object
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
decode_rasterGrob_to_robj <- function(raster_grob) {
  decode_raster_to_robj(raster_grob$raster)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a rasterGrob into a device raster to mimic a graphics device
#'
#' This function is needed to simulate the behaviour of R graphics devices.
#'
#' When a rasterGrob is passed to a graphics device, it encodes the raster as a
#' \code{device-raster} which is an integer array containing packed colour values
#' in ABGR format.  This integer vector is then delivered to the graphics device
#' to display.
#'
#' @param raster_grob rasterGrob
#'
#' @return A \code{device-raster}. An integer vector, where each 32 bit integer
#' represents a packed colour value in ABGR format (which 8 bits per colour).
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
convert_rasterGrob_to_device_raster <- function(raster_grob) {
  ras <- raster_grob$raster
  arr <- convert_raster_to_array(ras) * 255
  mode(arr) <- 'integer'

  raw_vec <- as.raw(as.vector(aperm(arr, c(3, 2, 1))))

  readBin(raw_vec, what = 'int', n = length(raw_vec)/4, size = 4L)
}


