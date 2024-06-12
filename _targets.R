library(targets)
library(tarchetypes)
library(tidyverse)
tar_option_set(
  packages = c("ape","cmdstanr","coevolve")
)
tar_source()
# pipeline
list(
  ### 1. Synthetic data simulation
  
  # compile model
  tar_target(model, compileModel()),
  # simulate data and fit models
  tar_target(id, 1:2),
  tar_map(
    # loop over different sample sizes
    values = tibble(n = c(5, 6)),
    tar_target(data, simulateData(n, id), pattern = map(id)),
    tar_target(pars, fitModelAndExtractPars(model, data, id), 
               pattern = map(data, id))
  ),
  # combine results
  tar_target(pars, bind_rows(pars_5, pars_6)),
  # summarise results
  tar_target(power, calculatePower(pars)),
  
  ### Session info
  tar_target(
    sessionInfo, 
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
