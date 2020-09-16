

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Encode an R object into a vector of raw bytes
#'
#' If \code{zstdlite} is installed, then the serialized representation is
#' compressed using \code{zstd} compression.
#'
#' @param robj any object which can be handled with \code{base::serialize}
#'
#' @return Vector of raw bytes
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encode_robj_to_bytes <- function(robj) {

  bytes <- base::serialize(robj, NULL)

  if (requireNamespace('zstdlite', quietly = TRUE)) {
    bytes <- zstdlite::zstd_compress(bytes)
  } else {
    bytes <- memCompress(bytes, type = 'gzip')
  }

  bytes
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Unserialize bytes into an R object
#'
#' If serialized bytes were compressed using \code{zstd}, the uncompress first
#' before unserializing.
#'
#' If no object is detected in the bytes, then \code{NULL} is returned
#'
#' @param bytes vector of raw values
#'
#' @return the decoded R object if one is found, otherwise \code{NULL}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
decode_bytes_to_robj <- function(bytes) {

  if (identical(bytes[1:3], as.raw(c(0x58, 0x0a, 0x00)))) {
    # message("decode_bytes_to_robj(): serialized bytes")
    base::unserialize(bytes)
  } else if (identical(bytes[1:3], charToRaw('ZST'))) {
    # message("decode_bytes_to_robj(): ZST compressed bytes")
    if (!requireNamespace('zstdlite', quietly = TRUE)) {
      stop("decode_bytes_to_robj(): {zstdlite} required but not installed")
    }
    base::unserialize(zstdlite::zstd_decompress(bytes))
  } else {
    base::unserialize(memDecompress(bytes, type = 'gzip'))
  }
}
