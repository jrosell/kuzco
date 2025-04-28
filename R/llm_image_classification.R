#' Image Classification using LLMs
#'
#' @param llm_model  a local LLM model pulled from ollama
#' @param image      a local image path that has a jpeg, jpg, or png
#' @param backend    either 'ollamar' or 'ellmer'
#' @param ...        a pass through for other generate args and model args like temperature
#'
#' @return a df with image_classification, primary_object, secondary_object, image_description, image_colors, image_proba_names, image_proba_values
#' @export
llm_image_classification <- \(
	llm_model = "llava-phi3",
	image = system.file("img/test_img.jpg", package = "kuzco"),
	backend = "ellmer",
	...
) {
	system_prompt <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/system-prompt-classification.md")) |>
		paste(collapse = "\n")
	image_prompt <- base::readLines(paste0(.libPaths()[1], "/kuzco/prompts/image-prompt.md")) |> paste(collapse = "\n")

	if (backend == 'ollamar') {
		kuzco:::ollamar_image_classification(
			llm_model = llm_model,
			image_prompt = image_prompt,
			image = image,
			system_prompt = system_prompt,
			...
		)
	} else if (backend == 'ellmer') {
		kuzco:::ellmer_image_classification(
			llm_model = llm_model,
			image_prompt = image_prompt,
			image = image,
			system_prompt = system_prompt,
			...
		)
	} else {
		print('incorrect backend selection')
	}
}

ollamar_image_classification <- \(
	llm_model = llm_model,
	image_prompt = image_prompt,
	image = image,
	system_prompt = system_prompt,
	...
) {
	llm_json <- ollamar::generate(
		model = llm_model,
		prompt = image_prompt,
		images = image,
		system = system_prompt,
		output = "text",
		...
	)

	llm_parsed <- llm_json |>
		jsonlite::parse_json()

	llm_df <- llm_parsed |>
		as.data.frame() |>
		dplyr::select(image_classification:image_colors)

	image_proba_nms <- llm_parsed$image_proba_names
	image_proba_val <- llm_parsed$image_proba_values

	llm_df <- llm_df |>
		dplyr::mutate(
			image_proba_names = list(image_proba_nms),
			image_proba_values = list(image_proba_val)
		)

	return(llm_df)
}

ellmer_image_classification <- \(
	llm_model = llm_model,
	image_prompt = image_prompt,
	image = image,
	system_prompt = system_prompt,
	...
) {
	# add a switch for other llm providers ?
	chat <- ellmer::chat_ollama(
		model = llm_model,
		system_prompt = system_prompt,
		...
	)

	type_image_class <- ellmer::type_object(
		image_classification = ellmer::type_string(),
		primary_object = ellmer::type_string(),
		secondary_object = ellmer::type_string(),
		image_description = ellmer::type_string(),
		image_colors = ellmer::type_string(),
		image_proba_names = ellmer::type_string(),
		image_proba_values = ellmer::type_string()
	)

	image_summary <- ellmer::type_object(
		img_class = ellmer::type_array(items = type_image_class)
	)

	llm_df <- chat$extract_data(
		image_prompt,
		ellmer::content_image_file(image),
		type = image_summary
	)

	return(llm_df$img_class)
}
