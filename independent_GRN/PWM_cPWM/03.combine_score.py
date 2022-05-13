#!/usr/bin/env python3
'''
python 03.combine_score.py > PWM.txt

combine PWM scores
'''
import numpy as np
import sys

dc = {}
with open('TF_match.txt') as f:
	for i in f:
		i = i.strip().split('\t')
		dc.setdefault(i[0],[]).append(i[1])
#
dc_TF_val = {}
with open('total_motif.txt') as f:
	for i in f:
		i = i.strip().split('\t')
		try:
			tfs = dc[i[0]]
			target = i[1]
			for j in range(len(tfs)):
				interaction = tfs[j]+'\t'+i[1]
				if interaction not in dc_TF_val:
					dc_TF_val[interaction] = [float(i[2])]
				else:
					dc_TF_val[interaction].append(float(i[2]))
		except KeyError:
			continue

for i in dc_TF_val.keys():
	print(i+'\t'+str(np.mean(dc_TF_val[i])))
