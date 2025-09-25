#' Retrieve Filers Submission Date Time
#'
#' @description Retrieves filer information from the FFIEC Central Data
#' Repository API for the ID RSSDs and submission date and time of the reporters
#' who have filed after the provided `last_update_date_time`` and whose new
#' filings are available for public distribution.
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API.
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API.
#' @param reporting_period_end_date (String) The reporting period end date,
#'   formatted as "MM/DD/YYYY".
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
#' - "04/15/2025 9:00 PM"
#'
#' @return A list containing the parsed JSON response from the API, where each
#'   element in the list represents an RSSD ID value.  If
#'   `as_data_frame = TRUE`, then the list is converted to a tibble (and
#'   returned as such).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Assume you have set the following environment variables:
#' # - FFIEC_USER_ID
#' # - FFIEC_BEARER_TOKEN
#'
#' # Retrieve filers since 2025-03-31, as of 2025-04-15 and return as a tibble
#' get_filers_submission_datetime(
#'   reporting_period_end_date = "03/31/2025",
#'   last_update_date_time = "04/15/2025"
#' )
#'
#' # Retrieve filers since 2025-03-31, as of 2025-04-15 21:00:00.000 and return
#' # as a list
#' get_filers_submission_datetime(
#'   reporting_period_end_date = "03/31/2025",
#'   last_update_date_time = "04/15/2025 21:00:00.000",
#'   as_data_frame = FALSE
#' )
#'
#' }
get_filers_submission_datetime <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                                           bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                                           reporting_period_end_date,
                                           last_update_date_time,
                                           as_data_frame = TRUE) {

  endpoint <- "RetrieveFilersSubmissionDateTime"
  url <- paste0(base_url, endpoint)
  data_series <- "Call"

  # Build the request following the API specification
  req <- httr2::request(url) |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      "Content-Type" = "application/json",
      "UserID" = user_id,
      "Authentication" = paste0("Bearer ", bearer_token),
      "dataSeries" = data_series,
      "reportingPeriodEndDate" = reporting_period_end_date,
      "lastUpdateDateTime" = last_update_date_time
    ) |>
    httr2::req_error(body = ffiec_error_message)

  # Perform the request and collect the JSON response into an R list object
  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # Convert to a tibble (if desired)
  if (as_data_frame) {
    resp <- resp |>
      purrr::map(
        .f = function(x) {
          tibble::tibble(
            ID_RSSD = x$ID_RSSD,
            DateTime = as.POSIXct(x$DateTime, format = "%m/%d/%Y %I:%M:%S %p")
          )
        }
      ) |>
      purrr::list_rbind()
  }

  return(resp)

}