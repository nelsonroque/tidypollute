library(testthat)
library(digest)
library(tidypollute)  # Replace with your actual package name

data(epa_airdata_links)  # Load the dataset once to avoid redundancy

# Test 1: MD5 hash check
test_that("epa_airdata_links dataset matches expected MD5 hash", {
  expected_md5 <- "635d2b50e2adee412e7d4eb2a1b6175b"  # Replace with the actual MD5 hash
  computed_md5 <- digest(epa_airdata_links, algo = "md5")
  expect_equal(computed_md5, expected_md5,
               info = "The dataset has changed unexpectedly. Check for unintended modifications.")
})

# Test 2: Check if epa_zip_links is a tibble
test_that("epa_airdata_links is a tibble", {
  expect_s3_class(epa_airdata_links, "tbl_df")
})

# Test 3: Ensure column names are correct
test_that("epa_airdata_links has correct column names", {
  expect_named(epa_airdata_links,
               c("year", "unit_of_analysis", "analyte", "url", "analyte_description"),
               ignore.order = TRUE)
})

# Test 4: Check column types
test_that("epa_airdata_links columns have expected data types", {
  expect_type(epa_airdata_links$year, "character")  # Assuming year is stored as character
  expect_type(epa_airdata_links$url, "character")
  expect_type(epa_airdata_links$analyte_description, "character")
})
