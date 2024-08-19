plot_synthetic_example <- function(fit, delta_theta_promiscuity,
                                   delta_theta_spermsize) {
  # plot cichlid species
  pA <-
    ggdraw() +
    draw_image(
      image = "figures/cichlids/cichlids.png",
      scale = 0.95
      )
  # plot delta theta
  pB <- 
    tibble(
      post = c(
        as.numeric(delta_theta_promiscuity),
        as.numeric(delta_theta_spermsize)
        ),
      Direction = rep(
        c("Sperm size -> Promiscuity",
          "Promiscuity -> Sperm size"), 
        each = length(delta_theta_promiscuity)
        )
    ) %>%
    ggplot(aes(x = post, fill = Direction)) +
    stat_slab(alpha = 0.8) +
    scale_x_continuous(
      name = expression(paste(Delta, theta[z])),
      limits = c(-5, 15),
      expand = c(0, 0)
    ) +
    scale_fill_manual(values = c("#c55852", "#5387b6")) +
    theme_classic() +
    theme(
      axis.title.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.line.y = element_blank(),
      axis.text.y = element_blank(),
      legend.position = c(0.72, 0.8),
      plot.margin = margin(0, 5, 2, 5, "mm"),
      legend.text = element_text(size = 7),
      legend.title = element_text(size = 7),
      legend.key.size = unit(3, "mm")
    )
  # plot phase plane
  png(
    paste0("figures/cichlids/phase_plane.png"),
    height = 12,
    width = 12,
    units = "cm",
    res = 1200
    )
  coevolve::coev_plot_flowfield(
    object = fit,
    var1 = "Promiscuity",
    var2 = "SpermSize",
    nullclines = TRUE
  )
  dev.off()
  pC <-
    ggdraw() + 
      draw_image(
        image = "figures/cichlids/phase_plane.png"
        ) +
      draw_image(
        image = "figures/cichlids/low_sperm_size.png",
        scale = 0.15,
        x = -0.40,
        y = -0.27
        ) +
      draw_image(
        image = "figures/cichlids/high_sperm_size.png",
        scale = 0.25,
        x = -0.43,
        y =  0.31
      ) +
      draw_image(
        image = "figures/cichlids/low_promiscuity.png",
        scale = 0.15,
        x = -0.25,
        y = -0.41
      ) +
      draw_image(
        image = "figures/cichlids/high_promiscuity.png",
        scale = 0.15,
        x =  0.35,
        y = -0.41
      )
  # put together
  out <-
    plot_grid(
      pA, pB, NULL, pC,
      nrow = 1,
      labels = c("a", "b", "", "c"),
      rel_widths = c(0.7, 1, 0.1, 1.2)
    )
  ggsave(
    plot = out,
    filename = "figures/cichlids/synthetic.pdf",
    width = 7,
    height = 3
    )
  return(out)
}