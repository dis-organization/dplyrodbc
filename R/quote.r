
sql_surroundquote <-
  function (x, surround0, surround1 = surround0)
  {
    # y <- gsub(quote, paste0(quote, quote), x, fixed = TRUE)
    y <- paste0(surround0, x, surround1)
    y[is.na(x)] <- "NULL"
    names(y) <- names(x)
    y
  }
sql_escape_comma <- function(x) {
  gsub(",", " + Chr(44) + ", x)
}
sql_escape_string.ODBCConnection <- function(con, x) {
  ##x <- sql_escape_comma(x)
  sql_surroundquote(x, "\"")
}


sql_escape_ident.ODBCConnection<- function(con, x) {
  sql_surroundquote(x, "[", "]")
}
