#!/bin/bash
# export TF_ENABLE_ONEDNN_OPTS=0
#A typical run takes couple of hours but may be much longer
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
#SBATCH --mail-user=yutingliu@hsph.harvard.edu

module load python/3.10.9-fasrc01
conda activate alphapulldown_new

fasta_paths=$1
data_dir=$2
data_dir_default="/n/holylfs04-ssd2/LABS/FAS/alphafold_database"
if [ -z "$2" ]; then
        data_dir="$data_dir_default"
else
        data_dir="$2"
fi
output_dir=$3

create_individual_features.py \
  --fasta_paths="$fasta_paths" \
  --data_dir="$data_dir" \
  --save_msa_files=False \
  --output_dir="$output_dir" \
  --use_precomputed_msas=False \
  --use_mmseqs2=True \
  --max_template_date=2050-01-01 \
  --skip_existing=True \
  --seq_index=$SLURM_ARRAY_TASK_ID
