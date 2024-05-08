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
"/n/home10/ytingliu/alphapulldown_new/6000_tn_input.fasta" \
"" \
"/path/msa_outputs"
```

Normally, each MSA job takes ~15 minutes.

## Contributing

Outline guidelines for contributing to the project, such as how to report bugs, suggest enhancements, or submit pull requests.

## License

Specify the license under which the project is distributed. If applicable, include any license-related information or acknowledgments.

