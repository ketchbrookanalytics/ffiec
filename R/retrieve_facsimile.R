#' Retrieve Panel of Reporters
#'
#' @description Retrieves filer information from the FFIEC Central Data
#' Repository API for the financial institutions in the Panel of Reporters (POR)
#' expected to file for a given Call reporting period.
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API.
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API.
#' @param reporting_period_end_date (String) The reporting period end date,
#'   formatted as "MM/DD/YYYY".
#' @param as_data_frame (Logical) Should the result be returned as a tibble?
#'   Default is `TRUE`.
#'
#' @return A tibble containing the parsed JSON response from the API of filer
#'   information since the given `reporting_period_end_date` date value. If
#'   `as_data_frame = FALSE`, then the result is returned as a nested list
#'   object, where each element represents a unique `ID_RSSD` value.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Assume you have set the following environment variables:
#' # - FFIEC_USER_ID
#' # - FFIEC_BEARER_TOKEN
#'
#' # Retrieve expected filers for reporting period 2025-03-31 and return as a
#' # tibble
#' retrieve_panel_of_reporters(
#'   reporting_period_end_date = "03/31/2025"
#' )
#'
#' # Retrieve expected filers for reporting period 2025-03-31 and return as a
#' # list
#' retrieve_panel_of_reporters(
#'   reporting_period_end_date = "03/31/2025",
#'   as_data_frame = FALSE
#' )
#'
#' }
retrieve_facsimile <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                               bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                               reporting_period_end_date,
                               fi_id_type = c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber"),
                               fi_id,
                               facsimile_format = "SDF",
                               as_data_frame = TRUE) {

  base_url <- "https://ffieccdr.azure-api.us/public/"
  endpoint <- "RetrieveFacsimile"
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
      "fiIdType" = fi_id_type,
      "fiId" = as.character(fi_id),
      "facsimileFormat" = "SDF" # facsimile_format
    )

  # Perform the request and collect the JSON response into an R list object
  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    jsonlite::base64_dec() |>
    rawToChar()

  # Read the raw file (semicolon-delimited data) into a dataframe
  resp <- read.delim(
    textConnection(resp),
    sep = ";"
  )

  return(resp)

}


# Retrieve expected filers for reporting period 2025-03-31 and return as a
# tibble
retrieve_panel_of_reporters(
  reporting_period_end_date = "03/31/2025"
)

# Retrieve expected filers for reporting period 2025-03-31 and return as a
# list
retrieve_panel_of_reporters(
  reporting_period_end_date = "03/31/2025",
  as_data_frame = FALSE
)








# Extract JSON content
resp_string <- resp |> httr2::resp_body_string()

# Decode base64 to raw bytes
raw_bytes <- jsonlite::base64_dec(resp_string)

# Convert to text and read as CSV
text_data <- rawToChar(raw_bytes)
df <- read.delim(
    textConnection(text_data),
    sep = ";"
)

# Parse as JSON array to get the byte values
byte_array <- jsonlite::fromJSON(json_data)

# Convert to raw bytes and then to data frame
raw_bytes <- as.raw(byte_array)
text_data <- rawToChar(raw_bytes)
df <- read.csv(textConnection(text_data))