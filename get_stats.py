#!/usr/bin/env python

import glob
import sys
import os.path
import re
from pathlib import Path
from pysam import VariantFile

results_dir = "/home/cos689/Kamihara_DFCI_WGS/thyroid_cancer/analysis/xtea/results"

o_totals = open('mei_totals.tsv','w')
o_totals_HMEID = open('mei_hmeid_totals.tsv','w')
o_gt = open('mei_genotypes.tsv','w')
o_reg = open('mei_regions.tsv','w')
o_rmsk = open('mei_rmsk.tsv','w')

o_totals.write('\t'.join(["sample_id","TE_type","n"]) + '\n')
o_totals_HMEID.write('\t'.join(["sample_id","TE_type","HMEID_status","n"]) + '\n')
o_gt.write('\t'.join(["sample_id","TE_type","genotype","n"]) + '\n')
o_reg.write('\t'.join(["sample_id","TE_type","region_type","n"]) + '\n')
o_rmsk.write('\t'.join(["sample_id","TE_type","RMSK_presence","n"]) + '\n')

ids = set()

# open ids
with open("ids.txt") as idfile:
    for line in idfile:
        ids.add(line.strip())       

vcf_dict = dict()

for i in ids:
    vcf_dict[i] = {'LINE1':{"total":0,
                               "intron":0,"exon":0,"intergenic":0, "down_stream":0, "up_stream":0,
                               'total_in_mei_and_rmsk':0,
                               'total_only_in_mei':0,
                               'total_only_in_rmsk':0,
                               'total_not_in_mei_or_rmsk':0,
                               "homozygous":0,"heterozygous":0},
                    'ALU':{"total":0,
                               "intron":0,"exon":0,"intergenic":0, "down_stream":0, "up_stream":0,
                               'total_in_mei_and_rmsk':0,
                               'total_only_in_mei':0,
                               'total_only_in_rmsk':0,
                               'total_not_in_mei_or_rmsk':0,
                               "homozygous":0,"heterozygous":0},
                    'SVA':{"total":0, 
                               "intron":0,"exon":0,"intergenic":0, "down_stream":0, "up_stream":0,
                               'total_in_mei_and_rmsk':0,
                               'total_only_in_mei':0,
                               'total_only_in_rmsk':0,
                               'total_not_in_mei_or_rmsk':0,
                               "homozygous":0,"heterozygous":0},
                    }

    print("Running through " + i + '...')

    for te in ["LINE1","SVA","ALU"]:

        if te == 'LINE1': te_pref = 'L1'
        elif te == 'ALU': te_pref = 'Alu'
        elif te == 'SVA': te_pref = 'SVA'

        vcf_file = results_dir + '/' + i + '/' + te_pref + '/' + i + '_filtered_' + te + '.vcf'
        if not os.path.isfile(vcf_file):
            print (f'MISSING FILE:\t {vcf_file}')
            continue

        vcf = VariantFile(vcf_file)

        rmsk_copies = set()
        all_copies = set()
        not_mei_copies = set()

        for rec in vcf.fetch():
            
            #if rec.info['SVTYPE'] == "INS:ME:LINE1":
            #    if int(rec.info['SVLEN']) > 450:
            #        vcf_dict[i][te]['total'] += 1
            #else:
            #    vcf_dict[i][te]['total'] += 1

            vcf_dict[i][te]['total'] += 1
            all_copies.add((rec.contig,rec.pos))

            # gene region:
            if rec.info['GENE_INFO'] == 'not_gene_region':
                vcf_dict[i][te]['intergenic'] += 1
                # could we check these for regulatory regions?
            else:
                if re.search('intron',rec.info['GENE_INFO']):
                    vcf_dict[i][te]['intron'] += 1
                if re.search('exon',rec.info['GENE_INFO']):
                    vcf_dict[i][te]['exon'] += 1
                if re.search('up_stream',rec.info['GENE_INFO']):
                    vcf_dict[i][te]['up_stream'] += 1
                if re.search('down_stream',rec.info['GENE_INFO']):
                    vcf_dict[i][te]['down_stream'] += 1


            # genotype:
            gts = [s['GT'] for s in rec.samples.values()]

            if gts[0] == (1,1):
               vcf_dict[i][te]['homozygous'] += 1
            else:
               vcf_dict[i][te]['heterozygous'] += 1


            if not re.search("not_in",rec.info['REF_REP']):
                rmsk_copies.add((rec.contig,rec.pos))


        mei_vcf_file = results_dir + '/' + i + '/' + te_pref + '/' + i + '_filtered_notinHMEID.vcf'
        if not os.path.isfile(mei_vcf_file):
            print (f'MISSING FILE:\t {mei_vcf_file}')
            continue

        mei_vcf = VariantFile(mei_vcf_file)

        for rec in mei_vcf.fetch():
            not_mei_copies.add((rec.contig,rec.pos))

        #if len(all_copies) != vcf_dict[i][te]['total']: 
        #    print("PROBLEM, total != all_copies length")
        #    sys.exit()

        mei_copies = all_copies - not_mei_copies
        vcf_dict[i][te]['total_in_mei_and_rmsk'] = len(mei_copies & rmsk_copies)
        vcf_dict[i][te]['total_only_in_mei'] = len(mei_copies) - vcf_dict[i][te]['total_in_mei_and_rmsk']
        vcf_dict[i][te]['total_only_in_rmsk'] = len(rmsk_copies) - vcf_dict[i][te]['total_in_mei_and_rmsk']
        vcf_dict[i][te]['total_not_in_mei_or_rmsk'] = len(all_copies) -vcf_dict[i][te]['total_in_mei_and_rmsk'] - vcf_dict[i][te]['total_only_in_mei'] - vcf_dict[i][te]['total_only_in_rmsk']

        mei_copies.clear()
        rmsk_copies.clear()
        all_copies.clear()
        not_mei_copies.clear()





    # output results per id:

    # headers
    #  o_totals.write('\t'.join(["sample_id","TE_type","n"]) + '\n')
    #  o_totals_HMEID.write('\t'.join(["sample_id","TE_type","HMEID_status","n"]) + '\n')
    #  o_gt.write('\t'.join(["sample_id","TE_type","genotype","n"]) + '\n')
    #  o_reg.write('\t'.join(["sample_id","TE_type","region_type","n"]) + '\n')
    #  o_rmsk.write('\t'.join(["sample_id","TE_type","RMSK_presence","n"]) + '\n')
    for te in vcf_dict[i]:
        total = vcf_dict[i][te]['total']
        o_totals.write(f'{i}\t{te}\t{total}\n')

        homo = vcf_dict[i][te]['homozygous']
        het = vcf_dict[i][te]['heterozygous']
        o_gt.write(f'{i}\t{te}\thomozygous\t{homo}\n')
        o_gt.write(f'{i}\t{te}\theterozygous\t{het}\n')

        inter = vcf_dict[i][te]['intergenic']
        intron = vcf_dict[i][te]['intron']
        exon = vcf_dict[i][te]['exon']
        upstream = vcf_dict[i][te]['up_stream']
        downstream = vcf_dict[i][te]['down_stream']
        o_reg.write(f'{i}\t{te}\tintergenic\t{inter}\n')
        o_reg.write(f'{i}\t{te}\tintron\t{intron}\n')
        o_reg.write(f'{i}\t{te}\texon\t{exon}\n')
        o_reg.write(f'{i}\t{te}\tupstream\t{upstream}\n')
        o_reg.write(f'{i}\t{te}\tdownstream\t{downstream}\n')
        
        rmsk_copy = vcf_dict[i][te]['total_only_in_rmsk']
        mei_copy = vcf_dict[i][te]['total_only_in_mei']
        rmsk_mei_copy = vcf_dict[i][te]['total_in_mei_and_rmsk']
        none_copy = vcf_dict[i][te]['total_not_in_mei_or_rmsk']

        o_rmsk.write(f'{i}\t{te}\tonly_rmsk\t{rmsk_copy}\n')
        o_rmsk.write(f'{i}\t{te}\tonly_mei\t{mei_copy}\n')
        o_rmsk.write(f'{i}\t{te}\tboth_mei_rmsk\t{rmsk_mei_copy}\n')
        o_rmsk.write(f'{i}\t{te}\tneither\t{none_copy}\n')
        

                

o_totals.close()
o_totals_HMEID.close()
o_gt.close()
o_reg.close()
o_rmsk.close()
