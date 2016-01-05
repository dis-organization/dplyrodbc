

#' Title
#'
#' @param prj 
#'
#' @return CRS
#' @export 
#' @author boB Rudis <bob at rudis.net>
#' @examples
#' \dontrun{
#' ##  https://stat.ethz.ch/pipermail/r-sig-geo/2016-January/023861.html
#' prj <- paste0(readLines("110m_admin_1_states_provinces_shp.prj"))
#' prj_to_epsg(prj)
#' ## CRS arguments:
#' ##  +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
#' ## +towgs84=0,0,0
#' 
#' prj_1 <- 'PROJCS["Transverse_Mercator",
#'     GEOGCS["GCS_OSGB 1936",
#'     DATUM["D_OSGB_1936",
#'     SPHEROID["Airy_1830",6377563.396,299.3249646]],
#'     PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],
#'     PROJECTION["Transverse_Mercator"],
#'     PARAMETER["latitude_of_origin",49],
#'     PARAMETER["central_meridian",-2],
#'     PARAMETER["scale_factor",0.9996012717],
#'     PARAMETER["false_easting",400000],
#'     PARAMETER["false_northing",-100000],
#'     UNIT["Meter",1]]'
#' prj_to_epsg(prj_1)
#' ## CRS arguments:
#' ##  +init=epsg:27700 +proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717
#' ## +x_0=400000 +y_0=-100000 +datum=OSGB36 +units=m +no_defs +ellps=airy
#' ## +towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894
#' }
prj_to_epsg <- function(prj) {
  
  require(sp)
  require(httr)
  require(jsonlite)
  
  res <- GET("http://prj2epsg.org/search.json",
             query=list(exact=TRUE,
                        error=TRUE,
                        mode="wkt",
                        terms=prj))
  
  # one shld prbly do more error checking than this
  stop_for_status(res)
  
  dat <- fromJSON(content(res, as="text", flatten=TRUE))
  
  # NOTE: there could be more in dat$codes if prj was ambiguous
  CRS(paste0("+init=epsg:", dat$codes[1, "code"]))
  
}

