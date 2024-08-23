compile_model <- function() {
  # generate dummy data and phylogenetic tree
  n <- 20
  tree <- ape::rcoal(n)
  d <- 
    data.frame(
      id = tree$tip.label,
      Promiscuity = rnorm(n),
      SpermSize   = rnorm(n)
    )
  # make stan code 
  scode <- 
    coevolve::coev_make_stancode(
      data = d,
      variables = list(
        Promiscuity = "normal",
        SpermSize   = "normal"
      ),
      id = "id",
      tree = tree
    )
  # write stan code to file
  file <- 
    cmdstanr::write_stan_file(
      scode,
      dir = "stan",
      basename = "model"
      )
  # compile model
  cmdstanr::cmdstan_model(
    stan_file = file
    )
}
