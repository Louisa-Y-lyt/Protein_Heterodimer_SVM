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
"/path/outputs/negative_0to1000" \
"" \ # Default usage of Harvard FAS Alphafold database
"/path/6000_tn_pairs.txt"
"/path/msa_outputs"
```
The default mode in ``prediction.sh`` is custom mode (self-defined pairs). You can explore other modes by reading AlphaPulldown manuals (https://github.com/KosinskiLab/AlphaPulldown/tree/main).

Do not submit too many jobs at one time if finishing all jobs takes more than 5 hours. 

For each protein pair there will be 5 models generated based on different initiation locations. For each model it will take ~5 minutes when running in GPU.

You could check the usage of GPUs using: 
``sacct --format=JobID,Jobname,partition,state,time,start,end,elapsed,ReqMem,MaxRss,nnodes,ncpus,nodelist -j <your job ID> --units=G``
to find the running GPU id. Then use the command: ``cd <GPU id>`` and type ``nvtop``. There will be dynamic GPU usage chart. 

If the prediction step does not use GPU even with proper GPU partitions, consider reinstalling the AlphaPulldown.

### Computing the protein interface features

Running the sandbox to write the final interface features into a csv file ``predictions_with_good_interpae.csv``. In the default ``alpha-analysis.sif``, there is a cut-off parameter to filter protein pairs based on PAE (predicted alignment error) values. To save more negative pairs with high PAE values, I manually modified this sigularity image in its sandbox replicate to inactivate the cutt-off filter. You need to replace the former ``/alpha_analysis/app/alpha-analysis/get_good_inter_pae.py`` into my modified version ``get_good_inter_pae.py''. Use the following commmand to generate a sandbox replicate using ``build_sandbox.sh``:

```bash
sbatch "/path/sandbox_path" "/path/alpha-analysis.sif"
```

After replacing ``get_good_inter_pae.py`` files, run the following command to compute protein interface features using ``feature_computing_sandbox.sh``.

```bash
sbatch feature_computing_sandbox.sh "/path/outputs/negative_0to100"
```

This step runs on CPU. If there are more than 1000 pairs to be calculated, the running time will be too long. Since the script is unable to skip existing pairs, it is recommended that each 1000 pairs should be saved in a seperate folder waiting for feature calculation. 

## Contributing

Outline guidelines for contributing to the project, such as how to report bugs, suggest enhancements, or submit pull requests.

## License

Specify the license under which the project is distributed. If applicable, include any license-related information or acknowledgments.

