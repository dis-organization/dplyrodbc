# library(DBI)
# 
# library(RSQLite)
# 
# 
# con <- dbConnect(RSQLite::SQLite(), ":memory:")
# data(USArrests)
# dbWriteTable(con, "USArrests", USArrests)
# 
# 
# library(RODBCDBI)
# #library(dplyr)
# con <-    dbConnect(RODBCDBI::ODBC(), dsn="Countries_lowres")
# connectionInfo <- dbGetInfo(con)
# result <- dbSendQuery(con, "SELECT * FROM [Countries Table] WHERE 0=1")
# fetchedResult <- dbFetch(result)
# dbGetInfo(result)  ## needs rows fetched etc
# ##dbGetInfo(RODBCDBI::ODBC())  ## not implemented
# 

src_rodbcdbi <- function(dbname = NULL, host = NULL, port = NULL, user = NULL,
                         password = NULL, ...) {

  con <-    dbConnect(RODBCDBI::ODBC(), dsn="Countries")

  src_sql("rodbcdbi", con)
}



#' @export
src_desc.src_rodbcdbi <- function(con) {
  info <- dbGetInfo(con$con)
  host <- if (info$host == "") "localhost" else info$host

  paste0("manifold ", info$serverVersion, " [", info$user, "@",
    host, ":", info$port, "/", info$dbname, "]")
}


db_list_tables.src_rodbcdbi <- function(con) {
  dbListTables(con$con)
}

db_has_table.src_rodbcdbi <- function(con, table) {
  dbExistsTable(con$con, table)
}

tbl.src_rodbcdbi <- function(src, from, ...) {
  tbl_sql("rodbcdbi", src = src, from = from, ...)
}

sql_squote <- 
function (x) 
{
 # y <- gsub(quote, paste0(quote, quote), x, fixed = TRUE)
  y <- paste0("[", x, "]")
  y[is.na(x)] <- "NULL"
  names(y) <- names(x)
  y
}

sql_escape_string.ODBCConnection <- function(con, x) {
   sql_squote(x)
}

sql_escape_ident.ODBCConnection<- function(con, x) {
  sql_squote(x)
}

src_translate_env.src_rodbcdbi <- dplyr:::src_translate_env.NULL


library(DBI)
library(RODBCDBI)
library(dplyr)
x <- src_rodbcdbi()

tbl(x, 'Table')



setMethod("dbGetInfo", "ODBCConnection",
          function (dbObj, ...)
{

       info <- RODBC::odbcGetInfo(dbObj@odbc)
     list(host = unname(info["DBMS_Name"]),
         serverVersion = unname(info["DBMS_Ver"]),
         user = NULL,  port = NULL,
         dbname = unname(info["Data_Source_Name"]))

}
)


#          names(RODBC::sqlQuery(conn@connection@odbc, sprintf("SELECT TOP 1 * FROM [%s]", name)))


setMethod("dbListFields", "ODBCResult",
    function(conn, name, ...) {

           # print(str(conn))
           # return(conn)
            names(dbFetch(conn))

    }
)
setMethod("dbFetch", "ODBCResult",
function (res, n = -1, ...)
{

    RODBC::sqlQuery(res@connection@odbc, res@sql)
    #res
    #is_done(res) <- TRUE
    #result
}
)


