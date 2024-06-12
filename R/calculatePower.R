calculatePower <- function(pars) {
  pars %>%
    # keep cross-lagged effects only
    filter(variable %in% c("alpha[1,2]","alpha[2,1]")) %>%
    # summarise proportions of effects with credible intervals above zero
    group_by(n, variable) %>%
    summarise(prop = mean(q5 >= 0 & q5 >= 0), .groups = "drop") %>%
    # tidy output
    mutate(
      variable = ifelse(variable == "alpha[2,1]", "X → Y", "Y → X"),
      n = paste0("n = ", n)
      ) %>%
    rename(Variable = variable) %>%
    arrange(Variable) %>%
    pivot_wider(
      names_from = "n",
      values_from = "prop"
    )
}
