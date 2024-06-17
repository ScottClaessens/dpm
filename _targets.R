options(
  tidyverse.quiet = TRUE,
  clustermq.scheduler = "slurm", 
  clustermq.template = "slurm_clustermq.tmpl"
)
library(targets)
library(tarchetypes)
library(tidyverse)
tar_option_set(packages = c("ape","cmdstanr","coevolve",
                            "posterior","tidyverse"))
tar_source()
# pipeline
list(
  ### 1. Synthetic data simulation
  
  # compile model
  tar_target(model, compileModel()),
  # simulate data and fit models
  tar_target(id, 1),
  tar_map(
    # loop over different sample sizes
    values = tibble(n = c(5)),
    tar_target(data, simulateData(n, id), pattern = map(id)),
    tar_target(results, fitModelAndExtract(model, data, id), 
               pattern = map(data, id))
  ),
  # combine results
  tar_target(results, bind_rows(results_5)),
  # summarise results
  tar_target(power, calculatePower(results)),
  
  ### Session info
  tar_target(
    sessionInfo, 
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
