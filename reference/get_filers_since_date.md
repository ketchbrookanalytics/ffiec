# Retrieve Filers Since Date

Retrieves filer information from the FFIEC Central Data Repository API
for filers updated since a specified date.

## Usage

``` r
get_filers_since_date(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  reporting_period_end_date,
  last_update_date_time,
  as_data_frame = FALSE
)
```

## Arguments

- user_id:

  (String) The UserID for authenticating against the FFIEC API

- bearer_token:

  (String) The Bearer Token for authenticating against the FFIEC API

- reporting_period_end_date:

  (String or Date) The reporting period end date. Character values must
  be formatted as "MM/DD/YYYY". Date objects are also accepted and will
  be coerced to the required format automatically.

- last_update_date_time:

  (String) Filter for records updated since this date/time. See
  `Details` for formatting options.

- as_data_frame:

  (Logical) Should the result be returned as a tibble? Default is
  `FALSE`.

## Value

A list containing the parsed JSON response from the API, where each
element in the list represents an RSSD ID value. If
`as_data_frame = TRUE`, then the list is converted to a tibble (and
returned as such).

## Details

Set the `last_update_date_time` value to the last time you ran the
method to retrieve only those institutions that have filed a newer
report. Possible formatting options include:

- "04/15/2025"

- "2025-04-15 21:00:00.000"

- "04/15/2025 9:00 PM"

## References

<https://cdr.ffiec.gov/public/Files/SIS611_-_Retrieve_Public_Data_via_Web_Service.pdf>

## Examples

``` r
if (!no_creds_available()) {
  # Assume you have set the following environment variables:
  # - FFIEC_USER_ID
  # - FFIEC_BEARER_TOKEN

  # Retrieve filers since 2025-03-31, as of 2025-04-15 and return as a list
  get_filers_since_date(
    reporting_period_end_date = "03/31/2025",
    last_update_date_time = "04/15/2025"
  )

  # Retrieve filers since 2025-03-31, as of 2025-04-15 21:00:00.000 and return
  # as a tibble
  get_filers_since_date(
    reporting_period_end_date = "03/31/2025",
    last_update_date_time = "04/15/2025 21:00:00.000",
    as_data_frame = TRUE
  )
}
```
