#!/usr/bin/env Rscript

# match homologs

motiflist <- read.delim('motif.list',header = F,stringsAsFactors = F)
ath_wheat <- read.delim('genetribe_IWGSCv1p1_ath.one2one',header = F,stringsAsFactors = F)

# match homologs
me1 <- merge(data,ath_wheat,by.x='V1',by.y='V2',all.x=T,all.y=F)
me2 <- na.omit(me1)
me2 <- me2[,c(2,1)]
me2 <- unique(me2)

#
TFs <- read.delim('planttfdb_overlap_iTAK.txt',header = F,stringsAsFactors = F)
me3 <- me2[which(me2$V1.y%in%TFs$V1),]
me3 <- unique(me3)
me3 <- me3[,c(2,1)]

write.table(me3,'TF_match.txt',row.names = F,sep = '\t',quote = F,col.names = F)
