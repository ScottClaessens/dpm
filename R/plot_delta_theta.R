plot_delta_theta <- function(fit) {
  # get delta theta values
  delta_theta_x <- 
    as.numeric(
      coevolve::coev_calculate_delta_theta(
        object = fit,
        response = "x",
        predictor = "y"
      )
    )
  delta_theta_y <- 
    as.numeric(
      coevolve::coev_calculate_delta_theta(
        object = fit,
        response = "y",
        predictor = "x"
      )
    )
  # plot posterior distribution
  out <- 
    tibble(
      post = c(delta_theta_x, delta_theta_y),
      Direction = rep(c("Y -> X", "X -> Y"), each = length(delta_theta_x))
    ) %>%
    ggplot(aes(x = post, fill = Direction)) +
    stat_slab(alpha = 0.8) +
    scale_x_continuous(
      name = expression(paste(Delta, theta[z])),
      limits = c(-10, 20),
      expand = c(0, 0)
    ) +
    theme_classic() +
    theme(
      axis.title.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.line.y = element_blank(),
      axis.text.y = element_blank(),
      legend.position = c(0.9, 0.8),
      plot.margin = margin(0, 5, 2, 5, "mm")
    )
  # save
  ggsave(out, filename = "figures/delta_theta.pdf", height = 4, width = 4)
  return(out)
}