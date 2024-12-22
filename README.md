
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kuzco <img src="man/figures/logo.png" align="right" height="108" alt="" />

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
```

here we have an image and want to learn about it:

``` r
test_img <- file.path(system.file(package = "kuzco"), "img/test_img.jpg") 
```

![picture of puppy odin circa
2019.](https://raw.githubusercontent.com/frankiethull/kuzco/refs/heads/main/inst/img/test_img.jpg)

### llm for image classification:

``` r
llm_results <- llm_image_classification(llm_model = "llava-phi3", image = test_img)
```

``` r
llm_results |> tibble::as_tibble()
#> # A tibble: 1 × 7
#>   image_classification primary_object secondary_object image_description        
#>   <chr>                <chr>          <chr>            <chr>                    
#> 1 puppy                dog            ear              A puppy with black and w…
#> # ℹ 3 more variables: image_colors <chr>, image_proba_names <list>,
#> #   image_proba_values <list>
```

``` r
llm_results |> str()
#> 'data.frame':    1 obs. of  7 variables:
#>  $ image_classification: chr "puppy"
#>  $ primary_object      : chr "dog"
#>  $ secondary_object    : chr "ear"
#>  $ image_description   : chr "A puppy with black and white fur."
#>  $ image_colors        : chr "#909091, #ffffff, #763c2f, #8fbc8b, #e6c774, #a3ca8d, #354a88, #8faec8"
#>  $ image_proba_names   :List of 1
#>   ..$ : chr "puppy, black, white, fur, ear, snout, eye, nose"
#>  $ image_proba_values  :List of 1
#>   ..$ : chr "0.62, 0.21, 0.75, 0.43, 0.89, 0.67, 0.38, 0.45"
```

### llm for image sentiment:

``` r
llm_emotion <- llm_image_sentiment(llm_model = "llava-phi3", image = test_img)

llm_emotion |> str()
#> 'data.frame':    1 obs. of  4 variables:
#>  $ image_sentiment      : chr "neutral"
#>  $ image_score          : num 0.52
#>  $ sentiment_description: chr "The dog appears curious and attentive."
#>  $ image_keywords       : chr "curious, attentive, eyes"
```

### llm for image recognition:

``` r
llm_detection <- llm_image_recognition(llm_model = "llava-phi3", 
                                       image = test_img,
                                       recognize_object = "nose")

llm_detection |> str()
#> 'data.frame':    1 obs. of  4 variables:
#>  $ object_recognized : chr "yes"
#>  $ object_count      : int 1
#>  $ object_description: chr "A small black and white dog's nose. It is right in between his eyes."
#>  $ object_location   : chr "middle of the face"
```
