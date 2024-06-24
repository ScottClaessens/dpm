targets::tar_source()

# pipeline
list(
  ### Synthetic data simulation
  
  # compile model
  tar_target(model, compileModel()),
  # simulate data and fit models
  tar_target(id, 1:100),
  tar_map(
    # loop over different sample sizes
    values = tibble(n = c(20, 50, 100)),
    tar_target(data, simulateData(n, id), pattern = map(id)),
    tar_target(results, fitModelAndExtract(model, data, id), 
               pattern = map(data, id))
  ),
  # combine results
  tar_target(results, bind_rows(results_20, results_50, results_100)),
  # summarise results
  tar_target(power, calculatePower(results)),
  # fit example individual model
  tar_target(df, simulateData(n = 100, id = NULL)),
  tar_target(fit, fitModel(model, df)),
  tar_target(post, as_draws_rvars(fit)),
  # calculate delta theta values
  tar_target(deltaThetaX, calculateDeltaTheta(post, df, resp = "x")),
  tar_target(deltaThetaY, calculateDeltaTheta(post, df, resp = "y")),
  # plot delta theta
  tar_target(plotDT, plotDeltaTheta(deltaThetaX, deltaThetaY)),
  # plot phase plane
  tar_target(plotPP, plotPhasePlane(post)),
  
  ### Report
  
  # render report
  tar_render(report, "report.Rmd"),
  
  ### Session info
  tar_target(
    sessionInfo, 
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
