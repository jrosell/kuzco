#' Image Recognition using LLMs
#'
#' @param llm_model         a local LLM model pulled from ollama
#' @param image             a local image path that has a jpeg, jpg, or png
#' @param recognize_object  an item you want to LLM to look for
#' @param ...               a pass through for other generate args and model args like temperature. set the temperature to 0 for more deterministic output
#'
#' @return a df with object_recognized, object_count, object_description, object_location
#' @export
llm_image_recognition <- \(llm_model = "llava-phi3",
                           image = system.file("img/test_img.jpg", package = "kuzco"),
                           recognize_object = "face",
                           ...){

  system_prompt <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/system-prompt-recognition.md")) |> paste(collapse = "\n")
  image_prompt  <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/image-prompt.md"))  |> paste(collapse = "\n")

  image_prompt  <- base::gsub(
                    pattern = ":",
                    replacement = paste0(", the object to look for is a ", recognize_object, ":"),
                    x = image_prompt
                    )

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
