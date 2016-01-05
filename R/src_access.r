
src_access <- function(dbname = NULL, host = NULL, port = NULL, user = NULL,
                       password = NULL, ...) {

  con <-    dbConnect(RODBCDBI::ODBC(), dsn=dbname)

  src_sql("access", con)
}



src_desc.src_access <- function(con) {
  info <- dbGetInfo(con$con)
  host <- if (info$host == "") "localhost" else info$host

  paste0("Access ", info$serverVersion, " [", info$user, "@",
         host, ":", info$port, "/", info$dbname, "]")
}


db_list_tables.src_access <- function(con) {
  dbListTables(con$con)
}

db_has_table.src_access <- function(con, table) {
  dbExistsTable(con$con, table)
}

tbl.src_access <- function(src, from, ...) {
  tbl_sql("access", src = src, from = from, ...)
}

src_translate_env.src_access <- dplyr:::src_translate_env.NULL


