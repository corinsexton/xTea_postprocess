#!/usr/bin/env python

import glob
import sys
import os.path
import re
from pathlib import Path
from pysam import VariantFile


##### 1000 genomes #####

L1_kg_vcf = VariantFile('/home/cos689/data1/corinne/ref/1kgenomes/1KG.L1.vcf')
kg_dict = {"L1":dict(),"ALU":dict()}

for rec in L1_kg_vcf.fetch():
		kg_dict["L1"][(rec.chrom,rec.pos)] = rec.info['EUR_AF'][0]

ALU_kg_vcf = VariantFile('/home/cos689/data1/corinne/ref/1kgenomes/1KG.ALU.vcf')
for rec in ALU_kg_vcf.fetch():
		kg_dict["ALU"][(rec.chrom,rec.pos)] = rec.info['EUR_AF'][0]


##### gnomad-sv #####
gnomad_dict = {"L1":dict(),"ALU":dict(),"SVA":dict()}

L1_gnomad_vcf = VariantFile('/home/cos689/data1/corinne/ref/gnomad_data/gnomad.L1.vcf.gz')
for rec in L1_gnomad_vcf.fetch():
		gnomad_dict["L1"][(rec.chrom,rec.pos)] = rec.info['nfe_AF'][0]

ALU_gnomad_vcf = VariantFile('/home/cos689/data1/corinne/ref/gnomad_data/gnomad.ALU.vcf.gz')
for rec in ALU_gnomad_vcf.fetch():
		gnomad_dict["ALU"][(rec.chrom,rec.pos)] = rec.info['nfe_AF'][0]

SVA_gnomad_vcf = VariantFile('/home/cos689/data1/corinne/ref/gnomad_data/gnomad.SVA.vcf.gz')
for rec in SVA_gnomad_vcf.fetch():
		gnomad_dict["SVA"][(rec.chrom,rec.pos)] = rec.info['nfe_AF'][0]

##### PCAWG #####
PCAWG_dict = {"L1":dict(),"ALU":dict(),"SVA":dict()}

