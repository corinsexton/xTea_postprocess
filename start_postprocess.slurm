#!/bin/bash


#SBATCH --job-name=thyroid_pp
#SBATCH -A park
#SBATCH --partition short
#SBATCH --mem 32G
#SBATCH -c 1
#SBATCH -t 00:15:00
#SBATCH -o slurm-%x.%j.out



results_dir=~/Kamihara_DFCI_WGS/thyroid_cancer/analysis/xtea/results/
ids=~/Kamihara_DFCI_WGS/thyroid_cancer/analysis/xtea/ids.txt
dataset_prefix=Broad_thyroid

./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}
