#!/bin/bash

results_dir=$1
id_file=$2

while read -r i f; do
    
    bam_id=$i
    bam_file=$i

    echo $bam_id

    #if ! test -f ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf; then
        grep -v 'orphan' ${results_dir}/${bam_id}/L1/${bam_file}_LINE1.vcf \
                         > ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf

        grep '^#' ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf > final
        grep 'two_side_tprt_both' ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf >> final
        mv final ${results_dir}/${bam_id}/L1/${bam_id}_filtered_LINE1.vcf
    #fi

    #if ! test -f ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf; then
        grep -v 'orphan' ${results_dir}/${bam_id}/Alu/${bam_file}_ALU.vcf \
                         > ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf

        grep '^#' ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf > final
        grep 'two_side_tprt_both' ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf >> final
        mv final ${results_dir}/${bam_id}/Alu/${bam_id}_filtered_ALU.vcf
    #fi

    #if ! test -f ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf; then
        grep -v 'orphan' ${results_dir}/${bam_id}/SVA/${bam_file}_SVA.vcf \
                         > ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf

        grep '^#' ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf > final
        grep 'two_side_tprt_both' ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf >> final
        mv final ${results_dir}/${bam_id}/SVA/${bam_id}_filtered_SVA.vcf
    #fi

done < ${id_file}
