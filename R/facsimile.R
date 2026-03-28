#' Define a helper function to process `get_facsimile()` responses
#' @noRd
process_facsimile_response <- function(resp) {
  df <- read.delim(
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

  return(df)

}


#' Define a helper function to process `get_ubpr_facsimile()` responses
#' @noRd
process_ubpr_response <- function(resp) {
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
      Quarter = purrr::map_chr(.data[["ContextList"]], ~ .x[3]) |> as.Date()
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



#' Retrieve Facsimile
#'
#' @description Retrieves Call Report or UBPR facsimile data from the FFIEC
#' Central Data Repository API for the requested financial institution.
#'
#' @inheritParams no_creds_available
#' @param reporting_period_end_date (Character vector) One or more reporting
#'   period end dates, formatted as "MM/DD/YYYY"
#' @param fi_id_type (String) The type of identifier being provided; one of
#'   `c("ID_RSSD", "FDICCertNumber", "OCCChartNumber", "OTSDockNumber")`;
#'   default is "ID_RSSD"
#' @param fi_id (Character vector) One or more financial institution identifiers
#'   (can also be supplied as an integer vector)
#'
#' @return A tibble containing the facsimile data.
#'
#' @references
#' <https://cdr.ffiec.gov/public/Files/SIS611_-_Retrieve_Public_Data_via_Web_Service.pdf>
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
#'   # Retrieve UBPR facsimile data for reporting period 2025-03-31 for
#'   # instutition with FDIC Cert Number "3510"
#'   get_ubpr_facsimile(
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
  fi_id_type <- match.arg(fi_id_type)

  # Create a data frame of report dates and institution ids to interate over
  req_df <- expand.grid(
    reporting_period_end_date = reporting_period_end_date,
    fi_id = fi_id
  )

  # Build the request(s) following the API specification
  req <- req_df |>
    purrr::pmap(
      \(reporting_period_end_date, fi_id) {
        get_ffiec(
          endpoint = endpoint,
          user_id = user_id,
          bearer_token = bearer_token,
          reporting_period_end_date = reporting_period_end_date,
          fi_id_type = fi_id_type,
          fi_id = as.character(fi_id),
          data_series = "Call",
          facsimile_format = "SDF"
        )
      }
    )

  # Perform the request(s) and collect the raw response(s) that can be decoded
  # into semicolon-delimited data
  resp <- purrr::map(req, .f = collect_response(.x, decode = TRUE))

  # Read the raw file(s) (semicolon-delimited data) into a tibble
  resp <- purrr::map(resp, .f = process_facsimile_response) |>
    dplyr::bind_rows()

  return(resp)

}



#' @rdname get_facsimile
#' @importFrom rlang .data
#' @export
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
  fi_id_type <- match.arg(fi_id_type)

  # Create a data frame of report dates and institution ids to interate over
  req_df <- expand.grid(
    reporting_period_end_date = reporting_period_end_date,
    fi_id = fi_id
  )

  # Build the request(s) following the API specification
  req <- req_df |>
    purrr::pmap(
      \(reporting_period_end_date, fi_id) {
        get_ffiec(
          endpoint = endpoint,
          user_id = user_id,
          bearer_token = bearer_token,
          reporting_period_end_date = reporting_period_end_date,
          fi_id_type = fi_id_type,
          fi_id = as.character(fi_id)
        )
      }
    )

  # Perform the request(s) and collect the raw response(s) that can be decoded
  # into semicolon-delimited data
  resp <- purrr::map(req, .f = collect_response)

  # Read the raw file(s) (XML) into a tibble
  resp <- purrr::map(resp, .f = process_ubpr_response) |>
    dplyr::bind_rows()

  return(resp)

}