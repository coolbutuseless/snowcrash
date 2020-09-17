

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Encode an R object into a vector of raw bytes
#'
#' If \code{zstdlite} is installed, then the serialized representation is
#' compressed using \code{zstd} compression.
#'
#' The representation is serialized with \code{serialize(..., xdr = FALSE)},
#' so if the endian of the compression and decompression machines is not the
#' same, you are likely to experience sadness.
#'
#' Setting \code{xdr = FALSE} for serialization has speed benefits - from the
#' \code{serialize()} help page: "As almost all systems in current use are
#' little-endian, xdr = FALSE can be used to avoid byte-shuffling at both ends
#' when transferring data from one little-endian machine to another (or between
#' processes on the same machine). Depending on the system, this can speed up
#' serialization and unserialization by a factor of up to 3x"
#'
#' @param robj any object which can be handled with \code{base::serialize}
#'
#' @return Vector of raw bytes
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encode_robj_to_bytes <- function(robj) {

  bytes <- base::serialize(robj, NULL, xdr = FALSE)

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
