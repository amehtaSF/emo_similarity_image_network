#/usr/bin/env bash

for filename in /statnetGraphs/*.rds; do
  Rscript -e 'rmarkdown::render("$filename", output_dir="results", output_file=""'
done