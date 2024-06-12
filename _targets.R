library(targets)
library(tarchetypes)
tar_option_set(
  packages = c()
)
tar_source()
# pipeline
list(
  # session info
  tar_target(
    sessionInfo, 
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
