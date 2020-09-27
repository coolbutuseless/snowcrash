# snowcrash 0.1.4 2020-09-27

* Increase error checking when attempting to decode a raster.

# snowcrash 0.1.3 2020-09-20

* Remove `zstdlite` (that package is not mature enough to be a dependency here)

# snowcrash 0.1.2

* When serializing with `base::serialize()` set `xdr = FALSE` for faster
  performance

# snowcrash 0.1.1

* Use `base::memCompress()` if `zstdlite` is not installed.

# snowcrash 0.1.0

* Initial release
