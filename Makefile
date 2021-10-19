
all: analysis
	

FORCE:

clean:
	find results -name "*.html" -type f -delete; find results -name "*.pdf" -type f -delete;


# -- Analyze data -- #

analysis: results/network_analysis_explore.html

results/network_analysis_explore.html: src/analysis/network_analysis_explore.Rmd \
data/proc/emo_similarity_network_presurvey_sum2021_proc.csv \
data/proc/emoSimilarityTask_proc.csv
	Rscript -e 'rmarkdown::render("$<", output_dir="results")'

# -- Preprocess data -- #

preproc: data/proc/emo_similarity_network_presurvey_sum2021_proc.csv \
data/proc/emoSimilarityTask_proc.csv

data/proc/emo_similarity_network_presurvey_sum2021_proc.csv: src/preproc/preproc_surveys.Rmd \
data/raw/emo_similarity_network_presurvey_sum2021/emo_similarity_network_presurvey_sum2021_value_codebook.csv \
data/raw/emo_similarity_network_presurvey_sum2021/emo_similarity_network_presurvey_sum2021_var_codebook.csv
	Rscript -e 'rmarkdown::render("$<")'

data/proc/emoSimilarityTask_proc.csv: src/preproc/preproc_emoSimilarityTask.Rmd
	Rscript -e 'rmarkdown::render("$<")'


# -- Gather data -- #

#gather: FORCE
#	bash src/gather/gather.sh;
	
#doc/codebook.xlsx: src/gather/gather.sh
#	bash src/gather/gather.sh;

#data/raw/%.csv: src/gather/gather.sh
#	bash src/gather/gather.sh;
