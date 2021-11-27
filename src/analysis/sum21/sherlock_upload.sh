#!/usr/bin/env bash

scp src/analysis/single_pid_ergm.Rmd ashm@sherlock.stanford.edu:~/emo_similarity_network/
scp src/analysis/multi_pid_ergm.Rmd ashm@sherlock.stanford.edu:~/emo_similarity_network/
scp src/analysis/multi_pid_ergm.R ashm@sherlock.stanford.edu:~/emo_similarity_network/
scp src/analysis/sherlock_run.sh ashm@sherlock.stanford.edu:~/emo_similarity_network/


rsync -a data/proc/statnetGraphs/ ashm@sherlock.stanford.edu:~/emo_similarity_network/statnetGraphs


