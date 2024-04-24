#' @noRd
#' @importFrom sf st_geometry_type
assert_2d_polygon_type <- function(x) {
  if (!any(sf::st_geometry_type(x) %in% c("POLYGON", "MULTIPOLYGON"))) {
    stop(
      "argument to `x` must contain only POLYGON or MULTIPOLYGON geometries",
      call. = FALSE
    )
  }
  if (st_is_z_non_null(x)) {
    stop(
      "argument to `x` must not contain 3D geometries; use st_zm() to drop Z",
      call. = FALSE
    )
  }
  TRUE
}

#' @noRd
first_sfg_from_sfc <- function(x) {
  if (length(x) == 0) {
    sf::st_multipolygon()
  } else {
    x[[1]]
  }
}

#' @noRd
st_is_z_non_null <- function(x) {
  if (length(x) == 0) {
    FALSE
  } else {
    grepl("Z", class(x[[1]])[1])
  }
}
