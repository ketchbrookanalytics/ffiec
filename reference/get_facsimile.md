# Retrieve Facsimile

Retrieves Call Report or UBPR facsimile data from the FFIEC Central Data
Repository API for the requested financial institution.

## Usage

``` r
get_facsimile(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  reporting_period_end_date,
  fi_id_type = c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber"),
  fi_id
)

get_ubpr_facsimile(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  reporting_period_end_date,
  fi_id_type = c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber"),
  fi_id
)
```

## Arguments

- user_id:

  (String) The UserID for authenticating against the FFIEC API

- bearer_token:

  (String) The Bearer Token for authenticating against the FFIEC API

- reporting_period_end_date:

  (String, character vector, Date, or Date vector) One or more reporting
  period end dates. Character values must be formatted as "MM/DD/YYYY".
  Date objects are also accepted and will be coerced to the required
  format automatically.

- fi_id_type:

  (String) The type of identifier being provided; one of
  `c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber")`;
  default is "ID_RSSD"

- fi_id:

  (String or character vector) One or more financial institution
  identifiers (can also be supplied as an integer vector)

## Value

A tibble containing the facsimile data.

## References

<https://cdr.ffiec.gov/public/Files/SIS611_-_Retrieve_Public_Data_via_Web_Service.pdf>

## Examples

``` r
if (!no_creds_available()) {
  # Assume you have set the following environment variables:
  # - FFIEC_USER_ID
  # - FFIEC_BEARER_TOKEN

  # Retrieve facsimile data for reporting period 2025-03-31 for institution
  # with ID RSSD "480228"
  get_facsimile(
    reporting_period_end_date = "03/31/2025",
    fi_id = 480228
  )

  # Retrieve UBPR facsimile data for reporting period 2025-03-31 for
  # institution with FDIC Cert Number "3510"
  get_ubpr_facsimile(
    reporting_period_end_date = "03/31/2025",
    fi_id_type = "FDICCertNumber",
    fi_id = "3510"
  )

  # Retrieve facsimile data for reporting periods 2025-03-31 and 2025-06-30
  # for institutions with ID RSSD of "480228" and "451965"
  get_facsimile(
    reporting_period_end_date = c("03/31/2025", "06/30/2025"),
    fi_id = c("480228", "451965")
  )

  # Retrieve UBPR data for reporting periods 2025-03-31 and 2025-06-30
  # for institution with ID RSSD of "480228"
  get_ubpr_facsimile(
    reporting_period_end_date = c("03/31/2025", "06/30/2025"),
    fi_id = 480228
  )
}
#> # A tibble: 8,669 × 6
#>    ID_RSSD Quarter    Metric   Unit  Decimals Value       
#>    <chr>   <date>     <chr>    <chr> <chr>    <chr>       
#>  1 480228  2025-03-31 UBPR4341 USD   0        1365000000  
#>  2 480228  2025-03-31 UBPR4635 USD   0        1733000000  
#>  3 480228  2025-03-31 UBPR4665 USD   0        2000000     
#>  4 480228  2025-03-31 UBPR5310 USD   0        14397000000 
#>  5 480228  2025-03-31 UBPR5311 USD   0        5585000000  
#>  6 480228  2025-03-31 UBPR5320 USD   0        723514000000
#>  7 480228  2025-03-31 UBPR5340 USD   0        808943000000
#>  8 480228  2025-03-31 UBPR5369 USD   0        6778000000  
#>  9 480228  2025-03-31 UBPR5380 USD   0        1000000     
#> 10 480228  2025-03-31 UBPR5381 USD   0        0000        
#> # ℹ 8,659 more rows
```
