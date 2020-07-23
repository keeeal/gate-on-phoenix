#!/bin/bash
#SBATCH	--job-name="name"
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=01:00:00
#SBATCH --mem=512MB
#SBATCH --array=1-64

# notifications
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=a1234567@adelaide.edu.au

# load modules
module load GATE/8.2-foss-2016b-c11-Python-2.7.13

# run
./run.sh ${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}