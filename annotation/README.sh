#!/bin/bash

## Add ID columns from 1000 genomes to samples
bcftools annotate -c CHROM,FROM,TO,ID \
	-a ~/data1/corinne/ref/1kgenomes/1KG_L1.bed.gz -o L1_LFS_light_kg.vcf  L1_LFS_light_merged.vcf
bcftools annotate -c CHROM,FROM,TO,ID \
	-a ~/data1/corinne/ref/1kgenomes/1KG_ALU.bed.gz -o ALU_LFS_light_kg.vcf  ALU_LFS_light_merged.vcf

# annotate with gencode 
# output =  annotated_<dataset>_<te>.tsv
#sbatch start_slurm.sh


