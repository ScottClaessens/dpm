targets::tar_source()

# pipeline
list(
  
  ### Synthetic data simulation
  
  # compile model
  tar_target(model, compile_model()),
  # fit example individual model
  tar_target(sim, simulate_data(n = 500)),
  tar_target(fit, fit_model(model, sim$sim_data, output_dir = "out")),
  # get delta theta values
  tar_target(
    delta_theta_promiscuity,
    coevolve::coev_calculate_delta_theta(
      object = fit,
      response = "Promiscuity",
      predictor = "SpermSize"
    )
  ),
  tar_target(
    delta_theta_spermsize,
    coevolve::coev_calculate_delta_theta(
      object = fit,
      response = "SpermSize",
      predictor = "Promiscuity"
    )
  ),
  # plot synthetic example
  tar_target(
    plot_synthetic,
    plot_synthetic_example(fit, sim$equilibria, delta_theta_promiscuity, 
                           delta_theta_spermsize)
    ),
  # simulate data and fit separate models
  # tar_target(id, 1:100),
  # tar_map(
  #   # loop over different sample sizes
  #   values = tibble(n = c(20, 50, 100)),
  #   tar_target(sim, simulate_data(n, id), pattern = map(id)),
  #   tar_target(results, fit_model_and_extract(model, sim, id), 
  #              pattern = map(sim, id))
  # ),
  # # combine results
  # tar_target(results, bind_rows(results_20, results_50, results_100)),
  # # summarise power
  # tar_target(power, calculatePower(results)),
  
  ### Simulation-based calibration
  
  # model file
  tar_target(sbc_model_file, "stan/sbc_model.stan", format = "file"),
  # compile model
  tar_target(sbc_model, cmdstanr::cmdstan_model(sbc_model_file)),
  # prepare backend and generator
  tar_target(sbc_backend, prepare_sbc_backend(sbc_model)),
  tar_target(sbc_generator, prepare_sbc_generator(sbc_model)),
  # iterate over sbc_id batches
  tar_target(sbc_id, 1:50),
  # generate datasets
  tar_target(
    sbc_datasets,
    SBC::generate_datasets(sbc_generator, n_sims = 10),
    pattern = map(sbc_id),
    iteration = "list"
    ),
  # compute sbc
  tar_target(
    sbc_results,
    SBC::compute_SBC(sbc_datasets, sbc_backend),
    pattern = map(sbc_datasets, sbc_id),
    iteration = "list"
    ),
  # combine sbc results
  tar_target(sbc_results_combined, bind_sbc_results(sbc_results),
             deployment = "main"),
  # plot sbc results
  tar_target(plot_sbc1, plot_sbc_ecdf(sbc_results_combined)),
  tar_target(plot_sbc2, plot_sbc_ecdf_diff(sbc_results_combined)),
  
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
