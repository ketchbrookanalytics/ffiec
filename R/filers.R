#' Retrieve Filers Since Date
#'
#' @description Retrieves filer information from the FFIEC Central Data
#' Repository API for filers updated since a specified date.
#'
#' @inheritParams no_creds_available
#' @param reporting_period_end_date (String or Date) The reporting period end
#'   date. Character values must be formatted as "MM/DD/YYYY". Date objects are
#'   also accepted and will be coerced to the required format automatically.
#' @param last_update_date_time (String) Filter for records updated
#'   since this date/time. See `Details` for formatting options.
#' @param as_data_frame (Logical) Should the result be returned as a tibble?
#'   Default is `FALSE`.
#'
#' @details
#' Set the `last_update_date_time` value to the last time you ran the
#' method to retrieve only those institutions that have filed a newer report.
#' Possible formatting options include:
#'
#' - "04/15/2025"
#' - "2025-04-15 21:00:00.000"
#' - "04/15/2025 9:00 PM"
#'
#' @return A list containing the parsed JSON response from the API, where each
#'   element in the list represents an RSSD ID value.  If
#'   `as_data_frame = TRUE`, then the list is converted to a tibble (and
#'   returned as such).
#'
#' @references
#' <https://cdr.ffiec.gov/public/Files/SIS611_-_Retrieve_Public_Data_via_Web_Service.pdf>
#'
#' @export
#'
#' @examples
#' if (!no_creds_available()) {
#'   # Assume you have set the following environment variables:
#'   # - FFIEC_USER_ID
#'   # - FFIEC_BEARER_TOKEN
#'
#'   # Retrieve filers since 2025-03-31, as of 2025-04-15 and return as a list
#'   get_filers_since_date(
#'     reporting_period_end_date = "03/31/2025",
#'     last_update_date_time = "04/15/2025"
#'   )
#'
#'   # Retrieve filers since 2025-03-31, as of 2025-04-15 21:00:00.000 and return
#'   # as a tibble
#'   get_filers_since_date(
#'     reporting_period_end_date = "03/31/2025",
#'     last_update_date_time = "04/15/2025 21:00:00.000",
#'     as_data_frame = TRUE
#'   )
#' }
get_filers_since_date <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                                  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                                  reporting_period_end_date,
                                  last_update_date_time,
                                  as_data_frame = FALSE) {

  check_empty_creds(
    user_id = user_id,
    bearer_token = bearer_token
  )

  reporting_period_end_date <- check_report_dates(reporting_period_end_date)

  endpoint <- "RetrieveFilersSinceDate"

  # Build the request(s) following the API specification
  req <- get_ffiec(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token,
    reporting_period_end_date = reporting_period_end_date,
    last_update_date_time = last_update_date_time,
    data_series = "Call"
  )

  # Perform the request and collect the JSON response into an R list object
  resp <- collect_response(req)

  # Convert to a tibble (if desired)
  if (as_data_frame) {
    resp <- tibble::tibble(
      ID_RSSD = unlist(resp)
    )
  }

  return(resp)

}