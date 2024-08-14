plot_phase_plane <- function(fit) {
  # set up canvas
  pdf(
    paste0("figures/phase_plane.pdf"), 
    width = 6,
    height = 6,
    pointsize = 12
  )
  # plot flow field
  coevolve::coev_plot_flowfield(
    object = fit,
    var1 = "x",
    var2 = "y"
  )
  dev.off()
}
