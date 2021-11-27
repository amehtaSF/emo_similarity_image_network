
all: analysis
	

FORCE:

clean:
	find results -name "*.html" -type f -delete; find results -name "*.pdf" -type f -delete;


# -- Analyze data -- #

analysis: results/sum21/network_analysis_explore.html

results/network_analysis_explore.html: src/analysis/sum21/network_analysis_explore.Rmd \
data/proc/sum21/emo_similarity_network_presurvey_sum2021_proc.csv \
data/proc/sum21/emoSimilarityTask_proc.csv
	Rscript -e 'rmarkdown::render("$<", output_dir="results")'

# -- Preprocess data -- #

preproc: data/proc/sum21/emo_similarity_network_presurvey_sum2021_proc.csv \
data/proc/emoSimilarityTask_proc.csv

data/proc/sum21/emo_similarity_network_presurvey_sum2021_proc.csv: src/preproc/sum21/preproc_surveys.Rmd \
data/raw/sum21/emo_similarity_network_presurvey_sum2021/emo_similarity_network_presurvey_sum2021_value_codebook.csv \
data/raw/sum21/emo_similarity_network_presurvey_sum2021/emo_similarity_network_presurvey_sum2021_var_codebook.csv
	Rscript -e 'rmarkdown::render("$<")'

data/proc/sum21/emoSimilarityTask_proc.csv: src/preproc/preproc_emoSimilarityTask.Rmd
	Rscript -e 'rmarkdown::render("$<")'

