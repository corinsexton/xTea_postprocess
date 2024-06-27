#!/usr/bin/env python

import pyranges as pr, pandas as pd
import argparse

ann = pr.read_gff3("/home/cos689/data1/corinne/ref/gencode/gencode.v45.basic.annotation.gff3.gz")
introns = ann.features.introns(by="gene")
tss = ann.features.tss()

# generate splice sites
splice_start = ann[ann.Feature == 'exon']
splice_start.Feature = 'splice_site'
splice_start = splice_start.extend(10)
splice_start.End = splice_start.Start + 20

splice_end = ann[ann.Feature == 'exon']
splice_end.Feature = 'splice_site'
splice_end = splice_end.extend(10)
splice_end.Start = splice_end.End - 20

ann_all = pd.concat([ann.df,introns.df,tss.df,splice_start.df,splice_end.df])
ann_all.drop(ann_all[ann_all.Feature == "CDS"].index,inplace = True)
ann_all.drop(ann_all[ann_all.Feature == "gene"].index,inplace = True)
ann_all.drop(ann_all[ann_all.Feature == "transcript"].index,inplace = True)

ann_all = pr.PyRanges(ann_all)

ann_all.to_gff3("/home/cos689/data1/corinne/ref/gencode/hg38_gencode_ann.gff3")


