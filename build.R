# ----------------------------
# Versioning
# ----------------------------

run_build <- function(version_type = "patch", skip_spell_check = FALSE, skip_site_build = FALSE) {

  # Ensure necessary packages are installed
  required_pkgs <- c("usethis", "devtools", "pkgdown")
  for (pkg in required_pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop(paste("Package", pkg, "is not installed. Please install it first."))
    }
  }

  # Commmit to Github
  message("🔄 Committing and pushing changes to Git...")
  system("git add .")
  system("git commit -m 'Auto-update before build'")
  #system("git push")

  # Increment package version
  message("📌 Incrementing package version...")
  Sys.setenv("usethis.quiet" = "TRUE")  # Suppress confirmation prompts
  usethis::use_version(version_type)

  # Build package
  message("📖 Generating documentation...")
  devtools::document()

  if (!skip_spell_check) {
    message("🔍 Running spell check...")
    devtools::spell_check()
  } else {
    message("⏩ Skipping spell check...")
  }

  message("✅ Running package checks...")
  devtools::check()

  if (!skip_site_build) {
    message("🌍 Building pkgdown site...")
    pkgdown::build_site(preview = TRUE)
  } else {
    message("⏩ Skipping site build...")
  }

  message("🎉 Build process complete!")
}

# run build -----
run_build()

# Submit to CRAN -----
## Runs final checks and submits package)
devtools::release()

# NOTES FOR `paper.md` -----
# https://joss.readthedocs.io/en/latest/paper.html#what-should-my-paper-contain
