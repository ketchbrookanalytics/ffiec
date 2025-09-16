#' Retrieve Filers Since Date
#'
#' Retrieves filer information from the FFIEC Central Data Repository API
#' for filers updated since a specified date.
#'
#' @param base_url Character string. The base URL for the FFIEC API
#' @param data_series Character string. The data series to retrieve (default: "Call")
#' @param reporting_period_end_date Character string. The reporting period end date (optional)
#' @param last_update_date_time Character string. Filter for records updated since this date/time (optional)
#'
#' @return A list containing the parsed JSON response from the API
#' @export
#'
#' @examples
#' \dontrun{
#' # First set authentication
#' set_ffiec_auth("your-bearer-token")
#'
#' # Retrieve filers data
#' result <- retrieve_filers_since_date(
#'   base_url = "https://api.ffiec.gov/cdr",
#'   data_series = "Call",
#'   last_update_date_time = "2024-01-01"
#' )
#' }
retrieve_filers_since_date <- function(base_url,
                                       user_id,
                                       bearer_token,
                                       data_series = "Call",
                                       reporting_period_end_date = "",
                                       last_update_date_time = "") {

  # Get authentication details
  # bearer_token <- get_ffiec_token()
  # user_id <- get_ffiec_user_id()

  # Build the request following the API specification
  request(base_url) |>
    req_method("GET") |>
    req_headers(
      "Content-Type" = "application/json",
      "UserID" = user_id,
      "Authentication" = paste0("Bearer ", bearer_token),
      "dataSeries" = data_series,
      "reportingPeriodEndDate" = reporting_period_end_date,
      "lastUpdateDateTime" = last_update_date_time
    ) |>
    httr2::req_error(is_error = function(resp) FALSE) |>  # Handle errors manually
    req_perform() |>
    resp_body_json()
}



retrieve_filers_since_date(
  base_url = "https://ffieccdr.azure-api.us/public/RetrieveFilersSinceDate",
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
  data_series = "Call",
  reporting_period_end_date = "06/30/2025",
  last_update_date_time = "08/15/2025"
)
