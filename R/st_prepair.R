#' Automatic repair of polygon geometries
#'
#' Repair polygon geometries according to the international standards ISO 19107
#' using a constrained triangulation approach
#' (van Oosterom et al. 2005; Ledoux et al. 2014)
#'
#' @param x [sf::st_sf()], [sf::st_sfc()] or [`sfg`][sf::st_point()]
#' object (containing `POLYGON` or `MULTIPOLYGON` geometries).
#'
#' @details
#' The function supports two algorithms:
#' * oddeven: an extension of the odd-even algorithm to handle polygons
#' containing inner rings and degeneracies;
#' * setdiff: one where we follow a point set difference rule for the rings
#' (outer - inner).
#'
#' @references
#' Ledoux H, Arroyo Ohori K, and Meijers M (2014)
#' A triangulation-based approach to automatically repair GIS polygons.
#' _Computers & Geosciences_ 66:121--131.
#'
#' van Oosterom P, Quak W, and Tijssen T (2005)
#' _About Invalid, Valid and Clean Polygons_
#' In: Developments in Spatial Data Handling. Springer, Berlin, Heidelberg
#'
#' @examples
#' \dontrun{
#' # create an object containing a broken polygon geometry
#' x <- sf::st_as_sfc("POLYGON((0 0, 0 10, 10 0, 10 10, 0 0))")
#'
#' # check if this polygon is indeed broken
#' sf::st_is_valid(x)
#'
#' # repair the polygon
#' y <- st_prepair(x)
#'
#' # check that the repaired polygon has been fixed
#' print(st_is_valid(y))
#' }
#'
#' @seealso
#' See [sf::st_make_valid()] for another approach to repair polygon
#' geometries.
#'
#' @return
#' A [sf::st_sf()], [sf::st_sfc()] or [`sfg`][sf::st_point()]
#' object (same as the argument to `x`).
#'
#' @export
st_prepair <- function(x) {
  UseMethod("st_prepair")
}

#' @export
st_prepair.sfc <- function(x) {
  assert_2d_polygon_type(x)
  sf::st_sfc(CPL_prepair(x), crs = sf::st_crs(x))
}

#' @export
#' @importFrom sf st_set_geometry st_geometry
st_prepair.sf <- function(x) {
  sf::st_set_geometry(x, st_prepair(sf::st_geometry(x)))
}

#' @export
#' @importFrom sf st_sfc
st_prepair.sfg <- function(x) {
  first_sfg_from_sfc(st_prepair(st_sfc(x)))
}
