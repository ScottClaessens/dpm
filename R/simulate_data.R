simulate_data <- function(n, id = NULL) {
  # set arguments for simulation
  variables <- c("Promiscuity", "SpermSize")
  selection_matrix <- 
    matrix(
      c(0.90, 0.00, # promiscuity -> spermsize but not vice versa
        0.2, 0.90),
      nrow = 2,
      ncol = 2,
      byrow = TRUE,
      dimnames = list(variables, variables)
    )
  drift <- c(
    "Promiscuity" = 0.05,
    "SpermSize"   = 0.05
    )
  
  sim_list <- list()
  
  # use function in coevolve package to return simulate data
  sim_list$sim_data = coevolve::coev_simulate_coevolution(
    n, variables, selection_matrix, drift, prob_split = 0.05
  )

  # # calculate equilbria and standardized changes in equilibria
  # # Function to solve the discrete-time Lyapunov equation
  # lyapunov <- function(A, Omega) {
  #   return(solve(diag(nrow(A)^2) - kronecker(A, A)) %*% as.vector(Omega))
  #   }
  # Sigma <- matrix(lyapunov(selection_matrix, diag(drift)), nrow = nrow(selection_matrix), byrow = TRUE)
  
  median_prom <- median(sim_list$sim_data$data$Promiscuity)
  median_sperm <- median(sim_list$sim_data$data$SpermSize)

  mad_prom <- mad(sim_list$sim_data$data$Promiscuity) # sd of promiscuity 
  mad_sperm <- mad(sim_list$sim_data$data$SpermSize) # sd of sperm size

  delta_theta_prom_sperm <- ( ((selection_matrix[2,1]*(median_prom + mad_prom))/(1 - selection_matrix[2,2])) - ((selection_matrix[2,1]*(median_prom))/(1 - selection_matrix[2,2])) ) / mad_sperm

  delta_theta_sperm_prom <- ( ((selection_matrix[1,2]*(median_sperm + mad_sperm))/(1 - selection_matrix[1,1])) - ((selection_matrix[1,2]*(median_sperm))/(1 - selection_matrix[1,1])) ) / mad_prom

  sim_list$equilibria <- data.frame(
    Direction = c("Promiscuity -> Sperm size", "Sperm size -> Promiscuity"),
    value = c(delta_theta_prom_sperm, delta_theta_sperm_prom)
  )

  return(sim_list)
}
