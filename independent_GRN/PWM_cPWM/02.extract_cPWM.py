#!/usr/bin/env python3
'''
Extract conserved PWM interactions in wheat

PWM.txt contains all PWM sites in wheat.
conserved_edge.txt contains conserved PWM sites across species.
'''

import sys

# read
def read_network(data):
	dc = {}
	with open(data) as f:
		for i in f:
			i = i.strip().split('\t')
			dc[i[0]+'_'+i[1]] = i[2]
	return(dc)

pwm = read_network('PWM.txt')

with open('conserved_edge.txt') as f:
	for i in f:
		i = i.strip().split('\t')
		interaction = i[0]+'_'+i[1]
		if interaction in pwm:
			print(i[0]+'\t'+i[1]+'\t'+str(pwm[interaction]))
