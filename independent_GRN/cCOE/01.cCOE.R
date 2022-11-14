#!/usr/bin/env Rscript

# map PCC and GENIE3 networks to wheat gene models.

rice_PCC <- 'rice_PCCs.unique.txt'
rice_GENIE3 <- 'rice_links.filtered.txt'
rice_wheat_homolog <- 'rice_wGRNv1.one2one'

# input
pcc <- read.delim(rice_PCC,header = T,stringsAsFactors = F)
colnames(pcc) <- c('TF','target','pcc')
pcc$label <- paste0(pcc$TF,'_',pcc$target)
pcc <- pcc[,c("label","pcc")]

genie3 <- read.delim(rice_GENIE3,header = T,stringsAsFactors = F)
genie3$label <- paste0(genie3$regulatoryGene,'_',genie3$targetGene)
genie3 <- genie3[,c("label","weight")]

# norm interaction scores
me <- merge(pcc,genie3,by='label',all=T)
data2 <- me
data2[is.na(data2)] <- 0

# norm GENIE3
max_GENIE3 <- max(data2$weight)
data2$weight <- (data2$weight/max_GENIE3)/2+0.5
data2[which(data2$weight==0.5),"weight"] <- 0
data2$value <- (data2$pcc+data2$weight)/2
write.table(data2,'merge_PCC_GENIE3.txt',row.names = F,col.names = F,sep = '\t',quote = F)
system("cut -f1,4 merge_PCC_GENIE3.txt | sed 's/_/\t/g' > cCOE.txt")

#
data <- read.delim('cCOE.txt',header = F,stringsAsFactors = F)
colnames(data) <- c('TF','target','value')

#
wheat_rice_homo <- read.delim(rice_wheat_homolog,header = F,stringsAsFactors = F)
wheat_rice_homo <- wheat_rice_homo[which(wheat_rice_homo$V3=="RBH"),1:2]
colnames(wheat_rice_homo) <- c('rice','wheat')

# 
me1 <- merge(data,wheat_rice_homo,by.x='TF',by.y='rice')
me2 <- merge(me1,wheat_rice_homo,by.x='target',by.y='rice')

me2 <- me2[,c(4,5,3)]
colnames(me2) <- c('TF','target','value')

write.table(me2,'cCOE_towheat.txt',row.names = F,col.names = F,sep = '\t',quote = F)

