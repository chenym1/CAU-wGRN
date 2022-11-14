#!/bin/bash

sample1=$1
sample2=$2

# identify open chromatin peak
macs2 callpeak -c ${sample1}.bwa.sort.filter.bam -t ${sample2}.bwa.sort.filter.bam -f BAMPE --nomodel --shift 100 --extsize 200 -g 17e9 -n peak --outdir ./
