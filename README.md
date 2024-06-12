# Testing Bayesian dynamic phylogenetic models using simulation

This project uses the [coevolve](https://github.com/ScottClaessens/coevolve)
package to assess the validity of inferences from Bayesian dynamic phylogenetic
models.

## Getting started

### Installation guide

To run this code, you will need to [install R](https://www.r-project.org/) and
install the following packages:

```
install.packages(c("tarchetypes","targets","tidyverse"))
```

You will also need to install the `cmdstanr` package using the following code
(see full installation instructions here: <https://mc-stan.org/cmdstanr/>).

``` r
install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))
```

Finally, you must install the development version of `coevolve` with:

``` r
# install.packages("devtools")
devtools::install_github("ScottClaessens/coevolve")
```

### Executing code

1. Set the working directory to this code repository `setwd("myPath/coevolveSim")`
2. Load the `targets` package with `library(targets)`
3. To run the analysis pipeline, run `tar_make()`
4. To load individual targets into your environment, run `tar_load()` etc.

## Help

Any issues, please email scott.claessens@gmail.com.

## Authors

Scott Claessens, scott.claessens@gmail.com
