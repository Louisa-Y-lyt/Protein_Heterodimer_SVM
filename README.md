# Protein_Heterodimer_SVM
# A machine learning model for large-scale discovery of protein interactions with AlphaFold2

This project is to build a SVM model based on AlphaPulldown (https://github.com/KosinskiLab/AlphaPulldown) pipeline. This pipeline is based on AlphaFold 2. 

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Installation

This project used AlphaPulldown version 1.0.
Check Alphapulldown package's pre-installation and installzation part. Harvard FAS has pre-installed alphafold 2 database "/n/holylfs04-ssd2/LABS/FAS/alphafold_database". Make sure if all folders are updated to the newest version (https://github.com/google-deepmind/alphafold). 

## Usage

### Protein pairs collection

The Positive dataset is from PDB bank. The negative dataset is random paifr between Archaea and Homo Sapien (Uniprot). 

### Multiple sequence alignment (MSA)

Multiple sequence alignment (MSA) runs on CPUs. Alphapulldown accepts two MSA methods: the default AlphaFold version (slower), and the MMseq2 version (much faster). The accuracy of final prediction models depends on the MSA method chosen here. 
To run 500 protein sequence (not protein pairs) on Cannon in parallel, use ``msa.sh`` file with the following Slurm command:

```bash
sbatch --array=0-500 \
"/path/msa.sh" \
"/path/6000_tn_input.fasta" \
"" \ # Default usage of Harvard FAS Alphafold database
"/path/msa_outputs"
```

Normally, each MSA job takes ~15 minutes.

### Predict structures

Prediction step runs on GPU. To run 500 protein pairs (not protein sequences) on Cannon in parallel, use ``prediction.sh`` file with the following Slurm command:

```bash
sbatch --array=0-500 \
"/path/prediction.sh" \
"" \ Default custom mode
"/path/outputs/negative_0to500" \
"" \ # Default usage of Harvard FAS Alphafold database
"/path/6000_tn_pairs.txt"
"/path/msa_outputs"
```

Do not submit too many jobs at one time if finishing all jobs takes more than 5 hours. 

For each protein pair there will be 5 models generated based on different initiation locations. For each model it will take ~5 minutes when running in GPU.
You could check the usage of GPUs using: 
``sacct --format=JobID,Jobname,partition,state,time,start,end,elapsed,ReqMem,MaxRss,nnodes,ncpus,nodelist -j <your job ID> --units=G``
to find the running GPU id.
Then use the command: ``cd <GPU id>`` and type ``nvtop``. There will be dynamic GPU usage chart. 

If the prediction step does not use GPU even with proper GPU partitions, consider reinstalling the AlphaPulldown.

## Contributing

Outline guidelines for contributing to the project, such as how to report bugs, suggest enhancements, or submit pull requests.

## License

Specify the license under which the project is distributed. If applicable, include any license-related information or acknowledgments.

