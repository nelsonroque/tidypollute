# Building `tidypollute`

## Overview

This file outlines all steps necessary to build this package for Github and CRAN.

## Steps

1. Run `.internal/build_datasets.R`
2. Edit `_pkgdown.yml` as necessary for any new functions.
3. Update `tests/testthat/*` files with relevant hashes from output of `.internal/build_datasets.R`.
4. Run `build.R` at the root level of this RProj.
  a. Check for any errors.
  b. Check for any warnings.
  c. Check for any notes.
5. Confirm preview of pkgdown website.
6. Update `cran-comments.md` with any information that is new/changed.
