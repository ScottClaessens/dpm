fit_model_and_extract <- function(model, sim, id = NULL) {
  # fit model
  fit <- fit_model(model, sim)
  # calculate delta theta for both variables
  delta_theta_x <- 
    coevolve::coev_calculate_delta_theta(
      object = fit,
      response = "x",
      predictor = "y"
      )
  delta_theta_y <- 
    coevolve::coev_calculate_delta_theta(
      object = fit,
      response = "y",
      predictor = "x"
      )
  # save summary
  tibble(
    direction = c(
      "X -> Y",
      "Y -> X"
      ),
    delta_theta = list(
      as.numeric(delta_theta_y),
      as.numeric(delta_theta_x)
      )
    ) %>%
    mutate(
      median = map(delta_theta, function(x) as.numeric(median(x))),
      lower  = map(delta_theta, function(x) as.numeric(quantile(x, 0.025))),
      upper  = map(delta_theta, function(x) as.numeric(quantile(x, 0.975)))
    ) %>%
    dplyr::select(-delta_theta) %>%
    unnest(c(median, lower, upper)) %>%
    # index model number and sample size
    mutate(id = id, n = nrow(sim$data)) %>%
    select(id, n, everything()) %>%
    # add useful model information
    mutate(
      max_rhat = max(fit$fit$summary()$rhat, na.rm = TRUE),
      num_divergences = sum(fit$fit$sampler_diagnostics()[,,"divergent__"]),
      total_time_secs = fit$fit$time()$total
    )
}