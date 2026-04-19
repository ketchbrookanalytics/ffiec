# Handle missing UserID / Bearer Token values without throwing an error for unit testing purposes

Handle missing UserID / Bearer Token values without throwing an error
for unit testing purposes

## Usage

``` r
no_creds_available(
  user_id = Sys.getenv("FFIEC_USER_ID"),
  bearer_token = Sys.getenv("FFIEC_BEARER_TOKEN")
)
```

## Arguments

- user_id:

  (String) The UserID for authenticating against the FFIEC API

- bearer_token:

  (String) The Bearer Token for authenticating against the FFIEC API

## Value

(Logical) `FALSE` if a non-empty `user_id` and `bearer_token` have been
supplied; otherwise `TRUE`.

## Details

Intended for internal use.
