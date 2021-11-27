#!/bin/bash
#
#SBATCH --job-name=ergm
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=2
#SBATCH --array=0-267:10
#SBATCH --partition=gross
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=2G

ml R

for i in {0..9}; do
    srun -n 1 --ncpus-per-task=2 --exclusive Rscript --vanilla single_pid_ergm_parallel.R statnetGraphs $((SLURM_ARRAY_TASK_ID+i)) &
done

wait # important to make sure the job doesn't exit before the background tasks are done
