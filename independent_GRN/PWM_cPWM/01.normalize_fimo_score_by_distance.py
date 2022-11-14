#!/usr/bin/env python3

'''
Assign score weight by the distance to TTS.
The input is fimo.tsv
'''

import sys
import math

def cal_score(start,end,score):
	start = int(start)
	end = int(end)
	score = float(score)
	midpoint = (end-start)/float(2)+start
	distance = abs(2500-midpoint)
	norm_score = score*(math.exp(1)**(-distance/float(2500)))
	return(norm_score)

with open(sys.argv[1]) as f:
	for i in f:
		i = i.strip().split('\t')
		score = cal_score(i[3],i[4],i[6])
		print('\t'.join([i[0],i[2],str(score)]))
