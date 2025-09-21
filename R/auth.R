#' Set FFIEC API Authentication
#'
#' Sets up authentication for FFIEC API requests by storing the bearer token.
#'
#' @param token Character string containing the bearer token for authentication
#' @param user_id Character string containing the user ID (optional)
#'
#' @return Invisibly returns the token for use in other functions
#' @export
#'
#' @examples
#' \dontrun{
#' set_ffiec_auth("your-bearer-token-here")
#' }
set_ffiec_auth <- function(token, user_id = "") {
  if (missing(token) || is.null(token) || token == "") {
    stop("Bearer token is required for FFIEC API authentication")
  }
  
  # Store in environment variables for the session
  Sys.setenv(FFIEC_BEARER_TOKEN = token)
  if (user_id != "") {
    Sys.setenv(FFIEC_USER_ID = user_id)
  }
  
  invisible(token)
}

#' Get stored FFIEC bearer token
#' @keywords internal
get_ffiec_token <- function() {
  token <- Sys.getenv("FFIEC_BEARER_TOKEN")
  if (token == "") {
    stop("FFIEC bearer token not set. Use set_ffiec_auth() first.")
  }
  token
}

#' Get stored FFIEC user ID
#' @keywords internal
get_ffiec_user_id <- function() {
  Sys.getenv("FFIEC_USER_ID", unset = "")
}