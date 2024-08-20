bind_sbc_results <- function(sbc_results) {
  # loop over list and bind results
  out <- sbc_results[[1]]
  for (i in 2:length(sbc_results)) {
    out <- SBC::bind_results(out, sbc_results[[i]])
  }
  return(out)
}