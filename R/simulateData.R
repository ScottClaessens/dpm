simulateData <- function(n, id) {
  # set arguments for simulation
  variables <- c("x","y")
  selection_matrix <- 
    matrix(
      c(0.95, 0.00, # x -> y but not vice versa
        0.95, 0.95),
      nrow = 2,
      ncol = 2,
      byrow = TRUE,
      dimnames = list(variables, variables)
    )
  drift <- c(
    "x" = 0.05,
    "y" = 0.05
    )
  # use function in coevolve package to simulate data
  sim <- coevolve::coev_simulate_coevolution(
    n, variables, selection_matrix, drift, prob_split = 0.05
  )
  # return data list for stan model
  coevolve::coev_make_standata(
    data = sim$data,
    variables = list(
      x = "normal",
      y = "normal"
    ),
    id = "species",
    tree = sim$tree
  )
}
