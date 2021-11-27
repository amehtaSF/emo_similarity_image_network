
if(!require(statnet)) install.packages("statnet")
if(!require(ergm)) install.packages("ergm")
if(!require(stringr)) install.packages("stringr")
if(!require(stringr)) install.packages("foreach")
if(!require(stringr)) install.packages("doParallel")
library(statnet)
library(stringr)
library(ergm)
library(foreach)
library(doParallel)

args <-  commandArgs(trailingOnly=TRUE)


# Get files
if(is.null(args))
{
  statnet_graph_dir <- "data/proc/statnetGraphs"
} else {
  statnet_graph_dir <- args[1]
}

graph_rds_files <- list.files(statnet_graph_dir, full.names = TRUE)


# Define model fitting function
fit_save_model <- function(rds_file, n_cores){
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
  saveRDS(fit, file=paste0("ergmFit", "_", basename(rds_file)))
  return(summary(fit))
}

# Create cluster
n_cores <- detectCores()

#create the cluster
myCluster <- parallel::makeCluster(
  n_cores, 
  type = "PSOCK"
)


# print(myCluster)
# 
doParallel::registerDoParallel(cl = myCluster)
# foreach::getDoParRegistered()
# foreach::getDoParWorkers()

# Fit models in parallel
x <- foreach(
  i = 1:length(graph_rds_files), 
  .combine = "c"
) %dopar% {
  fit_save_model(rds_file=graph_rds_files[i], n_cores=n_cores)
}

# Stop cluster
parallel::stopCluster(cl = myCluster)

