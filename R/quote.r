
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
