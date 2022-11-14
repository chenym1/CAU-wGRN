#!/usr/bin/env Rscript

# calculate GENIE3 weight between TFs and their downstream targets

library(GENIE3)

TPM_expression <- 'exp_TPMs.txt'
TFs <- 'planttfdb_overlap_iTAK.txt'

# expression matrix
data <- read.delim(TPM_expression,stringsAsFactors = F)
data <- log2(data+1)

# TFs
TFs <- read.table(TFs,header = F,stringsAsFactors = F)
TFs <- TFs[which(TFs$V1%in%rownames(data)),1]

# run
exprMatrix <- as.matrix(data)
set.seed(123) # For reproducibility of results
weightMatrix <- GENIE3(exprMatrix, regulators=TFs, nCores = 48)

# Get ranking of edges
linkList <- getLinkList(weightMatrix)

linkList <- linkList[whch(linkList[,3]>=0.005),]

write.table(linkList,'links.filtered.txt',row.names = F,sep = '\t',quote = F)
