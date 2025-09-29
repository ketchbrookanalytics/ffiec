# Tests for `get_facsimile()`

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