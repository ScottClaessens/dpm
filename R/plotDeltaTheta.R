plotDeltaTheta <- function(deltaThetaX, deltaThetaY) {
  # get delta theta as vector
  deltaThetaX <- as.numeric(as_draws_array(deltaThetaX))
  deltaThetaY <- as.numeric(as_draws_array(deltaThetaY))
  # plot posterior distribution
  out <- 
    tibble(
      post = c(deltaThetaX, deltaThetaY),
      Direction = rep(c("Y -> X", "X -> Y"), each = length(deltaThetaX))
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
  ggsave(out, filename = "figures/deltaTheta.pdf", height = 4, width = 4)
  return(out)
}
