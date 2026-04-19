# ffiec 0.2.0

- Provides support for retrieval of multi-period and/or multi-institution data for `get_facsimile()` and `get_ubpr_facsimile()`

## Documentation

- New "General Workflow" vignette that describes a typical workflow for querying metadata, then leveraging those results to query Call Report data

## Miscellenous

- More robust error messaging with {cli}
- Improved code modularization with a "base" API request structure
- Significantly expanded unit test suite

# ffiec 0.1.3

## Fixes for CRAN

- Amended the `DESCRIPTION` file to address two more comments from CRAN regarding spelling & formatting

# ffiec 0.1.2

## Fixes for CRAN

- Amended `DESCRIPTION` file to address two comments from CRAN team regarding formatting & references

# ffiec 0.1.1

## Bug Fixes

- Wrapped all tests & examples in conditional logic that checks whether API credentials are available

## Miscellaneous

- Organized pkgdown site
- Reduced repitition in roxygen
- Require R >= 4.1.0 due to use of base pipe

# ffiec 0.1.0

- Initial CRAN submission.
