


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Encode an R object as a raster
#'
#' The object is serialized and compressed and put into the RGB elements of
#' an RGBA array.
#'
#' @param robj Any R object
#' @param alpha alpha channel value. default: 0, i.e. raster is invisible.
#'        This option  may be useful in debugging
#'        i.e. set to non-zero value so raster is visible.  Valid range [0, 1]
#'
#' @importFrom grDevices as.raster
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encode_robj_to_raster <- function(robj, alpha = 0) {

  alpha <- min(max(alpha, 0), 1)

  bytes <- encode_robj_to_bytes(robj)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # pad out bytes so it can fill a square 3D array with 3 planes (i.e. RGB)
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  size   <- ceiling(sqrt(length(bytes)/3))
  total  <- size * size * 3 # 3 channels
  bytes  <- c(bytes, raw(total -length(bytes)))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Construct an alpha channel.
  # Set all values to 0, so it will not render as a visible
  # raster on non-supported devices
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alpha <- as.raw(rep(alpha * 255, size*size))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Create an image raster for this data
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  data <- as.integer(c(bytes, alpha))/255
  arr  <- array(data, c(size, size, 4))
  ras  <- grDevices::as.raster(arr)

  ras
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Raster to robject
#'
#' Return NULL if the raster does not contain an encoded R object
#'
#' @param ras raster
#'
#' @return R object if one is encoded in the raster, otherwsie NULL
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
decode_raster_to_robj <- function(ras) {
  bytes <- convert_raster_to_bytes(ras)
  decode_bytes_to_robj(bytes)
}


