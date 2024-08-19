simulate_data <- function(n, id = NULL) {
  # set arguments for simulation
  variables <- c("Promiscuity", "SpermSize")
  selection_matrix <- 
    matrix(
      c(0.90, 0.00, # promiscuity -> spermsize but not vice versa
        0.85, 0.90),
      nrow = 2,
      ncol = 2,
      byrow = TRUE,
      dimnames = list(variables, variables)
    )
  drift <- c(
    "Promiscuity" = 0.05,
    "SpermSize"   = 0.05
    )
  # use function in coevolve package to return simulate data
  coevolve::coev_simulate_coevolution(
    n, variables, selection_matrix, drift, prob_split = 0.05
  )
}
