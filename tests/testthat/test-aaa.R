# Helper for building mock API error responses
mock_error_response <- function(
  body,
  content_type = "application/json",
  status_code = 400
) {
  httr2::response(
    status_code = status_code,
    headers = if (is.null(content_type)) {
      list()
    } else {
      list("Content-Type" = content_type)
    },
    body = charToRaw(body)
  )
}

test_that("`ffiec_error_message()` extracts `$Message` from a JSON object", {
  expect_identical(
    ffiec_error_message(
      mock_error_response('{"Message": "Access denied due to invalid UserID"}')
    ),
    "Access denied due to invalid UserID"
  )
})


test_that("`ffiec_error_message()` handles a bare JSON string", {
  # The API returns a bare JSON string (not an object) when it cannot find a
  # facsimile, e.g., a non-existent RSSD ID or an unfiled report date
  expect_identical(
    ffiec_error_message(
      mock_error_response('"Error Code 204: Facsimile not found"')
    ),
    "Error Code 204: Facsimile not found"
  )
})


test_that("`ffiec_error_message()` returns `NULL` for unhandled body shapes", {
  # Each of these falls back to {httr2}'s own error message rather than
  # erroring while trying to build ours

  # JSON object without a `Message` element (e.g., a lowercase key)
  expect_null(
    ffiec_error_message(mock_error_response('{"message": "lowercase key"}'))
  )

  # JSON array
  expect_null(
    ffiec_error_message(mock_error_response('["one", "two"]'))
  )

  # JSON null
  expect_null(
    ffiec_error_message(mock_error_response("null"))
  )

  # Empty body
  expect_null(
    ffiec_error_message(mock_error_response(""))
  )

  # Non-JSON body (e.g., an HTML error page from a gateway)
  expect_null(
    ffiec_error_message(
      mock_error_response(
        "<html><body>500 Internal Server Error</body></html>",
        content_type = "text/html"
      )
    )
  )

  # Body that cannot be parsed as JSON because no `Content-Type` was sent
  expect_null(
    ffiec_error_message(
      mock_error_response('{"Message": "hi"}', content_type = NULL)
    )
  )
})


test_that("`ffiec_error_message()` does not error on any body shape", {
  # Regression test for the `$ operator is invalid for atomic vectors` failure;
  # building the error message must never itself throw
  bodies <- list(
    '{"Message": "object with Message"}',
    '"bare string"',
    '{"message": "lowercase key"}',
    '["one", "two"]',
    "null",
    "",
    "not json at all"
  )

  for (body in bodies) {
    expect_no_error(ffiec_error_message(mock_error_response(body)))
  }
})


test_that("`ffiec_error_message()` surfaces API messages through a request", {
  err_req <- get_ffiec(
    endpoint = "test/endpoint",
    user_id = "abc123",
    bearer_token = "def456"
  )

  # An API-supplied message becomes the error condition's message
  expect_error(
    httr2::with_mocked_responses(
      list(mock_error_response('{"Message": "Invalid UserID"}')),
      collect_response(err_req)
    ),
    "Invalid UserID"
  )

  # When no message can be extracted, {httr2} supplies its own
  expect_error(
    httr2::with_mocked_responses(
      list(
        mock_error_response(
          "<html>oops</html>",
          content_type = "text/html",
          status_code = 500
        )
      ),
      collect_response(err_req)
    ),
    "HTTP 500"
  )
})


test_that("`check_empty_creds()` fails without creds set", {
  # Check empty strings
  expect_error(
    check_empty_creds(
      user_id = "     ",
      bearer_token = "abc123"
    ),
    "`user_id` is missing"
  )

  expect_error(
    check_empty_creds(
      user_id = "abc123",
      bearer_token = "   "
    ),
    "`bearer_token` is missing"
  )

  # Check NULLs
  expect_error(
    check_empty_creds(
      user_id = NULL,
      bearer_token = "abc123"
    ),
    "`user_id` is missing"
  )

  expect_error(
    check_empty_creds(
      user_id = "abc123",
      bearer_token = NULL
    ),
    "`bearer_token` is missing"
  )

  # Silent when non-empty creds are supplied to both args
  expect_silent(
    check_empty_creds(
      user_id = "abc123",
      bearer_token = "def456"
    )
  )
})


