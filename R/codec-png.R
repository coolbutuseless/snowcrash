

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Encode an R object as a PNG file
#'
#' @param robj R object
#' @param filename PNG filename
#' @param alpha transparency. default: 0. Valid range [0, 1]
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encode_robj_to_png <- function(robj, filename, alpha = 0) {
  ras <- encode_robj_to_raster(robj, alpha = alpha)
  arr <- convert_raster_to_array(ras)
  png::writePNG(arr, target = filename)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Decode a PNG file to an R object
#'
#' @param filename PNG filename
#'
#' @return If PNG contains an encode object then it is decoded and returned,
#'         otherwise NULL
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
decode_png_to_robj <- function(filename) {
  arr <- png::readPNG(filename)
  ras <- convert_array_to_raster(arr)
  decode_raster_to_robj(ras)
}
