#' Retrieve Facsimile
#'
#' @description Retrieves facsimile data from the FFIEC Central Data
#' Repository API for the requested financial institution.
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API
#' @param reporting_period_end_date (String) The reporting period end date,
#'   formatted as "MM/DD/YYYY"
#' @param fi_id_type (String) The type of identifier being provided; one of
#'   `c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber")`;
#'   default is "ID_RSSD"
#' @param fi_id (String) The financial institution's identifier (can also be
#'   supplied as an integer instead of a string)
#'
#' @return A tibble containing the facsimile data.
#'
#' @references
#' https://cdr.ffiec.gov/public/Files/SIS611_-_Retrieve_Public_Data_via_Web_Service.pdf
#'
#' @importFrom utils read.delim
#'
#' @export
#'
#' @examples
#' if (!no_creds_available()) {
#'   # Assume you have set the following environment variables:
#'   # - FFIEC_USER_ID
#'   # - FFIEC_BEARER_TOKEN
#'
#'   # Retrieve facsimile data for reporting period 2025-03-31 for institution
#'   # with ID RSSD "480228"
#'   get_facsimile(
#'     reporting_period_end_date = "03/31/2025",
#'     fi_id = 480228
#'   )
#'
#'   # Retrieve facsimile data for reporting period 2025-03-31 for institution
#'   # with FDIC Cert Number "3510"
#'   get_facsimile(
#'     reporting_period_end_date = "03/31/2025",
#'     fi_id_type = "FDICCertNumber",
#'     fi_id = "3510"
#'   )
#' }
get_facsimile <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                          bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                          reporting_period_end_date,
                          fi_id_type = c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber"),
                          fi_id) {

  check_empty_creds(
    user_id = user_id,
    bearer_token = bearer_token
  )

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
    ) |>
    httr2::req_error(body = ffiec_error_message) |>
    httr2::req_user_agent(
      "ffiec R package (https://ketchbrookanalytics.github.io/ffiec/)"
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
    tibble::as_tibble() |>
    dplyr::mutate(
      dplyr::across(
        .cols = c("CallDate", "LastUpdate"),
        .fns = ~ as.Date(as.character(.x), format = "%Y%m%d")
      )
    )

  return(resp)

}



#' Retrieve UBPR Facsimile
#'
#' @description Retrieves UBPR facsimile data from the FFIEC Central Data
#' Repository API for the requested financial institution.
#'
#' @param user_id (String) The UserID for authenticating against the FFIEC API
#' @param bearer_token (String) The Bearer Token for authenticating against the
#'   FFIEC API
#' @param reporting_period_end_date (String) The reporting period end date,
#'   formatted as "MM/DD/YYYY"
#' @param fi_id_type (String) The type of identifier being provided; one of
#'   `c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber")`;
#'   default is "ID_RSSD"
#' @param fi_id (String) The financial institution's identifier (can also be
#'   supplied as an integer instead of a string)
#'
#' @return A tibble containing the UBPR facsimile data.
#'
#' @references
#' https://cdr.ffiec.gov/public/Files/SIS611_-_Retrieve_Public_Data_via_Web_Service.pdf
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' if (!ffiec:::no_creds_available()) {
#'   # Assume you have set the following environment variables:
#'   # - FFIEC_USER_ID
#'   # - FFIEC_BEARER_TOKEN
#'
#'   # Retrieve UBPR facsimile data for reporting period 2025-03-31 for
#'   # instutition with ID RSSD "480228"
#'   get_ubpr_facsimile(
#'     reporting_period_end_date = "03/31/2025",
#'     fi_id = 480228
#'   )
#'
#'   # Retrieve UBPR facsimile data for reporting period 2025-03-31 for
#'   # instutition with FDIC Cert Number "3510"
#'   get_ubpr_facsimile(
#'     reporting_period_end_date = "03/31/2025",
#'     fi_id_type = "FDICCertNumber",
#'     fi_id = "3510"
#'   )
#' }
get_ubpr_facsimile <- function(user_id = Sys.getenv("FFIEC_USER_ID"),
                               bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
                               reporting_period_end_date,
                               fi_id_type = c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber"),
                               fi_id) {

  check_empty_creds(
    user_id = user_id,
    bearer_token = bearer_token
  )

  endpoint <- "RetrieveUBPRXBRLFacsimile"
  url <- paste0(base_url, endpoint)
  fi_id_type <- match.arg(fi_id_type)

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
    ) |>
    httr2::req_error(body = ffiec_error_message) |>
    httr2::req_user_agent(
      "ffiec R package (https://ketchbrookanalytics.github.io/ffiec/)"
    )

  # Perform the request and collect the raw response that can be decoded into
  # semicolon-delimited data
  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    jsonlite::base64_dec() |>
    rawToChar()

  # Read the raw response into a formal XML document
  resp <- xml2::read_xml(resp)

  # Filter to just the UBPR tabular data
  resp <- xml2::xml_find_all(resp, ".//uc:* | .//cc:*")

  # Read the raw file (semicolon-delimited data) into a tibble
  df <- tibble::tibble(
    Metric = xml2::xml_name(resp),
    Context = xml2::xml_attr(resp, "contextRef"),
    Unit = xml2::xml_attr(resp, "unitRef"),
    Decimals = xml2::xml_attr(resp, "decimals"),
    Value = xml2::xml_text(resp)
  ) |>
    dplyr::distinct() |>   # remove completely duplicated rows
    dplyr::mutate(
      ContextList = stringr::str_split(
        string = .data[["Context"]],
        patter = "_",
        n = 3L
      ),
      ID_RSSD = purrr::map_chr(.data[["ContextList"]], ~ .x[2]),
      Quarter = purrr::map_chr(.data[["ContextList"]], ~ .x[3]) |> as.Date(),
      data_type = dplyr::case_when(
        Decimals == "0" ~ "integer",
        is.na(Decimals) ~ "character",
        .default = "double"
      )
    ) |>
    dplyr::select(
      "ID_RSSD",
      "Quarter",
      "Metric",
      "Unit",
      "Decimals",
      "Value"
    )

  return(df)

}