test_that("`no_creds_available()` returns correct boolean", {
  # Check empty strings
  expect_true(
    no_creds_available(
      user_id = "     ",
      bearer_token = "abc123"
    )
  )

  expect_true(
    no_creds_available(
      user_id = "abc123",
      bearer_token = "   "
    )
  )

  # Check NULLs
  expect_true(
    no_creds_available(
      user_id = NULL,
      bearer_token = "abc123"
    )
  )

  expect_true(
    no_creds_available(
      user_id = "abc123",
      bearer_token = NULL
    )
  )

  # Returns `FALSE` with non-empty creds
  expect_false(
    no_creds_available(
      user_id = "abc123",
      bearer_token = "def456"
    )
  )
})


test_that("`check_report_dates()` handles a single valid Date", {
  expect_message(
    expect_message(
      expect_identical(
        check_report_dates(as.Date("2025-03-31")),
        "03/31/2025"
      ),
      "2025-03-31 \u2192 03/31/2025"
    ),
    "Converting"
  )
})


test_that("`check_report_dates()` handles multiple valid Dates", {
  expect_message(
    expect_message(
      expect_message(
        expect_identical(
          check_report_dates(as.Date(c("2025-03-31", "2025-06-30"))),
          c("03/31/2025", "06/30/2025")
        ),
        "2025-06-30 \u2192 06/30/2025"
      ),
      "2025-03-31 \u2192 03/31/2025"
    ),
    "Converting"
  )
})


test_that("`check_report_dates()` handles valid character strings", {
  # Single
  expect_silent(
    check_report_dates("03/31/2025")
  )

  expect_identical(
    check_report_dates("03/31/2025"),
    "03/31/2025"
  )

  # Multiple
  expect_silent(
    check_report_dates(c("03/31/2025", "06/30/2025"))
  )

  expect_identical(
    check_report_dates(c("03/31/2025", "06/30/2025")),
    c("03/31/2025", "06/30/2025")
  )
})


test_that("`check_report_dates()` errors on invalid character string inputs", {
  expect_error(
    check_report_dates("2025-03-31"),
    "MM/DD/YYYY"
  )

  expect_error(
    check_report_dates("2025-03-31"),
    "formatted incorrectly"
  )

  expect_error(
    check_report_dates("3/31/2025"),
    "3/31/2025"
  )

  expect_error(
    check_report_dates(c("03/31/2025", "2025-06-30")),
    "2025-06-30"
  )
})


test_that("`check_report_dates()` errors on non-character, non-Date input", {
  expect_error(
    check_report_dates(20250331),
    "must be type"
  )
})


req <- get_ffiec(
  endpoint = "test/endpoint",
  user_id = "abc123",
  bearer_token = "def456"
)

test_that("`get_ffiec()` returns an `httr2_request` object", {
  expect_s3_class(req, "httr2_request")
})


test_that("`get_ffiec()` constructs the URL from `base_url` + `endpoint`", {
  expect_identical(req$url, paste0(base_url, "test/endpoint"))
})


test_that("`get_ffiec()` defaults to a GET request", {
  expect_identical(req$method, "GET")
})


test_that("`get_ffiec()` sets `Content-Type` to `application/json` by default", {
  expect_identical(req$headers[["Content-Type"]], "application/json")
})


test_that("`get_ffiec()` converts extra header names to camelCase", {
  req <- get_ffiec(
    endpoint = "test/endpoint",
    user_id = "abc123",
    bearer_token = "def456",
    report_period = "03/31/2025",
    my_custom_header = "value"
  )

  header_names <- names(req$headers)

  expect_true("reportPeriod" %in% header_names)
  expect_true("myCustomHeader" %in% header_names)
  expect_false("report_period" %in% header_names)
  expect_false("my_custom_header" %in% header_names)
})


test_that("`collect_response()` returns the appropriate object type", {
  # Returns a parsed list when `decode = FALSE`
  mock_body <- list(foo = "bar", baz = 123L)

  result <- httr2::with_mocked_responses(
    list(
      httr2::response(
        status_code = 200,
        headers = list("Content-Type" = "application/json"),
        body = charToRaw(jsonlite::toJSON(mock_body, auto_unbox = TRUE))
      )
    ),
    collect_response(req, decode = FALSE)
  )

  expect_type(result, "list")
  expect_identical(result$foo, "bar")
  expect_identical(result$baz, 123L)

  # Returns a character string when `decode = TRUE`
  original <- "hello world"
  encoded_body <- jsonlite::base64_enc(charToRaw(original))

  result <- httr2::with_mocked_responses(
    list(httr2::response(
      status_code = 200,
      body = charToRaw(encoded_body)
    )),
    collect_response(req, decode = TRUE)
  )

  expect_type(result, "character")
  expect_identical(result, original)
})
