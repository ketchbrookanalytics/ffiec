# Tests for `get_facsimile()`

if (!no_creds_available()) {

  # Store an example (successful) result for testing
  out <- get_facsimile(
    reporting_period_end_date = "03/31/2025",
    fi_id = 480228
  )

  test_that("`get_facsimile()` throws an error with empty creds", {

    expect_error(
      get_facsimile(
        user_id = NULL,
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_facsimile(
        bearer_token = NULL,
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`bearer_token` is missing"
    )

    expect_error(
      get_facsimile(
        user_id = "",
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_facsimile(
        bearer_token = "",
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`bearer_token` is missing"
    )

  })



  test_that("`get_facsimile()` returns a tibble", {

    expect_true(
      inherits(out, "tbl_df")
    )

    expect_true(
      inherits(out, "tbl")
    )

    expect_true(
      inherits(out, "data.frame")
    )

  })



  test_that("`get_facsimile()` returns expected column names", {

    expected_col_names <- c(
      "CallDate",
      "BankRSSDIdentifier",
      "MDRM",
      "Value",
      "LastUpdate",
      "ShortDefinition",
      "CallSchedule",
      "LineNumber"
    )

    expect_identical(
      colnames(out),
      expected_col_names
    )

  })



  test_that("`get_facsimile()` allows other types of institution identifiers", {

    out_w_fdic_cert_number <- get_facsimile(
      reporting_period_end_date = "03/31/2025",
      fi_id_type = "FDICCertNumber",
      fi_id = "3510"
    )

    expect_identical(
      out,
      out_w_fdic_cert_number
    )

  })



  test_that("`get_facsimile()` accepts Date objects for `reporting_period_end_date`", {

    out_date <- get_facsimile(
      reporting_period_end_date = as.Date("2025-03-31"),
      fi_id = 480228
    )

    expect_identical(out, out_date)

  })


  test_that("`get_facsimile()` allows more than one reporting period", {

    reporting_periods <- c("03/31/2025", "06/30/2025")

    out_w_multi_report_period <- get_facsimile(
      reporting_period_end_date = reporting_periods,
      fi_id = 480228
    )

    expect_equal(
      out_w_multi_report_period$CallDate |>
        unique() |>
        length(),
      length(reporting_periods)
    )

  })


  test_that("`get_facsimile()` allows more than one institution identifier", {

    institution_ids <- c(480228, 783648)

    out_w_multi_inst_ids <- get_facsimile(
      reporting_period_end_date = "03/31/2025",
      fi_id = institution_ids
    )

    expect_equal(
      out_w_multi_inst_ids$BankRSSDIdentifier |>
        unique() |>
        length(),
      length(institution_ids)
    )

  })



  # Tests for `get_ubpr_facsimile()`

  # Store an example (successful) result for testing
  out <- get_ubpr_facsimile(
    reporting_period_end_date = "03/31/2025",
    fi_id = 480228
  )

  test_that("`get_ubpr_facsimile()` throws an error with empty creds", {

    expect_error(
      get_ubpr_facsimile(
        user_id = NULL,
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_ubpr_facsimile(
        bearer_token = NULL,
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`bearer_token` is missing"
    )

    expect_error(
      get_ubpr_facsimile(
        user_id = "",
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`user_id` is missing"
    )

    expect_error(
      get_ubpr_facsimile(
        bearer_token = "",
        reporting_period_end_date = "03/31/2025",
        fi_id = 480228
      ),
      "`bearer_token` is missing"
    )

  })



  test_that("`get_ubpr_facsimile()` returns a tibble", {

    expect_true(
      inherits(out, "tbl_df")
    )

    expect_true(
      inherits(out, "tbl")
    )

    expect_true(
      inherits(out, "data.frame")
    )

  })



  test_that("`get_ubpr_facsimile()` returns expected column names", {

    expected_col_names <- c(
      "ID_RSSD",
      "Quarter",
      "Metric",
      "Unit",
      "Decimals",
      "Value"
    )

    expect_identical(
      colnames(out),
      expected_col_names
    )

  })



  test_that("`get_ubpr_facsimile()` allows other types of institution identifiers", {

    out_w_fdic_cert_number <- get_ubpr_facsimile(
      reporting_period_end_date = "03/31/2025",
      fi_id_type = "FDICCertNumber",
      fi_id = "3510"
    )

    expect_identical(
      out,
      out_w_fdic_cert_number
    )

  })



  test_that("`get_ubpr_facsimile()` accepts Date objects for `reporting_period_end_date`", {

    out_date <- get_ubpr_facsimile(
      reporting_period_end_date = as.Date("2025-03-31"),
      fi_id = 480228
    )

    expect_identical(out, out_date)

  })


  test_that("`get_ubpr_facsimile()` allows more than one reporting period", {

    fi_id = 480228
    reporting_periods = c("03/31/2025", "06/30/2025")

    out_period_one <- get_ubpr_facsimile(
      reporting_period_end_date = reporting_periods[1],
      fi_id = fi_id
    )

    out_period_two <- get_ubpr_facsimile(
      reporting_period_end_date = reporting_periods[2],
      fi_id = fi_id
    )

    out_w_multi_report_period <- get_ubpr_facsimile(
      reporting_period_end_date = reporting_periods,
      fi_id = fi_id
    )

    expect_identical(
      rbind(
        out_period_one,
        out_period_two
      ),
      out_w_multi_report_period
    )

  })


  test_that("`get_ubpr_facsimile()` allows more than one institution identifier", {

    institution_ids <- c(480228, 783648)

    out_w_multi_inst_ids <- get_ubpr_facsimile(
      reporting_period_end_date = "03/31/2025",
      fi_id = institution_ids
    )

    expect_equal(
      out_w_multi_inst_ids$ID_RSSD |>
        unique() |>
        length(),
      length(institution_ids)
    )

  })

}