#' Retrieve Panel of Reporters
#'
#' @description Retrieves filer information from the FFIEC Central Data
#' Repository API for the financial institutions in the Panel of Reporters (POR)
#' expected to file for a given Call reporting period.
#'
#' @inheritParams no_creds_available
#' @param reporting_period_end_date (String or Date) The reporting period end
#'   date. Character values must be formatted as "MM/DD/YYYY". Date objects are
#'   also accepted and will be coerced to the required format automatically.
#' @param as_data_frame (Logical) Should the result be returned as a tibble?
#'   Default is `TRUE`.
#'
#' @return A tibble containing the parsed JSON response from the API of filer
#'   information since the given `reporting_period_end_date` date value. If
#'   `as_data_frame = FALSE`, then the result is returned as a nested list
#'   object, where each element represents a unique `ID_RSSD` value.
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
#'   # Retrieve expected filers for reporting period 2025-03-31 and return as a
#'   # tibble
#'   get_panel_of_reporters(
#'     reporting_period_end_date = "03/31/2025"
#'   )
#'
#'   # Retrieve expected filers for reporting period 2025-03-31 and return as a
#'   # list
#'   get_panel_of_reporters(
#'     reporting_period_end_date = "03/31/2025",
#'     as_data_frame = FALSE
#'   )
#' }
get_panel_of_reporters <- function(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  reporting_period_end_date,
  as_data_frame = TRUE
) {
  check_empty_creds(
    user_id = user_id,
    bearer_token = bearer_token
  )

  reporting_period_end_date <- check_report_dates(reporting_period_end_date)

  endpoint <- "RetrievePanelOfReporters"

  # Build the request(s) following the API specification
  req <- get_ffiec(
    endpoint = endpoint,
    user_id = user_id,
    bearer_token = bearer_token,
    reporting_period_end_date = reporting_period_end_date,
    data_series = "Call"
  )

  # Perform the request and collect the JSON response into an R list object
  resp <- collect_response(req)

  # Convert to a tibble (if desired)
  if (as_data_frame) {
    resp <- resp |>
      purrr::map(.f = tibble::as_tibble) |>
      purrr::list_rbind() |>
      # clean up leading/trailing whitespace
      dplyr::mutate(
        dplyr::across(
          .cols = dplyr::where(is.character),
          .fns = trimws
        )
      )
  }

  return(resp)
}