L1_PCAWG_vcf = VariantFile('AF_vcfs/L1/L1_PCAWG_AF.vcf')
for rec in L1_PCAWG_vcf.fetch():
		PCAWG_dict["L1"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

ALU_PCAWG_vcf = VariantFile('AF_vcfs/ALU/ALU_PCAWG_AF.vcf')
for rec in ALU_PCAWG_vcf.fetch():
		PCAWG_dict["ALU"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

SVA_PCAWG_vcf = VariantFile('AF_vcfs/SVA/SVA_PCAWG_AF.vcf')
for rec in SVA_PCAWG_vcf.fetch():
		PCAWG_dict["SVA"][(rec.chrom,rec.pos)] = rec.info['AF'][0]


##### novogene #####
novo_dict = {"L1":dict(),"ALU":dict(),"SVA":dict()}

L1_novo_vcf = VariantFile('AF_vcfs/L1/L1_novogene.vcf')
for rec in L1_novo_vcf.fetch():
		novo_dict["L1"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

ALU_novo_vcf = VariantFile('AF_vcfs/ALU/ALU_novogene.vcf')
for rec in ALU_novo_vcf.fetch():
		novo_dict["ALU"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

SVA_novo_vcf = VariantFile('AF_vcfs/SVA/SVA_novogene.vcf')
for rec in SVA_novo_vcf.fetch():
		novo_dict["SVA"][(rec.chrom,rec.pos)] = rec.info['AF'][0]
		
##### Kamihara LFS #####
kami_LFS_dict = {"L1":dict(),"ALU":dict(),"SVA":dict()}

L1_novo_vcf = VariantFile('AF_vcfs/L1/L1_Kamihara_LFS.vcf')
for rec in L1_novo_vcf.fetch():
		kami_LFS_dict["L1"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

ALU_novo_vcf = VariantFile('AF_vcfs/ALU/ALU_Kamihara_LFS.vcf')
for rec in ALU_novo_vcf.fetch():
		kami_LFS_dict["ALU"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

SVA_novo_vcf = VariantFile('AF_vcfs/SVA/SVA_Kamihara_LFS.vcf')
for rec in SVA_novo_vcf.fetch():
		kami_LFS_dict["SVA"][(rec.chrom,rec.pos)] = rec.info['AF'][0]




##### broad #####
broad_dict = {"L1":dict(),"ALU":dict(),"SVA":dict()}

L1_broad_vcf = VariantFile('AF_vcfs/L1/L1_broad.vcf')
for rec in L1_broad_vcf.fetch():
		broad_dict["L1"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

ALU_broad_vcf = VariantFile('AF_vcfs/ALU/ALU_broad.vcf')
for rec in ALU_broad_vcf.fetch():
		broad_dict["ALU"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

SVA_broad_vcf = VariantFile('AF_vcfs/SVA/SVA_broad.vcf')
for rec in SVA_broad_vcf.fetch():
		broad_dict["SVA"][(rec.chrom,rec.pos)] = rec.info['AF'][0]


##### LFS Light et al #####
lfs_dict = {"L1":dict(),"ALU":dict(),"SVA":dict()}

L1_lfs_vcf = VariantFile('AF_vcfs/L1/L1_LFS_light.vcf')
for rec in L1_lfs_vcf.fetch():
		lfs_dict["L1"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

ALU_lfs_vcf = VariantFile('AF_vcfs/ALU/ALU_LFS_light.vcf')
for rec in ALU_lfs_vcf.fetch():
		lfs_dict["ALU"][(rec.chrom,rec.pos)] = rec.info['AF'][0]

SVA_lfs_vcf = VariantFile('AF_vcfs/SVA/SVA_LFS_light.vcf')
for rec in SVA_lfs_vcf.fetch():
		lfs_dict["SVA"][(rec.chrom,rec.pos)] = rec.info['AF'][0]





##### COMBINE ######


L1_all_keys = set(kg_dict["L1"].keys()).union(set(gnomad_dict["L1"].keys()),
											  set(broad_dict["L1"].keys()),
											  set(lfs_dict["L1"].keys()),
											  set(novo_dict["L1"].keys()),
											  set(PCAWG_dict["L1"].keys()),
											  set(kami_LFS_dict["L1"].keys()))
ALU_all_keys = set(kg_dict["ALU"].keys()).union(set(gnomad_dict["ALU"].keys()),
											  set(broad_dict["ALU"].keys()),
											  set(lfs_dict["ALU"].keys()),
											  set(novo_dict["ALU"].keys()),
											  set(PCAWG_dict["ALU"].keys()),
											  set(kami_LFS_dict["ALU"].keys()))
SVA_all_keys = set(gnomad_dict["SVA"].keys()).union(set(broad_dict["SVA"].keys()),
											        set(lfs_dict["SVA"].keys()),
											        set(novo_dict["SVA"].keys()),
											        set(PCAWG_dict["SVA"].keys()),
													set(kami_LFS_dict["SVA"].keys()))

header = '\t'.join(["chr","start","kg_af","gnomad_af","pcawg_af","thyroid_broad_af","thyroid_novogene_af","lfs_light_af","lfs_kami_af"]) + '\n'
L1_outfile = open("L1_all_AF.tsv",'w')
L1_outfile.write(header)
for k in L1_all_keys:
	
	pcawg_af  = 'NA'
	kg_af = 'NA'
	gnomad_af = 'NA'
	thyroid_broad_af = 'NA'
	thyroid_novogene_af = 'NA'
	lfs_light_af= 'NA'
	kami_lfs_af = 'NA'
	if k in PCAWG_dict["L1"]:
		pcawg_af = PCAWG_dict["L1"][k]
	if k in kg_dict["L1"]:
		kg_af = kg_dict["L1"][k]
	if k in gnomad_dict["L1"]:
		gnomad_af = gnomad_dict["L1"][k]
	if k in novo_dict["L1"]:
		thyroid_novogene_af = novo_dict["L1"][k]
	if k in broad_dict["L1"]:
		thyroid_broad_af= broad_dict["L1"][k]
	if k in lfs_dict["L1"]:
		lfs_light_af = lfs_dict["L1"][k]
	if k in kami_LFS_dict["L1"]:
		kami_lfs_af = kami_LFS_dict["L1"][k]

	L1_outfile.write(f'{k[0]}\t{k[1]}\t{kg_af}\t{gnomad_af}\t{pcawg_af}\t{thyroid_broad_af}\t{thyroid_novogene_af}\t{lfs_light_af}\t{kami_lfs_af}\n')

L1_outfile.close()


ALU_outfile = open("ALU_all_AF.tsv",'w')
ALU_outfile.write(header)
for k in ALU_all_keys:
	
	pcawg_af  = 'NA'
	kg_af = 'NA'
	gnomad_af = 'NA'
	thyroid_broad_af = 'NA'
	thyroid_novogene_af = 'NA'
	lfs_light_af= 'NA'
	kami_lfs_af = 'NA'
	if k in PCAWG_dict["ALU"]:
		pcawg_af = PCAWG_dict["ALU"][k]
	if k in kg_dict["ALU"]:
		kg_af = kg_dict["ALU"][k]
	if k in gnomad_dict["ALU"]:
		gnomad_af = gnomad_dict["ALU"][k]
	if k in novo_dict["ALU"]:
		thyroid_novogene_af = novo_dict["ALU"][k]
	if k in broad_dict["ALU"]:
		thyroid_broad_af= broad_dict["ALU"][k]
	if k in lfs_dict["ALU"]:
		lfs_light_af = lfs_dict["ALU"][k]
	if k in kami_LFS_dict["ALU"]:
		kami_lfs_af = kami_LFS_dict["ALU"][k]

	ALU_outfile.write(f'{k[0]}\t{k[1]}\t{kg_af}\t{gnomad_af}\t{pcawg_af}\t{thyroid_broad_af}\t{thyroid_novogene_af}\t{lfs_light_af}\t{kami_lfs_af}\n')

ALU_outfile.close()

SVA_outfile = open("SVA_all_AF.tsv",'w')
SVA_outfile.write(header)
for k in SVA_all_keys:
	
	pcawg_af  = 'NA'
	kg_af = 'NA'
	gnomad_af = 'NA'
	thyroid_broad_af = 'NA'
	thyroid_novogene_af = 'NA'
	lfs_light_af= 'NA'
	kami_lfs_af = 'NA'
	if k in PCAWG_dict["SVA"]:
		pcawg_af = PCAWG_dict["SVA"][k]
	if k in gnomad_dict["SVA"]:
		gnomad_af = gnomad_dict["SVA"][k]
	if k in novo_dict["SVA"]:
		thyroid_novogene_af = novo_dict["SVA"][k]
	if k in broad_dict["SVA"]:
		thyroid_broad_af= broad_dict["SVA"][k]
	if k in lfs_dict["SVA"]:
		lfs_light_af = lfs_dict["SVA"][k]
	if k in kami_LFS_dict["SVA"]:
		kami_lfs_af = kami_LFS_dict["SVA"][k]

	SVA_outfile.write(f'{k[0]}\t{k[1]}\t{kg_af}\t{gnomad_af}\t{pcawg_af}\t{thyroid_broad_af}\t{thyroid_novogene_af}\t{lfs_light_af}\t{kami_lfs_af}\n')

SVA_outfile.close()

	
		


