<!-- README.md is generated from README.Rmd. Please edit that file -->
dplyrodbc
---------

``` r
devtools::install_github("mdsumner/RODBCDBI",   ref = "mike")
```

Example
-------

ODBC has an installed File DSN called "CountriesAccess". This is a .mdb file created using 32-bit Windows (effectively) and configured with the Data Sources application from "C:\\Windows\\SysWOW64\\odbcad32.exe".

Minimal test for RODBC.

``` r
library(RODBC)  ## remember this is 32-bit R
con <- odbcConnect("CountriesAccess1")
## some columns explode the app, presumably "Geom (I)"
sqlQuery(con, "SELECT TOP 10 * FROM [Countries Table]")
#>    ID TypeI BranchesI CoordinatesI         XI        YI LongitudeI
#> 1   1     3         2           27  -61.80090  17.35815  -61.80090
#> 2   2     3        15          338   29.89647  26.77583   29.89647
#> 3   3     3        14         1142  -64.80505 -38.93744  -64.80505
#> 4   4     3         1            3  -65.71804  68.00735  -65.71804
#> 5   5     3         1            3  -95.79415  77.15010  -95.79415
#> 6   6     3         1            3 -130.40064  54.65008 -130.40064
#> 7   7     3         1            3  -74.38840  68.49880  -74.38840
#> 8   8     3         1            3  -85.27985  69.09420  -85.27985
#> 9   9     3         1            3  -99.01495  68.36710  -99.01495
#> 10 10     3         1            3  -96.11020  67.66398  -96.11020
#>    LatitudeI     LengthI        AreaI BearingI SelectionMaskI SelectionI
#> 1   17.35815   1.6164259 3.875697e-02        0              1          1
#> 2   26.77583  58.2763842 8.910710e+01        0              1          1
#> 3  -38.93744 148.5820959 2.782561e+02        0              1          1
#> 4   68.00735   0.1791720 1.138825e-03        0              1          1
#> 5   77.15010   0.4216458 2.387700e-04        0              1          1
#> 6   54.65008   0.1101139 5.107100e-04        0              1          1
#> 7   68.49880   0.1302896 1.547000e-04        0              1          1
#> 8   69.09420   0.3088120 1.835430e-03        0              1          1
#> 9   68.36710   0.1806310 1.273350e-04        0              1          1
#> 10  67.66398   0.1491293 8.439550e-04        0              1          1
#>    VersionI
#> 1         0
#> 2         0
#> 3         0
#> 4         0
#> 5         0
#> 6         0
#> 7         0
#> 8         0
#> 9         0
#> 10        0
close(con)
```

Methods for us.

``` r

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
```

Try for real with our Access source. Here we see the engine generate a SQL query with all of the column names and table name escaped correctly, but with LIMIT 10. How to modify this to use TOP 10?

``` r
library(DBI)
library(RODBCDBI)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> 
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> 
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
x <- src_access("CountriesAccess1")

## a debug statement to print(res@sql) in the dbFetch/fetch methods shows the problem with LIMIT
e <- try(tbl(x, 'Countries Table'))
#> <SQL> SELECT * FROM [Countries Table] WHERE 0=1
```

> From: Countries Table \[3,063 x 14\]
>
> <SQL> SELECT \[ID\], \[TypeI\], \[BranchesI\], \[CoordinatesI\], \[XI\], \[YI\], \[LongitudeI\], \[LatitudeI\], \[LengthI\], \[AreaI\], \[BearingI\], \[SelectionMaskI\], \[SelectionI\], \[VersionI\] FROM \[Countries Table\] LIMIT 10
