
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rcohort

<!-- badges: start -->
<!-- badges: end -->

The goal of `rcohort` is to perform cohort analysis with R. This package
build on top of `data.table` hence it should bring good speed!

## Installation

You can install the development version of `rcohort` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("vohai611/rcohort")
```

## Example

This is a basic example which shows you how to execute cohort analysis
with `rcohort`

``` r
df = readRDS("example-data/online-retail.rds")
```

This is a typical dataset of online retailer
([Source](https://www.kaggle.com/code/mahmoudelfahl/cohort-analysis-customer-segmentation-with-rfm/data))

``` r
head(df)
```

    #>   InvoiceNo StockCode                         Description Quantity
    #> 1    536365    85123A  WHITE HANGING HEART T-LIGHT HOLDER        6
    #> 2    536365     71053                 WHITE METAL LANTERN        6
    #> 3    536365    84406B      CREAM CUPID HEARTS COAT HANGER        8
    #> 4    536365    84029G KNITTED UNION FLAG HOT WATER BOTTLE        6
    #> 5    536365    84029E      RED WOOLLY HOTTIE WHITE HEART.        6
    #> 6    536365     22752        SET 7 BABUSHKA NESTING BOXES        2
    #>           InvoiceDate UnitPrice CustomerID        Country
    #> 1 2010-12-01 08:26:00      2.55      17850 United Kingdom
    #> 2 2010-12-01 08:26:00      3.39      17850 United Kingdom
    #> 3 2010-12-01 08:26:00      2.75      17850 United Kingdom
    #> 4 2010-12-01 08:26:00      3.39      17850 United Kingdom
    #> 5 2010-12-01 08:26:00      3.39      17850 United Kingdom
    #> 6 2010-12-01 08:26:00      7.65      17850 United Kingdom

`cohort_count()` perform cohort analysis by counting the appearance of
customer in each time period. In particular, Customer are grouped by the
first time they appear in the dataset. We can choose the rounded time to
every “month”, “week”, “quarter” or “year”.

``` r
library(rcohort)

df |>
  cohort_count(.id_col = CustomerID,
               .time_col = InvoiceDate,
               time_unit = "month")
```

    #>      cohort month_1  month_2  month_3  month_4  month_5  month_6   month_7
    #>      <fctr>   <num>    <num>    <num>    <num>    <num>    <num>     <num>
    #>  1: 2010-12     100 36.61017 32.31638 38.41808 36.27119 39.77401 36.271186
    #>  2:  2011-1     100 22.06235 26.61871 23.02158 32.13429 28.77698 24.700240
    #>  3:  2011-2     100 18.68421 18.68421 28.42105 27.10526 24.73684 25.263158
    #>  4:  2011-3     100 15.04425 25.22124 19.91150 22.34513 16.81416 26.769912
    #>  5:  2011-4     100 21.33333 20.33333 21.00000 19.66667 22.66667 21.666667
    #>  6:  2011-5     100 19.01408 17.25352 17.25352 20.77465 23.23944 26.408451
    #>  7:  2011-6     100 17.35537 15.70248 26.44628 23.14050 33.47107  9.504132
    #>  8:  2011-7     100 18.08511 20.74468 22.34043 27.12766 11.17021        NA
    #>  9:  2011-8     100 20.71006 24.85207 24.26036 12.42604       NA        NA
    #> 10:  2011-9     100 23.41137 30.10033 11.37124       NA       NA        NA
    #> 11: 2011-10     100 24.02235 11.45251       NA       NA       NA        NA
    #> 12: 2011-11     100 11.14551       NA       NA       NA       NA        NA
    #> 13: 2011-12     100       NA       NA       NA       NA       NA        NA
    #>       month_8   month_9  month_10  month_11 month_12 month_13
    #>         <num>     <num>     <num>     <num>    <num>    <num>
    #>  1: 34.915254 35.367232 39.548023 37.401130 50.28249 26.55367
    #>  2: 24.220624 29.976019 32.613909 36.450839 11.75060       NA
    #>  3: 27.894737 24.736842 30.526316  6.842105       NA       NA
    #>  4: 23.008850 27.876106  8.628319        NA       NA       NA
    #>  5: 26.000000  7.333333        NA        NA       NA       NA
    #>  6:  9.507042        NA        NA        NA       NA       NA
    #>  7:        NA        NA        NA        NA       NA       NA
    #>  8:        NA        NA        NA        NA       NA       NA
    #>  9:        NA        NA        NA        NA       NA       NA
    #> 10:        NA        NA        NA        NA       NA       NA
    #> 11:        NA        NA        NA        NA       NA       NA
    #> 12:        NA        NA        NA        NA       NA       NA
    #> 13:        NA        NA        NA        NA       NA       NA

To include group of all customer, use `all_group = TRUE`

``` r
df |>
  cohort_count(.id_col = CustomerID,
               .time_col = InvoiceDate,
               time_unit = "month",
               all_group = TRUE)
