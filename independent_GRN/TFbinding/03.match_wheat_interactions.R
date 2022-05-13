#!/usr/bin/env Rscript

# map TFbinding interactions to wheat gene models.

edges <- read.delim('DAP_ChIP.txt',header = F,stringsAsFactors = F)
colnames(edges) <- c('tu_tf','tu_target')

homologs <- read.delim('genetribe_tu_IWGSCv1p1.one2one',header = F,stringsAsFactors = F)
colnames(homologs) <- c('tu','wheat','type','chr')

me1 <- merge(edges,homologs,by.x='tu_tf',by.y='tu',all=F)
me1 <- me1[which(me1$type=="RBH"),c(3,2)]
colnames(me1) <- c('wheat_tf','tu_target')

me2 <- merge(me1,homologs,by.x='tu_target',by.y='tu',all=F)

final <- me2[which(me2$type=="RBH"),2:3]

final <- unique(final)

TFs <- read.delim('planttfdb_overlap_iTAK.txt',header = F,stringsAsFactors = F)

final2 <- final[which(final$wheat_tf%in%TFs$V1),]

write.table(final2,'DAP_ChIP_edge.txt',row.names = F,col.names = F,sep = '\t',quote = F)

system("cat DAP_ChIP_edge.txt | gawk -vOFS='\t' '{print $0,1}' > DAP_ChIP_edge.2.txt")
