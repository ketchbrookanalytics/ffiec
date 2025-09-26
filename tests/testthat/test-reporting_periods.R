# `get_reporting_periods()` tests

# Return the results as a tibble
out_list <- get_reporting_periods()

# Return the results as a list
out_df <- get_reporting_periods(as_data_frame = TRUE)

test_that("`get_reporting_periods()` returns correct output type", {

  # list
  expect_true(
    inherits(out_list, "list")
  )

  # tibble
  expect_true(
    inherits(out_df, "tbl_df")
  )

  expect_true(
    inherits(out_df, "tbl")
  )

  expect_true(
    inherits(out_df, "data.frame")
  )

})



test_that("`get_reporting_periods()` returns expected names", {

  expect_identical(
    colnames(out_df),
    "ReportingPeriod"
  )

})



# `get_ubpr_reporting_periods()` tests

# Return the results as a tibble
out_list <- get_ubpr_reporting_periods()

# Return the results as a list
out_df <- get_ubpr_reporting_periods(as_data_frame = TRUE)

test_that("`get_ubpr_reporting_periods()` returns correct output type", {

  # list
  expect_true(
    inherits(out_list, "list")
  )

  # tibble
  expect_true(
    inherits(out_df, "tbl_df")
  )

  expect_true(
    inherits(out_df, "tbl")
  )

  expect_true(
    inherits(out_df, "data.frame")
  )

})



test_that("`get_ubpr_reporting_periods()` returns expected names", {

  expect_identical(
    colnames(out_df),
    "ReportingPeriod"
  )

})