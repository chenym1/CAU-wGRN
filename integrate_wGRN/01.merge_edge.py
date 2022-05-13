#!/usr/bin/env python3
'''
python 01.merge_edge.py > all_matrix.txt

combine interactions to single file
'''

import sys

# read
all_interactions = {}
def read_network(data):
	dc = {}
	with open(data) as f:
		for i in f:
			i = i.strip().split('\t')
			tmp_interaction = i[0]+'_'+i[1]
			dc[tmp_interaction] = i[2]
			all_interactions[tmp_interaction] = ''
	return(dc)

PCCs = read_network('PCCs.unique.txt')
genie3 = read_network('links.filtered.txt')
pwm = read_network('PWM.txt')
cpwm = read_network('conserved_PWM.txt')
chipdap = read_network('DAP_ChIP_edge.2.txt')
cCOE = read_network('cCOE_towheat.txt')

openchromatin = {}
with open('total_open_chromatin_score.txt') as f:
	for i in f:
		i = i.strip().split('\t')
		openchromatin[i[0]] = i[1]
#
print('interactions\tPCC\tGENIE3\tcCOE\tPWM\tcPWM\tTFbinding\topenchromatin')
for interaction in all_interactions.keys():
	if interaction in PCCs:
		PCCs_value = PCCs[interaction]
	else:
		PCCs_value = 0
	if interaction in genie3:
		genie3_value = genie3[interaction]
	else:
		genie3_value = 0
	if interaction in cCOE:
		cCOE_value = cCOE[interaction]
	else:
		cCOE_value = 0
	if interaction in pwm:
		pwm_value = pwm[interaction]
	else:
		pwm_value = 0
	if interaction in cpwm:
		cpwm_value = cpwm[interaction]
	else:
		cpwm_value = 0
	if interaction in chipdap:
		chipdap_value = chipdap[interaction]
	else:
		chipdap_value = 0

	targets = interaction.split('_')[1]
	if targets in openchromatin:
		openchromatin_value = openchromatin[targets]
	else:
		openchromatin_value = 0
	#
	print('\t'.join([interaction,str(PCCs_value),str(genie3_value),str(cCOE_value),str(pwm_value),str(cpwm_value),str(chipdap_value),str(openchromatin_value)]))
