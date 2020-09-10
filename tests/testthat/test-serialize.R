
test_that("multiplication works", {

  robj <- list(runif(100), 1:5)
  bytes <- encode_robj_to_bytes(robj)
  final <- decode_bytes_to_robj(bytes)

  expect_identical(robj, final)

})
