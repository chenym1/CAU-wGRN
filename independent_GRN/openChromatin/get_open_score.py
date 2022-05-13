#!/usr/bin/env python3
'''
chr1A   100793  124504  TraesCS1A02G000400      51      +       chr1A   103257  103807  SRR9647008_peak_11      7.77398
chr1A   100793  124504  TraesCS1A02G000400      51      +       chr1A   110267  110609  SRR9647008_peak_12      6.81734
chr1A   100793  124504  TraesCS1A02G000400      51      +       chr1A   121277  121466  SRR13308319_peak_133    8.48796
chr1A   147489  156559  TraesCS1A02G000500      28      -       .       -1      -1      .       -1
chr1A   160312  164609  TraesCS1A02G000600      32      +       .       -1      -1      .       -1
'''
import sys
dc = {}
with open('overlap.txt') as f:
	for i in f:
		i = i.strip().split('\t')
		if i[6] != ".":
			dc.setdefault(i[3],[]).append(float(i[10]))
for i in dc.keys():
	score = max(dc[i])
	print(i+'\t'+str(score))
