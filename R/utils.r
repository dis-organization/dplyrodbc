scan_db <- function(x) {
  db <- data_frame(ID = integer(0L), databasename = character(0L))
  table <- data_frame(ID = integer(0L), dbID = integer(0L), tablename = character(0L))
  column <- data_frame(ID = integer(0L), tableID = integer(0L), columnname = character(0L), coltype = character(0L))
  for (i in seq_along(x)) {
    con <- odbcConnectAccess(fp[i])
    thistab <- sqlTables(con)
    thistab <- subset(thistab, TABLE_TYPE == "TABLE")
    db <- bind_rows(db, 
                    data_frame(ID = i, databasename = basename(fp[i])))
    thistab1 <- data_frame(ID = seq(nrow(thistab)) + nrow(tables), dbID = rep(i, nrow(thistab)), tablename = thistab$TABLE_NAME)
    table <- bind_rows(table, 
                       thistab1)
    for (j in seq(nrow(thistab1))) {
      dummy <- sqlQuery(con, sprintf("SELECT * FROM [%s] WHERE 0 = 1", thistab$TABLE_NAME))
      column <- bind_rows(column, 
                          data_frame(ID = seq(ncol(dummy)) + nrow(columns), tableID = rep(thistab1$ID[j], ncol(dummy)), 
                                     columnname = names(dummy),
                                     coltype = sapply(dummy, class))
      )
    }
    close(con)
  }
  list(db = db, table = table, column = column)
  
}

create_table <- function(schema, table) {
  x <- schema$table %>% filter(tablename == table) %>% inner_join(schema$column, c("ID" = "tableID"))
  as_data_frame(setNames(lapply(x$coltype, new), x$columnname))
}
