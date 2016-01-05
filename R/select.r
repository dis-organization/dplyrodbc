## crucial part, since our ODBC source uses TOP instead of LIMIT
#' @export
sql_select.ODBCConnection <-
  function (con, select, from, where = NULL, group_by = NULL, having = NULL,
            order_by = NULL, limit = NULL, offset = NULL, ...)
  {
    out <- vector("list", 8)
    names(out) <- c("select", "from", "where", "group_by", "having",
                    "order_by", "limit", "offset")
    assertthat::assert_that(is.character(select), length(select) > 0L)


    if (!is.null(limit)) {
      assertthat::assert_that(is.integer(limit), length(limit) == 1L)
      ## TOP clause is part of SELECT
      out$select <- build_sql("SELECT ", " TOP ", limit, " ",  escape(select, collapse = ", ",
                                                                      con = con))
    } else {

      out$select <- build_sql("SELECT ", escape(select, collapse = ", ",
                                               con = con))
    }

    assertthat::assert_that(is.character(from), length(from) == 1L)
    out$from <- build_sql("FROM ", from, con = con)
    if (length(where) > 0L) {
      assertthat::assert_that(is.character(where))
      out$where <- build_sql("WHERE ", escape(where, collapse = " AND ",
                                              con = con))
    }
    if (!is.null(group_by)) {
      assertthat::assert_that(is.character(group_by), length(group_by) >
                                0L)
      out$group_by <- build_sql("GROUP BY ", escape(group_by,
                                                    collapse = ", ", con = con))
    }
    if (!is.null(having)) {
      assertthat::assert_that(is.character(having), length(having) == 1L)
      out$having <- build_sql("HAVING ", escape(having, collapse = ", ",
                                                con = con))
    }
    if (!is.null(order_by)) {
      assertthat::assert_that(is.character(order_by), length(order_by) >
                                0L)
      out$order_by <- build_sql("ORDER BY ", escape(order_by,
                                                    collapse = ", ", con = con))
    }

    if (!is.null(offset)) {
      assertthat::assert_that(is.integer(offset), length(offset) == 1L)
      out$offset <- build_sql("OFFSET ", offset, con = con)
    }
    escape(unname(dplyr:::compact(out)), collapse = "\n", parens = FALSE,
           con = con)
  }
