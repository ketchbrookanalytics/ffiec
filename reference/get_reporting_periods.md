# Retrieve Reporting Periods

Retrieves Call Report or UBPR filer information from the FFIEC Central
Data Repository API for available reporting periods.

## Usage

``` r
get_reporting_periods(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  as_data_frame = FALSE
)

get_ubpr_reporting_periods(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  as_data_frame = FALSE
)
```

## Arguments

- user_id:

  (String) The UserID for authenticating against the FFIEC API

- bearer_token:

  (String) The Bearer Token for authenticating against the FFIEC API

- as_data_frame:

  (Logical) Should the result be returned as a tibble? Default is
  `FALSE`.

## Value

A list containing the parsed JSON response from the API, where each
element in the list represents an available reporting period. If
`as_data_frame = TRUE`, then the list is converted to a tibble (and
returned as such).

## References

<https://cdr.ffiec.gov/public/Files/SIS611_-_Retrieve_Public_Data_via_Web_Service.pdf>

## Examples

``` r
if (!no_creds_available()) {
  # Assume you have set the following environment variables:
  # - FFIEC_USER_ID
  # - FFIEC_BEARER_TOKEN

  # Retrieve reporting periods and return as a list
  get_reporting_periods()

  # Retrieve UBPR reporting periods and return as a tibble
  get_ubpr_reporting_periods(as_data_frame = TRUE)
}
```
