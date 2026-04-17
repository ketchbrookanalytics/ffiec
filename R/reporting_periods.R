#' Retrieve Reporting Periods
#'
#' @description Retrieves Call Report or UBPR filer information from the FFIEC
#' Central Data Repository API for available reporting periods.
#'
#' @inheritParams no_creds_available
#' @param as_data_frame (Logical) Should the result be returned as a tibble?
#'   Default is `FALSE`.
#'
#' @return A list containing the parsed JSON response from the API, where each
#'   element in the list represents an available reporting period. If
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
#'   # Retrieve reporting periods and return as a list
#'   get_reporting_periods()
#'
#'   # Retrieve UBPR reporting periods and return as a tibble
#'   get_ubpr_reporting_periods(as_data_frame = TRUE)
#' }
get_reporting_periods <- function(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  as_data_frame = FALSE
) {
  check_empty_creds(
    user_id = user_id,
    bearer_token = bearer_token
  )

  endpoint <- "RetrieveReportingPeriods"

  # Build the request(s) following the API specification
  req <- get_ffiec(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token,
    data_series = "Call"
  )

  # Perform the request and collect the JSON response into an R list object
  resp <- collect_response(req)

  # Convert to a tibble (if desired)
  if (as_data_frame) {
    resp <- tibble::tibble(
      ReportingPeriod = unlist(resp) |> as.Date(format = "%m/%d/%Y")
    )
  }

  return(resp)
}


#' @rdname get_reporting_periods
#' @export
get_ubpr_reporting_periods <- function(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  as_data_frame = FALSE
) {
  check_empty_creds(
    user_id = user_id,
    bearer_token = bearer_token
  )

  endpoint <- "RetrieveUBPRReportingPeriods"

  # Build the request(s) following the API specification
  req <- get_ffiec(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token
  )

  # Perform the request and collect the JSON response into an R list object
  resp <- collect_response(req)

  # Convert to a tibble (if desired)
  if (as_data_frame) {
    resp <- tibble::tibble(
      ReportingPeriod = unlist(resp) |> as.Date(format = "%m/%d/%Y")
    )
  }

  return(resp)
}
