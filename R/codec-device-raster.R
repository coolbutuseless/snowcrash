
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert integer vector into raw vector (unpacking 4-raw-values per integer)
#'
#' @param int32_vec vector of raw values
#' @param endian little or big?. default: 'litle'
#' @param ... other arguments ignored
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int32_to_raw <- function(int32_vec, endian = c('little', 'big'), ...) {
  stopifnot(is.integer(int32_vec))
  endian <- match.arg(endian)

  writeBin(int32_vec, raw(), size = 4L, useBytes = TRUE, endian = endian)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a device raster to a raw vector
#'
#' @param device_raster a raster object passed from R graphics system to
#'        the graphics device. It is an integer vector with packed ABGR values
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
decode_device_raster_to_bytes <- function(device_raster) {
  size <- sqrt(length(device_raster))

  # raster objects which contain R objects created by this package are
  # always square.
  if (length(device_raster) != size*size || size == 0) {
    return(NULL)
  }

  values <- as.raw(int32_to_raw(device_raster))
  arr    <- array(values, c(4, size, size))
  as.vector(aperm(arr, c(3, 2, 1)))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Extract a R object encoded in a device-raster
#'
#' Return NULL of device-raster does not contain an object
#'
#' @param device_raster a raster object passed from R grpahics system to
#'        the graphics device. It is an integer vector with packed ABGR values
#'
#' @return R object if there is one encoded in the device-raster, otherwise NULL
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
decode_device_raster_to_robj <- function(device_raster) {
  bytes <- decode_device_raster_to_bytes(device_raster)
  decode_bytes_to_robj(bytes)
}


