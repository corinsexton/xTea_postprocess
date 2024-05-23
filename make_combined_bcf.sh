#!/bin/bash

results_dir=../results

for i in ${results_dir}/*/L1/*filtered_LINE1.vcf; do
    name=${i##*/}
    bcftools view -Ob -o ${name}.bcf ${i}; bcftools index ${name}.bcf;
done


bcftools merge -m none -0 *LINE1*bcf > novogene.vcf
bcftools +fill-tags novogene.vcf -- -t AN,AC,AF > L1_novogene.vcf



for i in ${results_dir}/*/Alu/*filtered_ALU.vcf; do
    name=${i##*/}
    bcftools view -Ob -o ${name}.bcf ${i}; bcftools index ${name}.bcf;
done


bcftools merge -m none -0 *ALU*bcf > novogene.vcf
bcftools +fill-tags novogene.vcf -- -t AN,AC,AF > ALU_novogene.vcf



for i in ${results_dir}/*/SVA/*filtered_SVA.vcf; do
    name=${i##*/}
    bcftools view -Ob -o ${name}.bcf ${i}; bcftools index ${name}.bcf;
done


bcftools merge -m none -0 *SVA*bcf > novogene.vcf
bcftools +fill-tags novogene.vcf -- -t AN,AC,AF > SVA_novogene.vcf
