#!/bin/bash

results_dir=$1
id_file=$2

rm ${results_dir}/*/L1/*_filtered_LINE1.vcf
rm ${results_dir}/*/Alu/*_filtered_ALU.vcf
rm ${results_dir}/*/SVA/*_filtered_SVA.vcf

while read -r i f; do
    
    bam_id=$i
    bam_file=$i

    echo $bam_id

    #if ! test -f ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf; then
        grep -v 'orphan' ${results_dir}/${bam_id}/L1/*_LINE1.vcf \
                         > ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf

        grep '^#' ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf > ${i}_final
        grep 'two_side_tprt_both' ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf >> ${i}_final
        mv ${i}_final ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf
    #fi

    #if ! test -f ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf; then
        grep -v 'orphan' ${results_dir}/${bam_id}/Alu/*_ALU.vcf \
                         > ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf

        grep '^#' ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf > ${i}_final
        grep 'two_side_tprt_both' ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf >> ${i}_final
        mv ${i}_final ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf
    #fi

    #if ! test -f ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf; then
        grep -v 'orphan' ${results_dir}/${bam_id}/SVA/*_SVA.vcf \
                         > ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf

        grep '^#' ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf > ${i}_final
        grep 'two_side_tprt_both' ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf >> ${i}_final
        mv ${i}_final ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf
    #fi

done < ${id_file}

