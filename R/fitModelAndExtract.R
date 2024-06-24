fitModelAndExtract <- function(model, data, id) {
  # fit model
  fit <- model$sample(
    data = data,
    chains = 4,
    parallel_chains = 4,
    iter_warmup = 2000,
    iter_sampling = 2000,
    adapt_delta = 0.99,
    seed = 1L
    )
  # get posterior
  draws <- as_draws_rvars(fit)
  # calculate delta theta for both variables
  delta_theta_x <- calculateDeltaTheta(draws, data, resp = "x")
  delta_theta_y <- calculateDeltaTheta(draws, data, resp = "y")
  # save summary
  tibble(
    direction = c("X -> Y", "Y -> X", "Difference"),
    delta_theta = list(delta_theta_y, delta_theta_x,
                       delta_theta_y - delta_theta_x)
    ) %>%
    mutate(
      median = map(delta_theta, function(x) as.numeric(median(x))),
      lower  = map(delta_theta, function(x) as.numeric(quantile(x, 0.025))),
      upper  = map(delta_theta, function(x) as.numeric(quantile(x, 0.975)))
    ) %>%
    dplyr::select(-delta_theta) %>%
    unnest(c(median, lower, upper)) %>%
    # index model number and sample size
    mutate(
      id = id, 
      n = data$N
      ) %>%
    select(id, n, everything()) %>%
    # add useful model information
    mutate(
      maxRhat = max(fit$summary()$rhat, na.rm = TRUE),
      numDivergences = sum(fit$sampler_diagnostics()[,,"divergent__"]),
      totalTimeSecs = fit$time()$total
    )
}