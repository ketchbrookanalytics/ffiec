#' Define the base URL for all FFIEC API endpoints
#' @noRd
base_url <- "https://ffieccdr.azure-api.us/public/"

#' Create a small error handler to return error messages from API
#' @noRd
ffiec_error_message <- function(resp) {
  httr2::resp_body_json(resp)$Message
}