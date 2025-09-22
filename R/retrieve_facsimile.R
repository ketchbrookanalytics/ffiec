#' Retrieve Facsimile
#'
#' @description Retrieves facsimile data from the FFIEC Central Data
#' Repository API for the requested financial institution.
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API.
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API
#' @param reporting_period_end_date (String) The reporting period end date,
#'   formatted as "MM/DD/YYYY"
#' @param fi_id_type (String) The type of identifier being provided; one of
#'   `c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber")`
#' @param fi_id (String) The financial institution's identifier (can also be
#'   supplied as an integer instead of a string)
#'
#' @return A tibble containing the facsimile data.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Assume you have set the following environment variables:
#' # - FFIEC_USER_ID
#' # - FFIEC_BEARER_TOKEN
#'
#' # Retrieve facsimile data for reporting period 2025-03-31 for instutition
#' # with ID RSSD "480228"
#' retrieve_facsimile(
#'   reporting_period_end_date = "03/31/2025",
#'   fi_id = 480228
#' )
#'
#' # Retrieve expected filers for reporting period 2025-03-31 and return as a
#' # list
#' retrieve_facsimile(
#'   reporting_period_end_date = "03/31/2025",
#'   fi_id_type = "FDICCertNumber",
#'   fi_id = "3510"
#' )
#'
#' }
retrieve_facsimile <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                               bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                               reporting_period_end_date,
                               fi_id_type = c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber"),
                               fi_id) {

  base_url <- "https://ffieccdr.azure-api.us/public/"
  endpoint <- "RetrieveFacsimile"
  url <- paste0(base_url, endpoint)
  data_series <- "Call"
  fi_id_type <- match.arg(fi_id_type)

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
      "facsimileFormat" = "SDF"
    )

  # Perform the request and collect the raw response that can be decoded into
  # semicolon-delimited data
  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    jsonlite::base64_dec() |>
    rawToChar()

  # Read the raw file (semicolon-delimited data) into a tibble
  resp <- read.delim(
    file = textConnection(resp),
    sep = ";",
    col.names = c(
      "CallDate",
      "BankRSSDIdentifier",
      "MDRM",
      "Value",
      "LastUpdate",
      "ShortDefinition",
      "CallSchedule",
      "LineNumber"
    )
  ) |>
  tibble::as_tibble()

  return(resp)

}











user_id <- Sys.getenv("FFIEC_USER_ID"),
bearer_token <- Sys.getenv("FFIEC_BEARER_TOKEN")
base_url <- "https://ffieccdr.azure-api.us/public/"
endpoint <- "RetrieveUBPRXBRLFacsimile"
url <- paste0(base_url, endpoint)
reporting_period_end_date <- "03/31/2025"
fi_id_type <- "ID_RSSD"
fi_id <- "480228"

# Build the request following the API specification
req <- httr2::request(url) |>
  httr2::req_method("GET") |>
  httr2::req_headers(
    "Content-Type" = "application/json",
    "UserID" = user_id,
    "Authentication" = paste0("Bearer ", bearer_token),
    "reportingPeriodEndDate" = reporting_period_end_date,
    "fiIdType" = fi_id_type,
    "fiId" = as.character(fi_id)
  )

# Perform the request and collect the raw response that can be decoded into
# semicolon-delimited data
resp <- req |>
  httr2::req_perform() |>
  httr2::resp_body_string() |>
  jsonlite::base64_dec() |>
  rawToChar()

tmp <- xml2::read_xml(resp)

# Filter to just the rectangular data
tmp3 <- xml2::xml_find_all(tmp, ".//uc:* | .//cc:*")

tmp3 |> xml2::xml_attrs() |> head()
tmp3 |> xml2::as_list() |> head()

# Get metric code
tmp3 |> xml2::xml_name()

# Get context
tmp3 |> xml2::xml_attr("contextRef")

# Get unit
tmp3 |> xml2::xml_attr("unitRef")

# Get decimals
tmp3 |> xml2::xml_attr("decimals")

# Get the values
tmp3 |> xml2::xml_text()

tibble::tibble(
  Metric = xml2::xml_name(tmp3),
  Context = xml2::xml_attr(tmp3, "contextRef"),
  Unit = xml2::xml_attr(tmp3, "unitRef"),
  Decimals = xml2::xml_attr(tmp3, "decimals"),
  Value = xml2::xml_text(tmp3)
)
