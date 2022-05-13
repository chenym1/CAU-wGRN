#!/bin/bash

# identify TF motif near the TSS of target genes.

mkdir fimo_out/

for motif in `cat motif.list`;do
	fimo --thresh 1e-4 --bgfile promter.bg --oc fimo_out/${motif} plantTFDB/${motif}.meme promter.fa
done

# merge

echo -en '' > total_motif.txt
for i in `cat motif.list`;do
	grep -v motif_id fimo_out/${i}/fimo.tsv | grep 'TraesCS' | cut -f1,3,7 | sort | uniq >> total_motif.txt
done

