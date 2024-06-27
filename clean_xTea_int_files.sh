#!/bin/bash


results_dir=~/data1/corinne/PCAWG_TCGA_normals/xtea/results/


for i in ${results_dir}/*; do

	echo Cleaning up ${i}...

	rm -rf ${i}/pub_clip
	rm -rf ${i}/*/*tmp*
	rm -rf ${i}/*/*candidate*


done
