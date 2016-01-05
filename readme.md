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
fs <- list.files("R", pattern = ".r$", full.names = TRUE)
for (i in fs) source(i)
```

Try for real with our Access source.

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

accesstable <- tbl(x, "Countries Table")
## filter
accesstable  %>% filter(ID == 1)
#> Source: Access  [@ACCESS:/ACCESS]
#> From: Countries Table [1 x 14]
#> Filter: ID == 1 
#> 
#>      ID TypeI BranchesI CoordinatesI       XI       YI LongitudeI
#>   (int) (int)     (int)        (int)    (dbl)    (dbl)      (dbl)
#> 1     1     3         2           27 -61.8009 17.35815   -61.8009
#> Variables not shown: LatitudeI (dbl), LengthI (dbl), AreaI (dbl), BearingI
#>   (dbl), SelectionMaskI (int), SelectionI (int), VersionI (int)

## group_by
accesstable %>% group_by(BranchesI)
#> Source: Access  [@ACCESS:/ACCESS]
#> From: Countries Table [3,063 x 14]
#> Grouped by: BranchesI 
#> 
#>       ID TypeI BranchesI CoordinatesI         XI        YI LongitudeI
#>    (int) (int)     (int)        (int)      (dbl)     (dbl)      (dbl)
#> 1      1     3         2           27  -61.80090  17.35815  -61.80090
#> 2      2     3        15          338   29.89647  26.77583   29.89647
#> 3      3     3        14         1142  -64.80505 -38.93744  -64.80505
#> 4      4     3         1            3  -65.71804  68.00735  -65.71804
#> 5      5     3         1            3  -95.79415  77.15010  -95.79415
#> 6      6     3         1            3 -130.40064  54.65008 -130.40064
#> 7      7     3         1            3  -74.38840  68.49880  -74.38840
#> 8      8     3         1            3  -85.27985  69.09420  -85.27985
#> 9      9     3         1            3  -99.01495  68.36710  -99.01495
#> 10    10     3         1            3  -96.11020  67.66398  -96.11020
#> ..   ...   ...       ...          ...        ...       ...        ...
#> Variables not shown: LatitudeI (dbl), LengthI (dbl), AreaI (dbl), BearingI
#>   (dbl), SelectionMaskI (int), SelectionI (int), VersionI (int)

## mutate
accesstable  %>% mutate(a = 1)
#> Source: Access  [@ACCESS:/ACCESS]
#> From: Countries Table [3,063 x 15]
#> 
#>       ID TypeI BranchesI CoordinatesI         XI        YI LongitudeI
#>    (int) (int)     (int)        (int)      (dbl)     (dbl)      (dbl)
#> 1      1     3         2           27  -61.80090  17.35815  -61.80090
#> 2      2     3        15          338   29.89647  26.77583   29.89647
#> 3      3     3        14         1142  -64.80505 -38.93744  -64.80505
#> 4      4     3         1            3  -65.71804  68.00735  -65.71804
#> 5      5     3         1            3  -95.79415  77.15010  -95.79415
#> 6      6     3         1            3 -130.40064  54.65008 -130.40064
#> 7      7     3         1            3  -74.38840  68.49880  -74.38840
#> 8      8     3         1            3  -85.27985  69.09420  -85.27985
#> 9      9     3         1            3  -99.01495  68.36710  -99.01495
#> 10    10     3         1            3  -96.11020  67.66398  -96.11020
#> ..   ...   ...       ...          ...        ...       ...        ...
#> Variables not shown: LatitudeI (dbl), LengthI (dbl), AreaI (dbl), BearingI
#>   (dbl), SelectionMaskI (int), SelectionI (int), VersionI (int), a (int)

## arrange, but prints too many rows?
accesstable  %>% arrange(BranchesI) %>% filter(coordinatesI > 1434)
#> Source: Access  [@ACCESS:/ACCESS]
#> From: Countries Table [21 x 14]
#> Filter: coordinatesI > 1434 
#> Arrange: BranchesI 
#> 
#>       ID TypeI BranchesI CoordinatesI         XI        YI LongitudeI
#>    (int) (int)     (int)        (int)      (dbl)     (dbl)      (dbl)
#> 1   2356     3         1         2254 -100.93310  68.50710 -100.93310
#> 2   1129     3         1         1842  -69.16480  53.89615  -69.16480
#> 3   1419     3         3         3621  -75.68165  69.27665  -75.68165
#> 4   2041     3         3         3621  -75.68165  69.27665  -75.68165
#> 5   2355     3         3         1556 -119.22110  64.44925 -119.22110
#> 6   2938     3        26         1544   66.90160  48.83260   66.90160
#> 7   2935     3        65         1807   83.89465  20.71220   83.89465
#> 8   2413     3        71         2403  -54.84035 -12.87012  -54.84035
#> 9   2465     3        72         1487   18.23470  61.67055   18.23470
#> 10  3027     3        72         1754   -6.76400  11.75785   -6.76400
#> ..   ...   ...       ...          ...        ...       ...        ...
#> Variables not shown: LatitudeI (dbl), LengthI (dbl), AreaI (dbl), BearingI
#>   (dbl), SelectionMaskI (int), SelectionI (int), VersionI (int)

## summarize doesn't work 
# accesstable %>% group_by(BranchesI) %>% summarize(x = n())
# Source: Access  [@ACCESS:/ACCESS]
# From: <derived table> [?? x 2]
# 
# Error in .valueClassTest(ans, "data.frame", "fetch") : 
#   invalid value from generic function ‘fetch’, class “character”, expected “data.frame”
# In addition: Warning message:
# closing unused RODBC handle 4 
# 
```

And Manifold.

``` r
## not clear how to do this yet
## we need cases for odbcConnectWhatever
setMethod(
  "dbConnect", 
  "ODBCDriver", 
  function(drv, dsn, user = NULL, password = NULL, ..., manifold = FALSE){
    uid <- if(is.null(user)) "" else user
    pwd <- if(is.null(password)) "" else password
    if (manifold) {
     connection <- odbcConnectManifold(dsn) 
    } else {
      connection <- odbcConnect(dsn, uid, pwd, ...)
    }
    new("ODBCConnection", odbc=connection)
  }
)
#> [1] "dbConnect"


src_manifold <- function(dbname = NULL, host = NULL, port = NULL, user = NULL,
                         password = NULL, ...) {

  con <-    dbConnect(RODBCDBI::ODBC(), dbname, manifold = TRUE)

  src_sql("manifold", con)
}


mapfile <- "C:\\data\\Countries.map"
manifold <- src_manifold(mapfile)
## woah, not cool
# ct <- tbl(manifold, "Countries Table")
#  Show Traceback
#  
#  Rerun with Debug
#  Error in odbcQuery(channel, query, rows_at_time) : 
#   'Calloc' could not allocate memory (2147483648 of 1 bytes) 

## Try with innocuous table
 ct <- tbl(manifold, "Table")

 ## collect, summarize, etc. don't work yet
# a <- collect(ct %>% group_by(`Branches (I)`) %>% select(`Longitude (I)`, `Latitude (I)` ))
# Error in .valueClassTest(ans, "data.frame", "fetch") : 
#   invalid value from generic function ‘fetch’, class “character”, expected “data.frame”
# 
```
