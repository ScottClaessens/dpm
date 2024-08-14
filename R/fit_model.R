fit_model <- function(model, sim, output_dir = getOption("cmdstanr_output_dir")) {
  # get data for stan
  sd <-
    coevolve::coev_make_standata(
      data = sim$data,
      variables = list(
        x = "normal",
        y = "normal"
      ),
      id = "species",
      tree = sim$tree
    )
  # fit model
  fit <- 
    model$sample(
      data = sd,
      chains = 4,
      parallel_chains = 4,
      output_dir = output_dir,
      iter_warmup = 2000,
      iter_sampling = 2000,
      seed = 1L
    )
  # return object of class 'coevfit'
  out <-
    list(
      fit = fit,
      data = sim$data,
      data_name = deparse(substitute(sim$data)),
      variables = list(x = "normal", y = "normal"),
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
