test_that("return the correct class", {
  # skips
  skip_on_win32()
  # data
  x <- sf::st_as_sfc("POLYGON((0 0, 0 10, 10 0, 10 10, 0 0))")
  # tests
  expect_s3_class(st_prepair(x), "sfc")
  expect_s3_class(st_prepair(x[[1]]), "sfg")
  expect_s3_class(st_prepair(sf::st_sf(data.frame(id = 1), geometry = x)), "sf")
})

test_that("repairs broken polygons", {
  # skips
  skip_on_win32()
  # data
  x1 <- sf::st_as_sfc("POLYGON((0 0, 0 10, 10 0, 10 10, 0 0))")
  x2 <- sf::st_as_sfc(
    "POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 2, 5 7, 10 7, 10 2, 5 2))"
  )
  x3 <- sf::st_as_sfc(
    "POLYGON((0 0, 10 0, 15 5, 10 0, 10 10, 0 10, 0 0))"
  )
  x4 <- sf::st_as_sfc(
    paste(
      "POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),",
      "(1 1, 1 8, 3 8, 3 1, 1 1), (3 1, 3 8, 5 8, 5 1, 3 1))"
    )
  )
  x5 <- sf::st_as_sfc(
    paste(
      "POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),",
      "(2 8, 5 8, 5 2, 2 2, 2 8), (3 3, 4 3, 3 4, 3 3))"
    )
  )
  # tests
  expect_false(st_is_valid(x1))
  expect_false(st_is_valid(x2))
  expect_false(st_is_valid(x3))
  expect_false(st_is_valid(x4))
  expect_false(st_is_valid(x5))
  expect_true(st_is_valid(st_prepair(x1)))
  expect_true(st_is_valid(st_prepair(x2)))
  expect_true(st_is_valid(st_prepair(x3)))
  expect_true(st_is_valid(st_prepair(x4)))
  expect_true(st_is_valid(st_prepair(x5)))
})

test_that("removes small sliver", {
  # skips
  skip_on_win32()
  # data
  x <- sf::st_as_sfc("POLYGON((0 0, 10 0, 10 11, 11 10, 0 10))")
  y <- st_as_sfc(
    paste(
      "MULTIPOLYGON (",
      "((0 0, 10 0, 10 10, 0 10, 0 0)),",
      "((10 10, 11 10, 10 11, 10 10))",
      ")"
    )
  )
  # tests
  expect_equal(st_prepair(x), y)
})

test_that("only accepts polygon and multipolygon", {
  # skips
  skip_on_win32()
  # data
  x1 <- sf::st_as_sfc("POINT(1 1)")
  x2 <- sf::st_as_sfc("LINESTRING (30 10, 10 30, 40 40)")
  x3 <- sf::st_as_sfc(
    paste(
      "GEOMETRYCOLLECTION (",
      "POINT (40 10), ",
      "LINESTRING (10 10, 20 20, 10 40), ",
      "POLYGON ((40 40, 20 45, 45 30, 40 40))",
      ")"
    )
  )
  # tests
  expect_error(st_prepair(x1), "POLYGON or MULTIPOLYGON")
  expect_error(st_prepair(x2), "POLYGON or MULTIPOLYGON")
  expect_error(st_prepair(x2), "POLYGON or MULTIPOLYGON")
})

test_that("skips empty polygons", {
  # skips
  skip_on_win32()
  # tests
  expect_equal(st_prepair(sf::st_polygon()), sf::st_polygon())
  expect_equal(st_prepair(sf::st_polygon()), sf::st_polygon())
  expect_equal(st_prepair(sf::st_multipolygon()), sf::st_multipolygon())
  expect_equal(st_prepair(sf::st_multipolygon()), sf::st_multipolygon())
})
