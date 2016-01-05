#' Title
#'
#' @param mapfile 
#'
#' @export
#'
odbcConnectManifold <- function (mapfile)

{

  full.path <- function(filename) {

    fn <- chartr("\\", "/", filename)

    is.abs <- length(grep("^[A-Za-z]:|/", fn)) > 0

    chartr("/", "\\", if (!is.abs)

      file.path(getwd(), filename)

      else filename)

  }

  con <- if (missing(mapfile))

    "Driver={Manifold Project Driver (*.map)};Dbq="

  else {

    fp <- full.path(mapfile)

    paste("Driver={Manifold Project Driver (*.map)};DBQ=",

          fp, ";DefaultDir=", dirname(fp), ";Unicode=False;Ansi=False;OpenGIS=False;DSN=Default", ";", sep = "")

  }

  RODBC::odbcDriverConnect(con)

}


