#!/bin/bash

#SBATCH --job-name=pipeline_check   # Job name
#SBATCH --nodes=1                  # Run all processes on a single node	
#SBATCH --ntasks=1                 # Run a single task		
#SBATCH --cpus-per-task=4          # Number of CPU cores per task
#SBATCH --mem=4gb                  # Job memory request
#SBATCH --time=03:00:00            # Time limit hrs:min:sec
#SBATCH --output=/n/home10/ytingliu/pipeline_check.log   # Standard output and error log
#SBATCH --mail-type=END
#SBATCH --mail-user=yutingliu@hsph.harvard.edu

module load cuda/11.8.0-fasrc01
module load cudnn/8.9.2.26_cuda11-fasrc01
module load python/3.10.9-fasrc01
conda activate alphapulldown_new

python /n/home10/ytingliu/pipeline_check.py "$1" "$2" "$3" "$4"
