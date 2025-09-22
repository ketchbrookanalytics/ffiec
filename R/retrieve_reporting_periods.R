#' Base function for calling `retrieve_reporting_periods()` and
#' `retrieve_ubpr_reporting_periods`
#' @noRd
get_reporting_periods_base <- function(endpoint,
                                       user_id,
                                       bearer_token,
                                       as_data_frame = FALSE) {

  base_url <- "https://ffieccdr.azure-api.us/public/"
  url <- paste0(base_url, endpoint)
  data_series <- "Call"

  # Build the request following the API specification
  req <- httr2::request(url) |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      "Content-Type" = "application/json",
      "UserID" = user_id,
      "Authentication" = paste0("Bearer ", bearer_token),
      "dataSeries" = data_series
    )

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
#' @description Retrieves filer information from the FFIEC Central Data
#' Repository API for available reporating periods.
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API.
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API.
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
#' \dontrun{
#'
#' # Assume you have set the following environment variables:
#' # - FFIEC_USER_ID
#' # - FFIEC_BEARER_TOKEN
#'
#' # Retrieve reporting periods and return as a list
#' retrieve_reporting_periods()
#'
#' # Retrieve reporting periods and return as a tibble
#' retrieve_reporting_periods(as_data_frame = TRUE)
#'
#' }
retrieve_reporting_periods <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                                       bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                                       as_data_frame = FALSE) {

  endpoint <- "RetrieveReportingPeriods"

  resp <- get_reporting_periods_base(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token,
    as_data_frame = as_data_frame
  )

  return(resp)

}



#' Retrieve UBPR Reporting Periods
#'
#' @description Retrieves information from the FFIEC Central Data Repository API
#'   with a list of all reporting period end dates available for the UBPR data
#'   series.
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API.
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API.
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
#' \dontrun{
#'
#' # Assume you have set the following environment variables:
#' # - FFIEC_USER_ID
#' # - FFIEC_BEARER_TOKEN
#'
#' # Retrieve UBPR reporting periods and return as a list
#' retrieve_ubpr_reporting_periods()
#'
#' # Retrieve UBPR reporting periods and return as a tibble
#' retrieve_ubpr_reporting_periods(as_data_frame = TRUE)
#'
#' }
retrieve_ubpr_reporting_periods <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                                            bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                                            as_data_frame = FALSE) {

  endpoint <- "RetrieveUBPRReportingPeriods"

  resp <- get_reporting_periods_base(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token,
    as_data_frame = as_data_frame
  )

  return(resp)

}