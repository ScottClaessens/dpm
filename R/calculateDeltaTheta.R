calculateDeltaTheta <- function(draws, data, resp) {
  # get variables
  A <- draws$A
  b <- draws$b
  # medians and median absolute deviations for both variables
  x <- draws$eta[1:data$N,1]
  y <- draws$eta[1:data$N,2]
  med_x <- rvar_median(x)
  med_y <- rvar_median(y)
  diff_x <- rvar_mad(x) 
  diff_y <- rvar_mad(y)
  # calculate delta theta
  if (resp == "x") {
    
    med_theta <- -(med_y*A[1,2] + b[1]) / A[1,1]
    diff_theta <- -((med_y + diff_y)*A[1,2] + b[1]) / A[1,1]
    return( (diff_theta - med_theta) / diff_x )
    
  } else if (resp == "y") {
    
    med_theta <- -(med_x*A[2,1] + b[2]) / A[2,2]
    diff_theta <- -((med_x + diff_x)*A[2,1] + b[2]) / A[2,2]
    return( (diff_theta - med_theta) / diff_y )
    
  }
}
