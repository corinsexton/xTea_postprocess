#!/bin/bash


#SBATCH --job-name=annotate_LFS
#SBATCH -A park_contrib
#SBATCH --partition priopark
#SBATCH --mem 32G
#SBATCH -c 1
#SBATCH -t 00:20:00
#SBATCH -o slurm_%x.%j.out


#time ./annotate_xtea.py PCAWG /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz \
#		L1_PCAWG_kg.vcf \
#		annotated_PCAWG_L1.tsv
#
##time ./annotate_xtea.py PCAWG /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz \
##		SVA_PCAWG_kg.vcf \
##		annotated_PCAWG_SVA.tsv
#
#time ./annotate_xtea.py PCAWG /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz \
#		ALU_PCAWG_kg.vcf \
#		annotated_PCAWG_ALU.tsv


#time ./annotate_xtea.py LFS /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz L1_LFS_light_kg.vcf annotated_LFS_L1.tsv
time ./annotate_xtea.py /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz ALU_LFS_light_kg.vcf annotated_LFS_ALU.tsv
##time ./annotate_xtea.py /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz SVA_LFS_light_merged.vcf annotated_SVA.tsv
