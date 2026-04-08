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


# Tests for `check_report_dates()`

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
    "Date"
  )

  expect_error(
    check_report_dates(20250331),
    "character"
  )

})


test_that("`check_report_dates()` errors on Date values without 4-digit year", {

  # This is a vector of class Date but the second value isn't wrapped in
  # `as.Date()`
  bad_dates <- c(as.Date("2022-04-01"), "12/1/2022")

  expect_error(
    check_report_dates(bad_dates) |> suppressMessages(),
    "formatted incorrectly"
  )

  bad_dates <- c(as.Date("2022-04-01"), "1/1/22")

  expect_error(
    check_report_dates(bad_dates) |> suppressMessages(),
    "must be formatted as \"MM/DD/YYYY\""
  )

})
