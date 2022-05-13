#!/usr/bin/env bash

# merge peaks
echo -en "" > DAP_ChIP.txt
cat sample.list | while read line;do
	name=`echo $line | gawk '{print $1}'`
	geneid=`echo $line | gawk '{print $2}'`
	for target in `cat ${name}_ann.txt | sed 1d | cut -f15 | sort |uniq`;do
		echo -en ${geneid}"\t"${target}"\n" >> DAP_ChIP.txt
	done
done
