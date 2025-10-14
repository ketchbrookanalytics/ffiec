#' Define the base URL for all FFIEC API endpoints
#' @noRd
base_url <- "https://ffieccdr.azure-api.us/public/"

#' Create a small error handler to return error messages from API
#' @noRd
ffiec_error_message <- function(resp) {
  httr2::resp_body_json(resp)$Message
}

#' Handle missing UserID / Bearer Token values
#' @noRd
check_empty_creds <- function(user_id, bearer_token) {

  if (is.null(user_id) || trimws(user_id) == "") {
    paste(
      "`user_id` is missing. If you do not have a UserID with the FFIEC's",
      "web service, you can register for one at",
      "{.url https://cdr.ffiec.gov/public/PWS/CreateAccount.aspx?PWS=true}."
    ) |>
      cli::cli_abort()
  }

  if (is.null(bearer_token) || trimws(bearer_token) == "") {
    paste(
      "`bearer_token` is missing. If you do not have a UserID with the FFIEC's",
      "web service, you can register for one at",
      "{.url https://cdr.ffiec.gov/public/PWS/CreateAccount.aspx?PWS=true}."
    ) |>
      cli::cli_abort()
  }

}

#' Handle missing UserID / Bearer Token values without throwing an error for
#' unit testing purposes
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API
#'
#' @return (Logical) `FALSE` if a valid `user_id` and `bearer_token` are
#'   available; otherwise `TRUE`.
#'
#' @details Intended for internal use.
#'
#' @export
no_creds_available <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                               bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN")) {

  if (
    is.null(user_id) ||
      trimws(user_id) == "" ||
      is.null(bearer_token) ||
      trimws(bearer_token) == ""
  ) TRUE else FALSE

}