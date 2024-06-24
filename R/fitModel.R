fitModel <- function(model, data) {
  # fit model
  fit <- model$sample(
    data = data,
    chains = 4,
    parallel_chains = 4,
    output_dir = "out",
    iter_warmup = 2000,
    iter_sampling = 2000,
    adapt_delta = 0.99,
    seed = 1L
    )
  return(fit)
}
