
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kuzco

<!-- badges: start -->
<!-- badges: end -->

{kuzco} is a simple vision boilerplate built for ollama in R, on top of
{ollamar}. {kuzco} is designed as a computer vision assistant, giving
local models guidance on classifying images and return structured data.
The goal is to standardize outputs for image classification and use LLMs
as an alternative option to keras or torch. ({elmer} support TBD)

## Installation

You can install the development version of kuzco like so:

``` r
devtools::install_github("frankiethull/kuzco")
```

## Example

This is a basic example which shows you how to use kuzco.

``` r
library(kuzco)
library(ollamar)
#> Warning: package 'ollamar' was built under R version 4.4.2
#> 
#> Attaching package: 'ollamar'
#> The following object is masked from 'package:stats':
#> 
#>     embed
#> The following object is masked from 'package:methods':
#> 
#>     show
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following object is masked from 'package:ollamar':
#> 
#>     pull
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

llm_results <- llm_image_classification(llm_model = "llava-phi3", image = "inst/img/test_img.jpg")
```

``` r
llm_results |> tibble::as_tibble()
#> # A tibble: 1 × 7
#>   image_classification primary_object secondary_object image_description        
#>   <chr>                <chr>          <chr>            <chr>                    
#> 1 puppy                dog            eyes             A black and white puppy …
#> # ℹ 3 more variables: image_colors <chr>, image_proba_names <list>,
#> #   image_proba_values <list>
```

``` r
llm_results |> str()
#> 'data.frame':    1 obs. of  7 variables:
#>  $ image_classification: chr "puppy"
#>  $ primary_object      : chr "dog"
#>  $ secondary_object    : chr "eyes"
#>  $ image_description   : chr "A black and white puppy with a red plaid blanket behind it. The puppy is looking at the camera."
#>  $ image_colors        : chr "#006532, #9C1B4F, #3F4D88"
#>  $ image_proba_names   :List of 1
#>   ..$ : chr "puppy, eyes, nose, mouth, ear"
#>  $ image_proba_values  :List of 1
#>   ..$ : chr "0.71, 0.16, 0.65, 0.23, 0.69, 0.84"
```
