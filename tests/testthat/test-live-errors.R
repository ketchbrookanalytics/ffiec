# Live contract tests for `ffiec_error_message()`
#
# The mocked tests in test-aaa.R verify that we parse each body shape
# correctly. These tests verify the complementary assumption: that the API
# still *emits* those shapes. A mock can never catch FFIEC renaming
# `$Message`, or returning the "not found" error as an object rather than a
# bare JSON string, so these run against the live API whenever creds are
# available (as the other live tests in this suite do).
#
# Assertions deliberately match loosely on wording -- they pin the response
# *shape*, not FFIEC's copywriting.

if (!no_creds_available()) {
  # Perform a request but suppress {httr2}'s error handling, so we can inspect
  # the raw error response body that `ffiec_error_message()` is handed
  raw_error_response <- function(req) {
    req |>
      httr2::req_error(is_error = function(resp) FALSE) |>
      httr2::req_perform()
  }

  facsimile_req <- function(
    user_id = Sys.getenv("FFIEC_USER_ID"),
    bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN"),
    fi_id = "480228"
  ) {
    get_ffiec(
      endpoint = "RetrieveFacsimile",
      user_id = user_id,
      bearer_token = bearer_token,
      reporting_period_end_date = "03/31/2025",
      fi_id_type = "ID_RSSD",
      fi_id = fi_id,
      data_series = "Call",
      facsimile_format = "SDF"
    )
  }

  test_that("API still returns an object with `$Message` for invalid creds", {
    resp <- raw_error_response(
      facsimile_req(
        user_id = "not-a-real-user-id",
        bearer_token = "not-a-real-token"
      )
    )

    body <- httr2::resp_body_json(resp)

    # The shape our `$Message` branch depends upon
    expect_type(body, "list")
    expect_false(is.null(body$Message))

    # Which means we extract a message rather than falling through to `NULL`
    expect_type(ffiec_error_message(resp), "character")
    expect_match(ffiec_error_message(resp), "Access Denied", fixed = TRUE)

    # And that message reaches the user through the exported function
    expect_error(
      get_facsimile(
        user_id = "not-a-real-user-id",
        bearer_token = "not-a-real-token",
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      regexp = "Access Denied"
    )
  })

  test_that("API still returns a bare JSON string for a missing facsimile", {
    # A non-existent RSSD ID; the same shape is returned for a report date
    # that has not been filed yet
    resp <- raw_error_response(facsimile_req(fi_id = "999999999"))

    body <- httr2::resp_body_json(resp)

    # The shape our bare-string branch depends upon, and the one that
    # originally caused `$ operator is invalid for atomic vectors`
    expect_type(body, "character")
    expect_length(body, 1L)

    expect_type(ffiec_error_message(resp), "character")
    expect_match(ffiec_error_message(resp), "Facsimile not found", fixed = TRUE)

    expect_error(
      get_facsimile(
        reporting_period_end_date = "03/31/2025",
        fi_id = 999999999
      ),
      regexp = "Facsimile not found"
    )
  })

  test_that("gateway 404 falls through to {httr2}'s own error message", {
    # A non-existent endpoint is answered by the Azure API Management gateway
    # rather than the FFIEC application, and it uses a lowercase `message` key.
    # We deliberately do not extract that, so {httr2} supplies its own message
    resp <- raw_error_response(
      get_ffiec(
        endpoint = "NoSuchEndpoint",
        user_id = Sys.getenv("FFIEC_USER_ID"),
        bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN")
      )
    )

    expect_identical(httr2::resp_status(resp), 404L)

    body <- httr2::resp_body_json(resp)

    # An object, but with no `$Message` element for us to extract
    expect_type(body, "list")
    expect_null(body$Message)

    expect_null(ffiec_error_message(resp))

    # So the user sees {httr2}'s message instead of an API-supplied one
    expect_error(
      collect_response(
        get_ffiec(
          endpoint = "NoSuchEndpoint",
          user_id = Sys.getenv("FFIEC_USER_ID"),
          bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN")
        )
      ),
      regexp = "HTTP 404"
    )
  })
}
