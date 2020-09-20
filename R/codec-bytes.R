

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Encode an R object into a vector of raw bytes
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
  bytes <- base::memCompress(base::serialize(robj, NULL, xdr = FALSE), type = 'gzip')
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
  base::unserialize(base::memDecompress(bytes, type = 'gzip'))
}
