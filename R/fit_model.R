fit_model <- function(model, sim, output_dir = getOption("cmdstanr_output_dir")) {
  # get data for stan
  sd <-
    coevolve::coev_make_standata(
      data = sim$data,
      variables = list(
        Promiscuity = "normal",
        SpermSize   = "normal"
      ),
      id = "species",
      tree = sim$tree
    )
  # fit model
  fit <- 
    model$sample(
      data = sd,
      chains = 8,
      parallel_chains = 8,
      output_dir = output_dir,
      iter_warmup = 250,
      iter_sampling = 250,
      adapt_delta = 0.99,
      seed = 1L
    )
  # return object of class 'coevfit'
  out <-
    list(
      fit = fit,
      data = sim$data,
      data_name = deparse(substitute(sim$data)),
      variables = list(
        Promiscuity = "normal",
        SpermSize   = "normal"
        ),
      id = "species",
      tree = sim$tree,
      stan_code = model$code(),
      stan_data = sd,
      effects_mat = sd$effects_mat,
      dist_mat = sd$dist_mat,
      scale = TRUE,
      prior_only = FALSE
    )
  class(out) <- "coevfit"
  return(out)
}
