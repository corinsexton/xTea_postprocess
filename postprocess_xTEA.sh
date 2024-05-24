#!/bin/bash

results_dir=~/xtea/results
ids=ids.txt
dataset_prefix=novogene


# coded inside to do SVA, L1, and ALU
./filter_orphan_vcfs.sh ${results_dir} ${ids}
./get_stats.py ${results_dir} ${ids}
./make_combined_bcf.sh ${results_dir} ${dataset_prefix} remove

./annotation/merge_within_35bp_vcf.py ${results_dir}/../SVA_${dataset_prefix}.vcf > ${results_dir}/../SVA_${dataset_prefix}_merged.vcf
./annotation/merge_within_35bp_vcf.py ${results_dir}/../ALU_${dataset_prefix}.vcf > ${results_dir}/../ALU_${dataset_prefix}_merged.vcf
./annotation/merge_within_35bp_vcf.py ${results_dir}/../L1_${dataset_prefix}.vcf > ${results_dir}/../L1_${dataset_prefix}_merged.vcf


bcftools annotate -c CHROM,FROM,TO,ID \
	-a ~/data1/corinne/ref/1kgenomes/1KG_L1.bed.gz -o ${results_dir}/../L1_${dataset_prefix}_1kg.vcf ${results_dir}/../L1_${dataset_prefix}_merged.vcf
bcftools annotate -c CHROM,FROM,TO,ID \
	-a ~/data1/corinne/ref/1kgenomes/1KG_ALU.bed.gz -o ${results_dir}/../ALU_${dataset_prefix}_kg.vcf ${results_dir}/../L1_${dataset_prefix}_merged.vcf


./annotate_xtea.py /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz ${results_dir}/../ALU_${dataset_prefix}_kg.vcf ${results_dir}/../annotated_${dataset_prefix}_ALU.tsv
./annotate_xtea.py /home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz ${results_dir}/../L1_${dataset_prefix}_kg.vcf ${results_dir}/../annotated_${dataset_prefix}_L1.tsv


