plot_sbc_ecdf <- function(results_coev) {
  # plot ECDF
  out <-
    SBC::plot_ecdf(results_coev) + 
    ylab("ECDF") + 
    xlab("Fractional rank") +
    theme_classic() + 
    theme(strip.background = element_blank())
  # save
  ggsave(
    filename = "figures/simulation_based_calibration/ecdf.pdf",
    plot = out,
    width = 7,
    height = 5
  )
  return(out)
}
