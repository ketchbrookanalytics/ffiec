if (!no_creds_available()) {

  # Return the results as a tibble
  out_df <- get_filers_submission_datetime(
    reporting_period_end_date = "03/31/2025",
    last_update_date_time = "04/15/2025"
  )

  # Return the results as a list
  out_list <- get_filers_submission_datetime(
    reporting_period_end_date = "03/31/2025",
    last_update_date_time = "04/15/2025 21:00:00.000",
    as_data_frame = FALSE
  )

  test_that("`get_facsimile()` throws an error with empty creds", {

    expect_error(
      get_filers_submission_datetime(
        user_id = NULL,
        reporting_period_end_date = "03/31/2025",
        last_update_date_time = "04/15/2025"
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_filers_submission_datetime(
        bearer_token = NULL,
        reporting_period_end_date = "03/31/2025",
        last_update_date_time = "04/15/2025",
        as_data_frame = FALSE
      ),
      "`bearer_token` is missing"
    )

    expect_error(
      get_filers_submission_datetime(
        user_id = "",
        reporting_period_end_date = "03/31/2025",
        last_update_date_time = "04/15/2025",
        as_data_frame = FALSE
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_filers_submission_datetime(
        bearer_token = "",
        reporting_period_end_date = "03/31/2025",
        last_update_date_time = "04/15/2025"
      ),
      "`bearer_token` is missing"
    )

  })



  test_that("`get_filers_submission_datetime()` returns correct output type", {

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



  test_that("`get_filers_submission_datetime()` returns expected names", {

    expected_col_names <- c(
      "ID_RSSD",
      "DateTime"
    )

    expect_identical(
      colnames(out_df),
      expected_col_names
    )

  })

}