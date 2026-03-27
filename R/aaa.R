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



#' Define an extensible HTTP request to obtain data from the FFIEC API
#'
#' @description Defines the base requirements to request data from the
#' FFIEC API. Allows for additional headers to be passed via `...`.
#'
#' @inheritParams no_creds_available
#' @param endpoint (String) The API endpoint to query
#' @param req_method (String) The API request method
#' @param content_type (String) The API request format
#' @param ... Other request headers to pass to [httr2::req_headers()]
#'
#' @return An HTTP request via [httr2::request()].
#'
#' @details Additional headers are converted to camel case due to API
#'   specification.
#' @details Intended for internal use.
#'
#' @export
get_ffiec <- function(endpoint,
                      user_id,
                      bearer_token,
                      req_method = "GET",
                      content_type = "application/json",
                      ...) {

  url <- paste0(base_url, endpoint)

  headers <- list(
    ...
  )

  names(headers) <- stringr::str_to_camel(names(headers))

  req <- httr2::request(url) |>
    httr2::req_method(req_method) |>
    httr2::req_headers(
      "Content-Type" = content_type,
      "UserID" = user_id,
      "Authentication" = paste0("Bearer ", bearer_token),
      !!!headers
    ) |>
    httr2::req_error(body = ffiec_error_message) |>
    httr2::req_user_agent(
      "ffiec R package (https://ketchbrookanalytics.github.io/ffiec/)"
    )

  return(req)

}



#' Perform, collect, and parse an HTTP response
#'
#' @description Performs an HTTP request, returns the response, and, by default,
#'   parses the JSON response to a list. Provides optional handling for
#'   decoding the response to a character string.
#'
#' @param req A [httr2::request()] object.
#' @param decode (Logical) Should the result be decoded into a character string?
#'   Default is `FALSE`.
#'
#' @return A list containing the parsed JSON response from the API.
#'   If `decode = TRUE`, then the response body is decoded and converted to a
#'   character string.
#'
#' @details Intended for internal use.
#'
#' @export
collect_response <- function(req, decode = FALSE) {
  resp <- req |>
    httr2::req_perform()

  if (decode) {
    resp <- httr2::resp_body_string(resp) |>
      jsonlite::base64_dec() |>
      rawToChar()
  } else {
    resp <- httr2::resp_body_json(resp)
  }

  return(resp)
}