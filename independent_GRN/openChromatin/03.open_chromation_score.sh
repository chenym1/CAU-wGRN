#!/bin/bash

# merge peaks

cat *_peaks.narrowPeak | bedtools sort | gawk -vOFS="\t" '{if($1~".2$"){$2=$2+400000000;$3=$3+400000000;split($1,a,".");$1=a[1];print $1,$2,$3,$4,$7}else{split($1,a,".");$1=a[1];print $1,$2,$3,$4,$7}}' > total_peak.bed

#
bedtools intersect -a promoter.bed -b total_peak.bed -loj > overlap.txt
#
python get_open_score.py | sort -k2nr > total_open_chromatin_score.txt
