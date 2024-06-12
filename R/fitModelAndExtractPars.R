fitModelAndExtractPars <- function(model, data, id) {
  # fit model
  fit <- model$sample(
    data = data,
    show_exceptions = FALSE,
    chains = 4,
    parallel_chains = 4,
    iter_warmup = 1000,
    iter_sampling = 1000,
    seed = 1L
    )
  # get summary
  s <- fit$summary()
  # output relevant information
  s %>%
    # index model number and sample size
    mutate(
      id = id, 
      n = data$N
      ) %>%
    select(id, n, everything()) %>%
    # extract alpha parameters
    filter(str_starts(variable, "alpha\\[")) %>%
    # add useful model information
    mutate(
      maxRhat = max(s$rhat, na.rm = TRUE),
      numDivergences = sum(fit$sampler_diagnostics()[,,"divergent__"]),
      totalTimeSecs = fit$time()$total
    )
}