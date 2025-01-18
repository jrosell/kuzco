
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kuzco <img src="man/figures/logo.png" align="right" height="108" alt="" />

<!-- badges: start -->
<!-- badges: end -->

{kuzco} is a simple vision boilerplate built for ollama in R, on top of
{ollamar} & {ellmer}. {kuzco} is designed as a computer vision
assistant, giving local models guidance on classifying images and return
structured data. The goal is to standardize outputs for image
classification and use LLMs as an alternative option to keras or torch.

{kuzco} currently supports: classification, recognition, sentiment, and
text extraction.

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

<figure>
<img
src="https://raw.githubusercontent.com/frankiethull/kuzco/refs/heads/main/inst/img/test_img.jpg"
alt="picture of puppy odin circa 2019." />
<figcaption aria-hidden="true">picture of puppy odin circa
2019.</figcaption>
</figure>

### llm for image classification:

``` r
llm_results <- llm_image_classification(llm_model = "llava-phi3", image = test_img, 
                                        backend = 'ollamar')
```

``` r
llm_results |> tibble::as_tibble()
#> # A tibble: 1 × 7
#>   image_classification primary_object secondary_object image_description        
#>   <chr>                <chr>          <chr>            <chr>                    
#> 1 dog                  head           eyes             A black and white puppy …
#> # ℹ 3 more variables: image_colors <chr>, image_proba_names <list>,
#> #   image_proba_values <list>
```

``` r
llm_results |> str()
#> 'data.frame':    1 obs. of  7 variables:
#>  $ image_classification: chr "dog"
#>  $ primary_object      : chr "head"
#>  $ secondary_object    : chr "eyes"
#>  $ image_description   : chr "A black and white puppy is looking up at the camera."
#>  $ image_colors        : chr "#909091, #166AFA, #396E26"
#>  $ image_proba_names   :List of 1
#>   ..$ :List of 5
#>   .. ..$ : chr "dog"
#>   .. ..$ : chr "face"
#>   .. ..$ : chr "ears"
#>   .. ..$ : chr "paws"
#>   .. ..$ : chr "nose"
#>  $ image_proba_values  :List of 1
#>   ..$ :List of 4
#>   .. ..$ : num 0.54
#>   .. ..$ : num 0.32
#>   .. ..$ : num 0.87
#>   .. ..$ : num 0.16
```

### llm for image sentiment:

``` r
llm_emotion <- llm_image_sentiment(llm_model = "llava-phi3", image = test_img)

llm_emotion |> str()
#> 'data.frame':    3 obs. of  4 variables:
#>  $ image_sentiment      : chr  "positive" "neutral" "positive"
#>  $ image_score          : num  0.9 0.5 0.63
#>  $ sentiment_description: chr  "He is so cute!" "This photo contains a dog." "He is looking at the camera."
#>  $ image_keywords       : chr  "cute, adorable, small" "dog, puppy, pet" "smiling face, winking eye, happy"
```

### llm for image recognition:

``` r
llm_detection <- llm_image_recognition(llm_model = "llava-phi3", 
                                       image = test_img,
                                       recognize_object = "nose",
                                       backend  = "ollamar")

llm_detection |> str()
#> 'data.frame':    1 obs. of  4 variables:
#>  $ object_recognized : chr "yes"
#>  $ object_count      : int 1
#>  $ object_description: chr "Black and white puppy with brown eyes. Black nose."
#>  $ object_location   : chr "center of image"
```
