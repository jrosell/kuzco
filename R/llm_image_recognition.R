#' Image Recognition using LLMs
#'
#' @param llm_model         a local LLM model pulled from ollama
#' @param image             a local image path that has a jpeg, jpg, or png
#' @param recognize_object  an item you want to LLM to look for
#' @param backend           either 'ollamar' or 'ellmer'
#' @param ...               a pass through for other generate args and model args like temperature. set the temperature to 0 for more deterministic output
#'
#' @return a df with object_recognized, object_count, object_description, object_location
#' @export
llm_image_recognition <- \(llm_model        = "llava-phi3",
                           image            = system.file("img/test_img.jpg", package = "kuzco"),
                           recognize_object = "face",
                           backend          = "ellmer",
                           ...){

  system_prompt <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/system-prompt-recognition.md")) |> paste(collapse = "\n")
  image_prompt  <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/image-prompt.md"))  |> paste(collapse = "\n")

  image_prompt  <- base::gsub(
    pattern = ":",
    replacement = paste0(", the object to look for is a ", recognize_object, ":"),
    x = image_prompt
  )

  if(backend == 'ollamar'){

    kuzco:::ollamar_image_recognition(llm_model     = llm_model,
                                      image_prompt  = image_prompt,
                                      image         = image,
                                      system_prompt = system_prompt,
                                      ...)

  } else if(backend == 'ellmer'){

    kuzco:::ellmer_image_recognition(llm_model     = llm_model,
                                     image_prompt  = image_prompt,
                                     image         = image,
                                     system_prompt = system_prompt,
                                     ...)

  } else {

    print('incorrect backend selection')

  }

}


ollamar_image_recognition <- \(llm_model     = llm_model,
                               image_prompt  = image_prompt,
                               image         = image,
                               system_prompt = system_prompt,
                               ...){


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

ellmer_image_recognition <- \(llm_model     = llm_model,
                              image_prompt  = image_prompt,
                              image         = image,
                              system_prompt = system_prompt,
                              ...){


  # add a switch for other llm providers ?
  chat <- ellmer::chat_ollama(
    model         = llm_model,
    system_prompt = system_prompt,
    ...
  )


  type_image_class <- ellmer::type_object(
    object_recognized        = ellmer::type_string(),
    object_count             = ellmer::type_integer(),
    object_description       = ellmer::type_string(),
    object_location          = ellmer::type_string()
  )

  image_summary <- ellmer::type_object(
    img_class = ellmer::type_array(items = type_image_class)
  )

  llm_df <- chat$extract_data(
    image_prompt, ellmer::content_image_file(image),
    type = image_summary
  )

  return(llm_df$img_class)

}
