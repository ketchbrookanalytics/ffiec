# General Workflow

## Using {ffiec}

This package attempts to offer a convenient interface to interact with
the Central Data Repository ‘REST API’ service made available by the
United States Federal Financial Institutions Examination Council
(‘FFIEC’).

## Getting Started

If you haven’t done so already, install {ffiec} and create an account
through the FFIEC’s Web Service portal using the instructions in the
[README
section](https://ketchbrookanalytics.github.io/ffiec/#installation).

With your username and password from the FFIEC’s Web Service portal
in-hand (either stored as environment variables or ready to be passed as
function arguments), load the package using
[`library()`](https://rdrr.io/r/base/library.html).

``` r
library(ffiec)
```

While the package offers several functions to enable different workflows
and analyses, one general workflow is as follows:

- Collect a list of available Call reporting periods
- For each desired Call reporting period and desired Institution ID,
  retrieve Call report data

First, to obtain the available Call reporting periods, use the
[`get_reporting_periods()`](https://ketchbrookanalytics.github.io/ffiec/reference/get_reporting_periods.md)
function. The `as_data_frame` argument is set to `TRUE` to alter the
return behavior of the function. By default, the function will return a
list object.

``` r
reporting_periods <- get_reporting_periods(as_data_frame = TRUE)
```

Next, filter the
[`get_reporting_periods()`](https://ketchbrookanalytics.github.io/ffiec/reference/get_reporting_periods.md)
return value to the period(s) of interest. For the purposes of this
example, the four reporting periods in calendar year 2025 will be used.

``` r
reports_2025 <- reporting_periods |>
  dplyr::filter(
    ReportingPeriod <= as.Date("2025-12-31"),
    ReportingPeriod >= as.Date("2025-01-01")
  ) |>
  dplyr::pull()
```

Using the
[`get_facsimile()`](https://ketchbrookanalytics.github.io/ffiec/reference/get_facsimile.md)
function, Call report data can be collected for the selected reporting
periods and one or more specified institutions.

``` r
call_df <- get_facsimile(
  reporting_period_end_date = reports_2025,
  fi_id = c(480228, 451965)
)
#> ℹ Converting <Date> values to "MM/DD/YYYY" character strings:
#> • 2025-12-31 → 12/31/2025
#> • 2025-09-30 → 09/30/2025
#> • 2025-06-30 → 06/30/2025
#> • 2025-03-31 → 03/31/2025
```

Notice that each institution ID (column `BankRSSDIdentifier`) contains
Call report data for each reporting period.

``` r
call_df |>
  dplyr::count(CallDate, BankRSSDIdentifier)
#> # A tibble: 8 × 3
#>   CallDate   BankRSSDIdentifier     n
#>   <date>                  <int> <int>
#> 1 2025-03-31             451965  2116
#> 2 2025-03-31             480228  2159
#> 3 2025-06-30             451965  2135
#> 4 2025-06-30             480228  2174
#> 5 2025-09-30             451965  2114
#> 6 2025-09-30             480228  2156
#> 7 2025-12-31             451965  2223
#> 8 2025-12-31             480228  2264
```

This example can be extended by comparing Call report values, either
between periods or between institutions (or both). Below, the Call
report data is filtered to display Tier 1 capital for each institution
over the selected reporting periods.

``` r
call_df |>
  dplyr::filter(MDRM == "RCFA8274") |>  # Tier 1 capital
  dplyr::mutate(Value = as.numeric(Value))
#> # A tibble: 8 × 8
#>   CallDate   BankRSSDIdentifier MDRM         Value LastUpdate ShortDefinition
#>   <date>                  <int> <chr>        <dbl> <date>     <chr>          
#> 1 2025-12-31             480228 RCFA8274 190831000 2026-03-02 Tier 1 capital 
#> 2 2025-09-30             480228 RCFA8274 196596000 2025-11-04 Tier 1 capital 
#> 3 2025-06-30             480228 RCFA8274 196227000 2025-08-28 Tier 1 capital 
#> 4 2025-03-31             480228 RCFA8274 193808000 2025-08-28 Tier 1 capital 
#> 5 2025-12-31             451965 RCFA8274 151833000 2026-02-04 Tier 1 capital 
#> 6 2025-09-30             451965 RCFA8274 150610000 2025-11-04 Tier 1 capital 
#> 7 2025-06-30             451965 RCFA8274 149749000 2025-08-04 Tier 1 capital 
#> 8 2025-03-31             451965 RCFA8274 147334000 2025-05-05 Tier 1 capital 
#> # ℹ 2 more variables: CallSchedule <chr>, LineNumber <chr>
```

## Additional Uses

The package offers functions to interact with both Call report data and
Uniform Bank Performance Report (UBPR) data.

To interact with the latter, simply substitute
[`get_ubpr_reporting_periods()`](https://ketchbrookanalytics.github.io/ffiec/reference/get_reporting_periods.md)
and
[`get_ubpr_facsimile()`](https://ketchbrookanalytics.github.io/ffiec/reference/get_facsimile.md)
into the above examples. However, please be aware that
[`get_ubpr_facsimile()`](https://ketchbrookanalytics.github.io/ffiec/reference/get_facsimile.md)
returns different column names than
[`get_facsimile()`](https://ketchbrookanalytics.github.io/ffiec/reference/get_facsimile.md).
