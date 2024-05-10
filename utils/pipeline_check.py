import argparse
import os

def msa_summary(output_dir: str, compare_fasta_file: str): 
    output_files = {f for f in os.listdir(output_dir) if os.path.isfile(os.path.join(output_dir, f))}
    protein_names = {}
    with open(compare_fasta_file, 'r') as fasta_file:
        order = 1
        for line in fasta_file:
            if line.startswith(">"):
                protein_names[line.strip().lstrip('>')] = order
                order += 1
    protein_without_pkl = {}
    for protein_name, protein_idx in protein_names.items():
        pkl_file = protein_name + '.pkl'
        if pkl_file not in output_files:
            protein_without_pkl[protein_name] = protein_idx
    return protein_without_pkl

def af2_summary(af2_output_dir: str, compare_af2_file: str):
    import os 
    custom_list = {}
    with open(compare_af2_file, 'r') as f:
        order = 1
        for line in f:
            target = ''
            for item in line.rstrip("\n").split(";")[:-1]:
                target += item
                target += "_and_"
            target += line.rstrip("\n").split(";")[-1]
            custom_list[target] = order
            order += 1
    protein_pairs_without_af2 = {}
    af2_subdirs = [f for f in os.listdir(af2_output_dir) if os.path.isdir(os.path.join(af2_output_dir, f)) and "msa" not in f and ".ipynb" not in f]  
    for job, idx in custom_list.items():
        check = False
        for directory in af2_subdirs: 
            check = os.path.isfile(os.path.join(af2_output_dir, directory, job, 'ranking_debug.json'))
            if check:
                break
        if check:
            continue
        else:
            protein_pairs_without_af2[job] = idx
    return protein_pairs_without_af2

def main(msa_output_dir, af2_output_dir, compare_fasta_file, compare_af2_file):
    res_msa = ''
    answer_dict = msa_summary(msa_output_dir, compare_fasta_file)
    for protein_name, array in answer_dict.items():
        res_msa += str(array)
        res_msa += ","
    print("Proteins without MSA outputs:", res_msa)
    res_af2 = ''
    for protein_name, array in af2_summary(af2_output_dir, compare_af2_file).items():
        res_af2 += str(array)
        res_af2 += ","
    print("Proteins without AF2 outputs:", res_af2)
    print("File path", compare_af2_file)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Pipeline Check Script")
    parser.add_argument("msa_output_dir", help="Path to the MSA output directory")
    parser.add_argument("af2_output_dir", help="Path to the AF2 output directory")
    parser.add_argument("compare_fasta_file", help="Path to the FASTA file for comparison")
    parser.add_argument("compare_af2_file", help="Path to the AF2 file for comparison")

    args = parser.parse_args()

    main(args.msa_output_dir, args.af2_output_dir, args.compare_fasta_file, args.compare_af2_file)
