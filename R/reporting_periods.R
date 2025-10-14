#' Base function for calling `retrieve_reporting_periods()` and
#' `retrieve_ubpr_reporting_periods`
#' @noRd
get_reporting_periods_base <- function(endpoint,
                                       user_id,
                                       bearer_token,
                                       as_data_frame = FALSE,
                                       ubpr = FALSE) {

  check_empty_creds(
    user_id = user_id,
    bearer_token = bearer_token
  )

  url <- paste0(base_url, endpoint)

  # Build the request following the API specification
  req <- httr2::request(url) |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      "Content-Type" = "application/json",
      "UserID" = user_id,
      "Authentication" = paste0("Bearer ", bearer_token)
    ) |>
    httr2::req_error(body = ffiec_error_message) |>
    httr2::req_user_agent(
      "ffiec R package (https://ketchbrookanalytics.github.io/ffiec/)"
    )

  # If using the non-UBPR endpoint, add an additional header
  if (!ubpr) {
    req <- req |>
      httr2::req_headers("dataSeries" = "Call")
  }

  # Perform the request and collect the JSON response into an R list object
  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # Convert to a tibble (if desired)
  if (as_data_frame) {
    resp <- tibble::tibble(
      ReportingPeriod = unlist(resp) |> as.Date(format = "%m/%d/%Y")
    )
  }

  return(resp)

}



#' Retrieve Reporting Periods
#'
#' @description Retrieves Call Report or UBPR filer information from the FFIEC
#' Central Data Repository API for available reporating periods.
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
get_reporting_periods <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                                  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                                  as_data_frame = FALSE) {

  endpoint <- "RetrieveReportingPeriods"
  ubpr <- FALSE

  resp <- get_reporting_periods_base(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token,
    as_data_frame = as_data_frame,
    ubpr = ubpr
  )

  return(resp)

}



#' @rdname get_reporting_periods
#' @export
get_ubpr_reporting_periods <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                                       bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                                       as_data_frame = FALSE) {

  endpoint <- "RetrieveUBPRReportingPeriods"
  ubpr <- TRUE

  resp <- get_reporting_periods_base(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token,
    as_data_frame = as_data_frame,
    ubpr = ubpr
  )

  return(resp)

}