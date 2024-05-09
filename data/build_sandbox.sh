#!/bin/bash
#SBATCH --job-name=msa
#SBATCH --time=4:00:00

#log files:
#SBATCH -e "/n/home10/ytingliu/alphapulldown_new/logs/%A_%a_err.txt"
#SBATCH -o "/n/home10/ytingliu/alphapulldown_new/logs/%A_%a_out.txt"

#qos sets priority
#SBATCH --qos=high

#Limit the run to a single node
#SBATCH -N 1

#Adjust this depending on the node
#SBATCH --ntasks=8
#SBATCH --mem=256000
#SBATCH --mail-type=END
#SBATCH --mail-user=yourname@email.domain

sandbox_path=$1
sif_path=$2

singularity build --sandbox "$sandbox_path" "$sif_path"
