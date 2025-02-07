# ----------------------------
# Versioning
# ----------------------------

# 1. Increment Package Version (Change to "major", "minor", or "patch" as needed)
usethis::use_version("patch")

# -------------------------------
# R Package Build & Validation
# -------------------------------

# 2. Generate Documentation (Updates roxygen2-generated docs)
#devtools::document()

# 3. Spell Check (Check for typos in documentation and code comments)
devtools::spell_check()

# run custom cleaning
# remove all from vignettes data folder

# 4. Run Package Checks (Ensures code quality, runs tests, and checks dependencies)
devtools::check()

# 5. Run Tests (Ensures that all test cases pass)
devtools::test()

# 6. Build Package (Creates the .tar.gz package file)
#devtools::build()

# 7. Install Package (Installs the package locally)
devtools::install()

# -----------------------------------
# Platform & Cross-Compatibility Checks
# -----------------------------------

# 8. Check on Windows (Runs package checks on CRAN’s Windows build system)
devtools::check_win_release()

# 9. Run R-hub Checks (Optional: Uncomment if needed for cross-platform testing)
# rhub::rhub_setup()
# rhub::check()

# -----------------------------------
# Package Documentation & Website
# -----------------------------------

# 10. Build the pkgdown Website (Generates documentation site)
pkgdown::build_site(preview=TRUE)

# ----------------------------
# CRAN Submission & GitHub Setup
# ----------------------------

# 12. Set up GitHub Actions to automatically run tests when pushing changes:
usethis::use_github_action_check_standard()

# 13. Submit to CRAN (Runs final checks and submits package)
#devtools::release()

# NOTES FOR `paper.md` -----
# https://joss.readthedocs.io/en/latest/paper.html#what-should-my-paper-contain
