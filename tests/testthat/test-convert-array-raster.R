

test_that("array-raster conversion works", {

  h <- 300
  w <- 400

  vec <- as.integer(runif(h * w * 4, 0, 255)) / 255
  arr <- array(vec, c(h, w, 4))

  ras <- convert_array_to_raster(arr)

  arr2 <- convert_raster_to_array(ras)

  expect_equal(arr, arr2)
})



test_that("encoding robj to bytes and back works", {
  robj <- runif(10)
  bytes <- encode_robj_to_bytes(robj)
  robj2 <- decode_bytes_to_robj(bytes)

  expect_equal(robj, robj2)
})



test_that("encoding robj to raster and back works", {
  robj  <- runif(10)
  ras   <- encode_robj_to_raster(robj)
  robj2 <- decode_raster_to_robj(ras)

  expect_equal(robj, robj2)
})



test_that("encoding robj to rasterGrob and back works", {
  robj <- runif(10)
  raster_grob <- encode_robj_to_rasterGrob(robj)

  # graphics devices take in a rasterGrob but output a device raster
  device_raster <- convert_rasterGrob_to_device_raster(raster_grob)

  robj2 <- decode_device_raster_to_robj(device_raster)

  expect_equal(robj, robj2)
})
