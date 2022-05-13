#!/bin/bash

# map reads to reference genome.

fq1=$1
fq2=$2
nthread=$3
index=$4
name=$5

mkdir ${name}; cd ${name}

# trim
fastp -i ${fq1} -I ${fq2} -o ${name}.filter.1.fq.gz -O ${name}.filter.2.fq.gz -w ${nthread} --json ${name}.json --html ${name}.html

# map
bwa mem -t ${nthread} -M -R '@RG\tID:'${name}'\tLB:'${name}'\tPL:ILLUMINA\tSM:'${name} ${index} ${name}.filter.1.fq.gz ${name}.filter.2.fq.gz | samtools view -Sbh - > ${name}.bwa.bam

# sort
samtools sort --threads ${nthread} ${name}.bwa.bam -o ${name}.bwa.sort.bam

# filter
samtools view -bSh -q 20 ${name}.bwa.sort.bam > ${name}.bwa.sort.filter.bam

# index and stat
samtools index ${name}.bwa.sort.filter.bam
samtools flagstat ${name}.bwa.sort.filter.bam > ${name}.flagstat

cd ..