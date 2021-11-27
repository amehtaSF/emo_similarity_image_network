#!/usr/bin/env Rscript --vanilla



args <- commandArgs(trailingOnly = TRUE)
# args[1] = rds file directory
# args[2] = ${SLURM_ARRAY_TASK_ID}


# Get files
if(is.null(args))
{
  statnet_graph_dir <- "data/proc/statnetGraphs"
} else {
  statnet_graph_dir <- args[1]
}

graph_rds_files <- list.files(statnet_graph_dir, full.names = TRUE)

sprintf("args[2]: %s", args[2])

INPUT_FILE <- graph_rds_files[as.integer(args[2])+1]
OUTPUT_FILE <- paste0("ergmFit", "_", basename(INPUT_FILE))

sprintf("INPUT_FILE: %s", INPUT_FILE)
sprintf("OUTPUT_FILE: %s", OUTPUT_FILE)


if(!file.exists(OUTPUT_FILE)){
 
  
  if(!require(statnet)) install.packages("statnet")
  if(!require(ergm)) install.packages("ergm")
  if(!require(stringr)) install.packages("stringr")
  if(!require(stringr)) install.packages("foreach")
  if(!require(stringr)) install.packages("doParallel")
  suppressMessages(suppressWarnings(library(stringr)))
  suppressMessages(suppressWarnings(library(statnet)))
  suppressMessages(suppressWarnings(library(ergm)))
  suppressMessages(suppressWarnings(library(foreach)))
  suppressMessages(suppressWarnings(library(doParallel)))
  
  # -- Define model fitting function -- #
  fit_model <- function(rds_file, n_cores){
    g <- readRDS(rds_file)
    fit <- ergm::ergm(
      g ~ edges + transitiveweights(),
      reference = ~Unif(0,1),
      response = "weight",
      control = ergm::control.ergm(
        MCMLE.termination="Hotelling",
        parallel=n_cores,
        parallel.type="PSOCK"
      )
    )
    return(fit)
  }
  
  
  # -- Make cluster -- #
  n_cores <- parallel::detectCores()
  
  sprintf("n_cores = %s", as.character(n_cores))
  
  myCluster <- parallel::makeCluster(
    n_cores,
    type = "PSOCK"
  )
  
  
  # print(myCluster)
  #
  doParallel::registerDoParallel(cl = myCluster)
  # foreach::getDoParRegistered()
  # foreach::getDoParWorkers()
  
  # -- Fit model -- #
  fit <- fit_model(rds_file=INPUT_FILE, n_cores=n_cores)
  saveRDS(fit, file=OUTPUT_FILE)
  
  
  # -- Shut down -- #
  parallel::stopCluster(cl = myCluster)
} else {
 sprintf("Output file %s exists. Skipping...", OUTPUT_FILE) 
}



