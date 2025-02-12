# ----------------------------
# Versioning
# ----------------------------

source(".internal/build_process.R")

# run build -----
run_build()

# Submit to CRAN -----
## Runs final checks and submits package)
#devtools::release()

# for pkgdown.yml
# figures:
#   dev: ragg::agg_png
# dpi: 96
# dev.args: []
# fig.ext: png
# fig.width: 7.2916667
# fig.height: ~
#   fig.retina: 2
# fig.asp: 1.618
# bg: NA
# other.parameters: []

# NOTES FOR `paper.md` -----
# https://joss.readthedocs.io/en/latest/paper.html#what-should-my-paper-contain
