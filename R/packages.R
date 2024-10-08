options(tidyverse.quiet = TRUE)
library(crew.cluster)
library(targets)
library(tarchetypes)
library(tidyverse)
tar_option_set(
  packages = c(
    "ape","bookdown","cmdstanr","coevolve","cowplot","knitr",
    "magick","phaseR","posterior","SBC","tidybayes","tidyverse"
    )#,
  #controller = crew_controller_slurm(
  #  name = "dpm",
  #  workers = 50,
  #  script_lines = "module load R",
  #  slurm_time_minutes = 60*12,
  #  slurm_memory_gigabytes_per_cpu = 8,
  #  slurm_cpus_per_task = 4
  #)
)
