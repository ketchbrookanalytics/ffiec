# Tests for `check_report_dates()`

test_that("`check_report_dates()` converts Date to MM/DD/YYYY", {

  expect_identical(
    check_report_dates(as.Date("2025-03-31")),
    "03/31/2025"
  )

  expect_identical(
    check_report_dates(
      as.Date(c("2025-03-31", "2025-06-30"))
    ),
    c("03/31/2025", "06/30/2025")
  )

})


test_that("`check_report_dates()` passes through valid character strings", {

  expect_identical(
    check_report_dates("03/31/2025"),
    "03/31/2025"
  )

  expect_identical(
    check_report_dates(c("03/31/2025", "06/30/2025")),
    c("03/31/2025", "06/30/2025")
  )

})


test_that("`check_report_dates()` errors on bad character formats", {

  expect_error(
    check_report_dates("2025-03-31"),
    "MM/DD/YYYY"
  )

  expect_error(
    check_report_dates("3/31/2025"),
    "MM/DD/YYYY"
  )

})


test_that("`check_report_dates()` errors on non-character, non-Date input", {

  expect_error(
    check_report_dates(20250331),
    "MM/DD/YYYY"
  )

})
