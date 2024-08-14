calculatePower <- function(results) {
  results %>%
    # remove non-converging models
    filter(max_rhat <= 1.1) %>%
    # summarise proportions of effects with credible intervals above zero
    group_by(n, direction) %>%
    summarise(prop = mean(lower >= 0 & upper >= 0), .groups = "drop") %>%
    # tidy output
    mutate(n = paste0("n = ", n)) %>%
    pivot_wider(
      names_from = "n",
      values_from = "prop"
    ) %>%
    rename(Direction = direction)
}
