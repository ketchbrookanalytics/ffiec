# Use a date (for `last_update_date_time`) and return as a list
out_list <- get_filers_since_date(
  reporting_period_end_date = "03/31/2025",
  last_update_date_time = "04/15/2025"
)

# Use a datetime and return a as a tibble
out_df <- get_filers_since_date(
  reporting_period_end_date = "03/31/2025",
  last_update_date_time = "04/15/2025 21:00:00.000",
  as_data_frame = TRUE
)

test_that("`get_filers_since_date()` throws an error with empty creds", {

  expect_error(
    get_filers_since_date(
      user_id = NULL,
      reporting_period_end_date = "03/31/2025",
      last_update_date_time = "04/15/2025",
      as_data_frame = TRUE
    ),
    "`user_id` is missing"
  )

  expect_error(
    get_filers_since_date(
      bearer_token = NULL,
      reporting_period_end_date = "03/31/2025",
      last_update_date_time = "04/15/2025"
    ),
    "`bearer_token` is missing"
  )

  expect_error(
    get_filers_since_date(
      user_id = "",
      reporting_period_end_date = "03/31/2025",
      last_update_date_time = "04/15/2025"
    ),
    "`user_id` is missing"
  )

  expect_error(
    get_filers_since_date(
      bearer_token = "",
      reporting_period_end_date = "03/31/2025",
      last_update_date_time = "04/15/2025",
      as_data_frame = TRUE
    ),
    "`bearer_token` is missing"
  )

})



test_that("`get_filers_since_date()` returns correct output type", {

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



test_that("`get_filers_since_date()` returns expected names", {

  expect_identical(
    colnames(out_df),
    "ID_RSSD"
  )

})