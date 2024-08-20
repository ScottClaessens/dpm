sbc_generator <- function(model, N) {
  # simulate tree
  tree <- ape::rcoal(N)
  # simulate data
  d_temp <- data.frame(
    x = rnorm(N, 0, 1),
    y = rbinom(N, 1, 0.5),
    id = tree$tip.label
  )
  # get data list for stan
  standat_temp <- 
    coevolve::coev_make_standata(
      data = d_temp,
      variables = list(
        x = "normal",
        y = "bernoulli_logit"
      ),
      id = "id",
      tree = tree,
      prior_only = TRUE
    )
  # number of samples
  n_samps <- 50
  # fit model
  sims <- model$sample(
    data = standat_temp,
    chains = 1,
    iter_sampling = n_samps,
    iter_warmup = n_samps
  )
  # get draws
  draws <- posterior::as_draws_rvars(sims$draws())
  A <- posterior::draws_of(draws$A)
  Q <- posterior::draws_of(draws$Q)
  b <- posterior::draws_of(draws$b)
  log_likelihood <- posterior::draws_of(draws$log_likelihood)
  x_sim <- posterior::draws_of(draws$yrep)[n_samps,,1]
  y_sim <- posterior::draws_of(draws$yrep)[n_samps,,2]
  # output list
  list(
    variables = list(
      "A[1,1]" = A[n_samps,1,1],
      "A[1,2]" = A[n_samps,1,2],
      "A[2,2]" = A[n_samps,2,2],
      "A[2,1]" = A[n_samps,2,1],
      "b[1]"   = b[n_samps,1],
      "b[2]"   = b[n_samps,2],
      "Q[1,1]" = Q[n_samps,1,1],
      "Q[2,2]" = Q[n_samps,2,2],
      "log_likelihood" = log_likelihood[n_samps]
    ),
    generated = coev_make_standata(
      data = data.frame(
        x = x_sim,
        y = as.integer(y_sim),
        id = tree$tip.label
        ),
      variables = list(
        x = "normal",
        y = "bernoulli_logit"
      ),
      id = "id",
      tree = tree,
      prior_only = FALSE
    )
  )
}