#!/usr/bin/env Rscript

# calcualte GENIEs weight between TFs and their downstream targets.

library(GENIE3)

# expression matrix
data <- read.delim('rice_exp_TPMs.txt',stringsAsFactors = F)
data <- log2(data+1)

# TFs
TFs <- read.table('rice_planttfdb_overlap_iTAK.txt',header = F,stringsAsFactors = F)
TFs <- TFs[which(TFs$V1%in%rownames(data)),1]

# run
exprMatrix <- as.matrix(data)
set.seed(123) # For reproducibility of results
weightMatrix <- GENIE3(exprMatrix, regulators=TFs, nCores = 48)

# Get ranking of edges
linkList <- getLinkList(weightMatrix)

write.table(linkList,'rice_links.txt',row.names = F,sep = '\t',quote = F)

# filter
system("cat rice_links.txt | gawk -vOFS='\t' '{if($3>=0.005)print}' > rice_links.filtered.txt")
system('head -500001 rice_links.filtered.txt > rice_links.filtered.top50w.txt')