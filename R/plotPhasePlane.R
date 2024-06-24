plotPhasePlane <- function(post) {
  # get distribution of latent variables among species
  median_X <- median(median(post$eta[1:100,1]))
  median_Y <- median(median(post$eta[1:100,2]))
  mad_X    <- mad(median(post$eta[1:100,1]))
  mad_Y    <- mad(median(post$eta[1:100,2]))
  low_X    <- median_X - mad_X*2.5 # -2.5 SD
  high_X   <- median_X + mad_X*2.5 # +2.5 SD
  low_Y    <- median_Y - mad_Y*2.5 # -2.5 SD
  high_Y   <- median_Y + mad_Y*2.5 # +2.5 SD
  # get parameter values
  A <- median(post$A)
  b <- median(post$b)
  sigma <- median(post$sigma)
  # function for flow field diagram
  OU <- function(t, y, parameters) {
    dy <- numeric(2)
    dy[1] <- y[1]*A[1,1] + y[2]*A[1,2] + b[1]
    dy[2] <- y[2]*A[2,2] + y[1]*A[2,1] + b[2]
    list(dy)
  }
  # set up canvas
  pdf(
    paste0("figures/phasePlane.pdf"), 
    width = 6,
    height = 6,
    pointsize = 12
    )
  par(pty = "s")
  # create flow field diagram
  OU.flowField <- 
    flowField(
      OU, 
      xlim = c(low_X - 0.2, high_X + 0.2), 
      ylim = c(low_Y - 0.2, high_Y + 0.2), 
      parameters = NA,
      add = FALSE, 
      xlab = "",
      ylab = "", 
      points = 12,
      col = "grey", 
      xaxt = 'n',
      yaxt = 'n', 
      arrow.type = "proportional", 
      frac = 1.5,
      xaxs = "i", 
      yaxs = "i", 
      axes = FALSE,
      lwd = 2
    )
  mtext(
    side = 1,
    "X (z-score)",
    at = median_X,
    line = 2.5,
    cex = 1.3
    )
  mtext(
    side = 2,
    "Y (z-score)",
    at = median_Y,
    line = 2.5,
    cex = 1.3
    )
  # add nullclines to phase plane
  nc <- 
    nullclines(
      OU, 
      xlim = c(low_X, high_X),
      ylim = c(low_Y, high_Y), 
      parameters = NA,
      points = 20, 
      axes = FALSE,
      col = c("#F8766D","#00BFC4"),
      add.legend = FALSE,
      lwd = 4
      )
  # add axes
  axis(
    1,
    at = c(low_X, median_X, high_X),
    labels = (c(low_X, median_X, high_X) - median_X) / mad_X
    )
  axis(
    2,
    at = c(low_Y, median_Y, high_Y),
    labels = (c(low_Y, median_Y, high_Y) - median_Y) / mad_Y
    )
  dev.off()
}