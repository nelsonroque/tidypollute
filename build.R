# ----------------------------
# Versioning
# ----------------------------

source(".internal/build_process.R")

# run build -----
run_build()

# Submit to CRAN -----
## Runs final checks and submits package)
devtools::release()

# NOTES FOR `paper.md` -----
# https://joss.readthedocs.io/en/latest/paper.html#what-should-my-paper-contain
