#!/bin/bash


#SBATCH --job-name=pp_all
#SBATCH -A park
#SBATCH --partition short
#SBATCH --mem 64G
#SBATCH -c 1
#SBATCH -t 05:30:00
#SBATCH -o slurm-%x.%j.out



results_dir=~/data1/corinne/PCAWG_TCGA_normals/xtea/results/
ids=~/data1/corinne/PCAWG_TCGA_normals/xtea/ids.txt
dataset_prefix=PCAWG_normals
./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}

results_dir=~/mei-pediatric-cancer/xtea/KF-FALL/results/
ids=~/mei-pediatric-cancer/xtea/KF-FALL/ids.txt
dataset_prefix=KF-FALL
./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}

results_dir=~/mei-pediatric-cancer/xtea/KF-NCSF/results/
ids=~/mei-pediatric-cancer/xtea/KF-NCSF/ids.txt
dataset_prefix=KF-NCSF
./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}

results_dir=~/mei-pediatric-cancer/xtea/KF-ED/results/
ids=~/mei-pediatric-cancer/xtea/KF-ED/ids.txt
dataset_prefix=KF-ED
./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}

results_dir=~/Kamihara_DFCI_WGS/thyroid_cancer/analysis_terra_2023/xtea/results/
ids=~/Kamihara_DFCI_WGS/thyroid_cancer/analysis_terra_2023/xtea/ids.txt
dataset_prefix=thyroid_cancer_Broad
./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}

results_dir=~/LFS_light_et_al/analysis/xtea/results/
ids=~/LFS_light_et_al/analysis/xtea/ids.txt
dataset_prefix=LFS_light_et_al

./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}

results_dir=~/LFS_Kamihara/xtea/results/
ids=~/LFS_Kamihara/xtea/ids.txt
dataset_prefix=LFS_kamihara

./postprocess_xTEA.sh ${results_dir} $ids ${dataset_prefix}
