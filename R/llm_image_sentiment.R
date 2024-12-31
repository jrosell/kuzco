#' Image Sentiment using LLMs
#'
#' @param llm_model  a local LLM model pulled from ollama
#' @param image      a local image path that has a jpeg, jpg, or png
#' @param ...        a pass through for other generate args and model args like temperature. set the temperature to 0 for more deterministic output
#'
#' @return a df with image_sentiment, image_score, sentiment_description, image_keywords
#' @export
llm_image_sentiment <- \(llm_model = "llava-phi3",
                         image = system.file("img/test_img.jpg", package = "kuzco"),
                         ...){

  system_prompt <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/system-prompt-sentiment.md")) |> paste(collapse = "\n")
  image_prompt  <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/image-prompt.md"))  |> paste(collapse = "\n")


  llm_json <- ollamar::generate(
    model  = llm_model,
    prompt = image_prompt,
    images = image,
    system = system_prompt,
    output = "text",
    ...
  )

  llm_parsed <- llm_json |>
    jsonlite::parse_json()

  llm_df <- llm_parsed |>
    as.data.frame()

  return(llm_df)

}
