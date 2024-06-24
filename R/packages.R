options(tidyverse.quiet = TRUE)
library(crew.cluster)
library(targets)
library(tarchetypes)
library(tidyverse)
tar_option_set(
  packages = c(
    "ape","cmdstanr","coevolve","knitr","papaja",
    "phaseR","posterior","tidybayes","tidyverse"
    )#,
  #controller = crew_controller_slurm(
  #  name = "coevolveSim",
  #  workers = 1,
  #  script_lines = "module load R",
  #  slurm_time_minutes = 2880,
  #  slurm_memory_gigabytes_per_cpu = 1,
  #  slurm_cpus_per_task = 4
  #)
)
