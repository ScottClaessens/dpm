plot_sbc_ecdf_diff <- function(results_coev) {
  # plot ECDF difference
  out <-
    SBC::plot_ecdf_diff(results_coev) + 
    scale_y_continuous(limits = c(-0.17, 0.17)) + 
    ylab("ECDF difference") + 
    xlab("Fractional rank") + 
    theme_classic() + 
    theme(strip.background = element_blank())
  # save
  ggsave(
    filename = here::here("figures/simulation_based_calibration/ecdf_difference.pdf"),
    plot = out,
    width = 7,
    height = 5
  )
  return(out)
}
