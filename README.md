# Causal inference and the detection of co-evolutionary contingencies using dynamic phylogenetic models

This repository contains the code for the paper "Causal inference and the 
detection of co-evolutionary contingencies using dynamic phylogenetic models".

## Getting started

### Installation guide

To run this code, you will need to [install R](https://www.r-project.org/) and
install the following packages:

```
install.packages(c("ape","knitr","ggdist","papaja","phaseR","posterior",
                   "tarchetypes","targets","tidyverse"))
```

You will also need to install the `cmdstanr` package using the following code
(see full installation instructions here: <https://mc-stan.org/cmdstanr/>).

``` r
install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))
```

Finally, you must install the development versions of the `SBC` and `coevolve` 
packages with:

``` r
# install.packages("devtools")
devtools::install_github("ScottClaessens/coevolve")
devtools::install_github("hyunjimoon/SBC")
```

### Executing code

1. Set the working directory to this code repository `setwd("myPath/dpm")`
2. Load the `targets` package with `library(targets)`
3. To run the analysis pipeline, run `tar_make()`
4. To load individual targets into your environment, run `tar_load()` etc.

## Help

Any issues, please email scott.claessens@gmail.com.

## Authors

Scott Claessens, scott.claessens@gmail.com
