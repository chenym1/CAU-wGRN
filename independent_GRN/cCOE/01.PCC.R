#!/usr/bin/env Rscript

# calcualte PCCs between TFs and their downstream targets.

library(reshape2)

# expression matrix
data <- read.delim('rice_exp_TPMs.txt',stringsAsFactors = F)
data <- t(log2(data+1))

# TFs
TFs <- read.table('rice_planttfdb_overlap_iTAK.txt',header = F,stringsAsFactors = F)
TFs <- TFs[which(TFs$V1%in%colnames(data)),1]

# PCC
for(i in 1:length(TFs)){
  tmp_TF <- TFs[i]
  tmp_PCC <- data.frame(cor(data[,tmp_TF],data)) # PCC
  rownames(tmp_PCC) <- tmp_TF
  tmp_PCC <- melt(tmp_PCC)
  tmp_PCC$TF <- tmp_TF
  tmp_PCC$value <- abs(tmp_PCC$value) # abs of PCC
  tmp_PCC <- tmp_PCC[order(tmp_PCC$value,decreasing = T),]
  tmp_PCC2 <- tmp_PCC[1:351,] # top highest 351
  if(i==1){
    total_PCC <- tmp_PCC2
  }else{
    total_PCC <- rbind(total_PCC,tmp_PCC2)
  } 
}

write.table(total_PCC,'rice_PCCs.txt',row.names = F,sep = '\t',quote = F)

system("cat rice_PCCs.txt | gawk -vOFS='\t' '{if($1!=$3)print $3,$1,$2}' > rice_PCCs.unique.txt")
