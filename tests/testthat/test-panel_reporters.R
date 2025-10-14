if (!no_creds_available()) {

  # Return results as a tibble
  out_df <- get_panel_of_reporters(reporting_period_end_date = "03/31/2025")

  # Return results as a list
  out_list <- get_panel_of_reporters(
    reporting_period_end_date = "03/31/2025",
    as_data_frame = FALSE
  )

  test_that("`get_panel_of_reporters()` throws an error with empty creds", {

    expect_error(
      get_panel_of_reporters(
        user_id = NULL,
        reporting_period_end_date = "03/31/2025",
        as_data_frame = FALSE
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_panel_of_reporters(
        bearer_token = NULL,
        reporting_period_end_date = "03/31/2025",
      ),
      "`bearer_token` is missing"
    )

    expect_error(
      get_panel_of_reporters(
        user_id = "",
        reporting_period_end_date = "03/31/2025",
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_panel_of_reporters(
        bearer_token = "",
        reporting_period_end_date = "03/31/2025",
        as_data_frame = FALSE
      ),
      "`bearer_token` is missing"
    )

  })



  test_that("`get_panel_of_reporters()` returns correct output type", {

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

    expected_col_names <- c(
      "ID_RSSD",
      "FDICCertNumber",
      "OCCChartNumber",
      "OTSDockNumber",
      "PrimaryABARoutNumber",
      "Name",
      "State",
      "City",
      "Address",
      "ZIP",
      "FilingType",
      "HasFiledForReportingPeriod"
    )

    expect_identical(
      colnames(out_df),
      expected_col_names
    )

  })

}