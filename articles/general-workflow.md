# General Workflow

    No FFIEC API credentials available. Code chunks will not be evaluated.

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
```

Notice that each institution ID (column `BankRSSDIdentifier`) contains
Call report data for each reporting period.

``` r
call_df |>
  dplyr::count(CallDate, BankRSSDIdentifier)
```

This example can be extended by comparing Call report values, either
between periods or between institutions (or both). Below, the Call
report data is filtered to display Tier 1 capital for each institution
over the selected reporting periods.

``` r
call_df |>
  dplyr::filter(MDRM == "RCFA8274") |>  # Tier 1 capital
  dplyr::mutate(Value = as.numeric(Value))
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
