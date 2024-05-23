#!/bin/bash

./filter_orphan_vcfs.sh
./get_stats.py

./make_combined_bcf.sh

~/data1/corinne/benchmark_batch_effects/combine_allele_frequencies.py
~/data1/corinne/benchmark_batch_effects/merge_within_35bp.py
~/data1/corinne/benchmark_batch_effects/visualize_AF.R


/home/cos689/LFS_light_et_al/analysis/insertion_locations/README.sh
/home/cos689/LFS_light_et_al/analysis/insertion_locations/annotate_xtea.py
