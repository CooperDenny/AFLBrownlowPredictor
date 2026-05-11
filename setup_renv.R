# Run this script once to initialise renv and create a lock file for this project.
# After running, commit renv.lock and renv/activate.R to git.
#
# Usage (from R console or terminal):
#   Rscript setup_renv.R
#
# Steps performed:
#   1. Installs renv if not already present
#   2. Initialises renv for this project
#   3. Installs all required packages
#   4. Snapshots the environment to renv.lock

if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

renv::init()

required_packages <- c(
  "tidyverse",
  "ordinal",
  "knitr",
  "unglue",
  "fastDummies",
  "writexl",
  "DT",
  "caret",
  "ggplot2"
)

renv::install(required_packages)
renv::snapshot()

message("renv setup complete. Commit renv.lock and renv/activate.R to git.")
