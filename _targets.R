targets::tar_source()

# pipeline
list(
  
  ### Synthetic data simulation
  
  # compile model
  tar_target(model, compile_model()),
  # fit example individual model
  tar_target(sim, simulate_data(n = 100)),
  tar_target(fit, fit_model(model, sim, output_dir = "out")),
  # plot figures
  tar_target(phase_plane, plot_phase_plane(fit)),
  tar_target(delta_theta, plot_delta_theta(fit)),
  # simulate data and fit separate models
  tar_target(id, 1:2),
  tar_map(
    # loop over different sample sizes
    values = tibble(n = c(5, 10)),
    tar_target(sim, simulate_data(n, id), pattern = map(id)),
    tar_target(results, fit_model_and_extract(model, sim, id), 
               pattern = map(sim, id))
  ),
  # combine results
  tar_target(results, bind_rows(results_5, results_10)),
  # summarise power
  tar_target(power, calculatePower(results)),
  
  ### Simulation-based calibration
  
  ### Life history and niche complexity model
  
  ### Manuscript
  
  # render manuscript
  tar_render(manuscript, "manuscript.Rmd"),
  
  ### Session info
  tar_target(
    session_info, 
    writeLines(capture.output(sessionInfo()), "session_info.txt")
  )
  
)