```

    #>      cohort month_1  month_2  month_3  month_4  month_5  month_6   month_7
    #>      <fctr>   <num>    <num>    <num>    <num>    <num>    <num>     <num>
    #>  1:     All     100 22.49885 21.71508 21.36929 20.86215 20.23974 18.533887
    #>  2: 2010-12     100 36.61017 32.31638 38.41808 36.27119 39.77401 36.271186
    #>  3:  2011-1     100 22.06235 26.61871 23.02158 32.13429 28.77698 24.700240
    #>  4:  2011-2     100 18.68421 18.68421 28.42105 27.10526 24.73684 25.263158
    #>  5:  2011-3     100 15.04425 25.22124 19.91150 22.34513 16.81416 26.769912
    #>  6:  2011-4     100 21.33333 20.33333 21.00000 19.66667 22.66667 21.666667
    #>  7:  2011-5     100 19.01408 17.25352 17.25352 20.77465 23.23944 26.408451
    #>  8:  2011-6     100 17.35537 15.70248 26.44628 23.14050 33.47107  9.504132
    #>  9:  2011-7     100 18.08511 20.74468 22.34043 27.12766 11.17021        NA
    #> 10:  2011-8     100 20.71006 24.85207 24.26036 12.42604       NA        NA
    #> 11:  2011-9     100 23.41137 30.10033 11.37124       NA       NA        NA
    #> 12: 2011-10     100 24.02235 11.45251       NA       NA       NA        NA
    #> 13: 2011-11     100 11.14551       NA       NA       NA       NA        NA
    #> 14: 2011-12     100       NA       NA       NA       NA       NA        NA
    #>       month_8   month_9  month_10  month_11 month_12  month_13
    #>         <num>     <num>     <num>     <num>    <num>     <num>
    #>  1: 16.712771 15.675426 14.776395 11.733518 11.38774  5.417243
    #>  2: 34.915254 35.367232 39.548023 37.401130 50.28249 26.553672
    #>  3: 24.220624 29.976019 32.613909 36.450839 11.75060        NA
    #>  4: 27.894737 24.736842 30.526316  6.842105       NA        NA
    #>  5: 23.008850 27.876106  8.628319        NA       NA        NA
    #>  6: 26.000000  7.333333        NA        NA       NA        NA
    #>  7:  9.507042        NA        NA        NA       NA        NA
    #>  8:        NA        NA        NA        NA       NA        NA
    #>  9:        NA        NA        NA        NA       NA        NA
    #> 10:        NA        NA        NA        NA       NA        NA
    #> 11:        NA        NA        NA        NA       NA        NA
    #> 12:        NA        NA        NA        NA       NA        NA
    #> 13:        NA        NA        NA        NA       NA        NA
    #> 14:        NA        NA        NA        NA       NA        NA

Beside counting the appearance of customers, you can summarise cohort
performance over time. For example, we can observe the change of the
revenue over time.

``` r
df$Revenue = df$Quantity * df$UnitPrice

cohort_df = df |> 
  cohort_summarise(.id_col = CustomerID,
                   .time_col = InvoiceDate,
                  .summarise_col = Revenue,.fn = "sum", time_unit = "month",
                  percent_form = TRUE) 
cohort_df
```

    #>      cohort month_1  month_2   month_3   month_4  month_5   month_6   month_7
    #>      <fctr>   <num>    <num>     <num>     <num>    <num>     <num>     <num>
    #>  1: 2010-12     100 48.23310 40.831098 52.926845 35.69106 58.777604 54.855071
    #>  2:  2011-1     100 18.80918 21.577962 24.415282 27.66441 28.847769 23.910519
    #>  3:  2011-2     100 18.36528 26.011029 30.503496 25.38724 21.640813 31.431630
    #>  4:  2011-3     100 15.02446 29.518429 21.400819 25.81963 20.003408 32.448395
    #>  5:  2011-4     100 24.13938 20.553040 19.925558 21.56698 24.756930 23.496951
    #>  6:  2011-5     100 15.05414 16.271672 15.440440 22.45046 26.571793 26.842784
    #>  7:  2011-6     100 10.90675 10.428092 22.808986 19.70971 31.536260  6.060978
    #>  8:  2011-7     100 15.93010 20.989653 23.715398 26.36460  8.204651        NA
    #>  9:  2011-8     100 26.28380 44.515592 55.847465 19.16388        NA        NA
    #> 10:  2011-9     100 18.60238 23.876879  7.933991       NA        NA        NA
    #> 11: 2011-10     100 22.90881  7.223542        NA       NA        NA        NA
    #> 12: 2011-11     100 11.18996        NA        NA       NA        NA        NA
    #> 13: 2011-12     100       NA        NA        NA       NA        NA        NA
    #>       month_8  month_9 month_10  month_11  month_12 month_13
    #>         <num>    <num>    <num>     <num>     <num>    <num>
    #>  1:  54.26513 57.92582 82.55669 79.634983 89.713834 32.44257
    #>  2:  24.79123 24.56407 38.13134 42.250680  9.025974       NA
    #>  3:  39.49033 35.01918 40.98179  6.702973        NA       NA
    #>  4:  35.49956 35.62045  6.43176        NA        NA       NA
    #>  5:  28.05360  5.20451       NA        NA        NA       NA
    #>  6: 144.43680       NA       NA        NA        NA       NA
    #>  7:        NA       NA       NA        NA        NA       NA
    #>  8:        NA       NA       NA        NA        NA       NA
    #>  9:        NA       NA       NA        NA        NA       NA
    #> 10:        NA       NA       NA        NA        NA       NA
    #> 11:        NA       NA       NA        NA        NA       NA
    #> 12:        NA       NA       NA        NA        NA       NA
    #> 13:        NA       NA       NA        NA        NA       NA

We can also quick visualize cohort data by calling `auto_plot`

``` r
cohort_df |> auto_plot("tile")
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />
