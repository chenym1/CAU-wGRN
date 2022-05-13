#!/usr/bin/env bash

# map RNA-seq reads to reference transcriptome and calculate TPMs

fastq1=$1
fastq2=$2
outname=$3
nthread=$4
index=$5

# index
kallisto index -i IWGSCv1p1_mRNA.idx IWGSCv1p1_mRNA.fa

# remove low-quality reads
fastp -i $1 -I $2 -o ${outname}.filter.1.fq.gz -O ${outname}.filter.2.fq.gz -w ${nthread} --json ${outname}.json --html ${outname}.html

# read counts
kallisto quant -i ${index} -o ./ -t ${nthread} ${outname}.filter.1.fq.gz ${outname}.filter.2.fq.gz