#!/usr/bin/env Rscript

# match conserved PWMs to wheat gene models.

data <- read.delim('conserved_PWM.txt',header = F,stringsAsFactors = F)
data <- data[,1:2]
colnames(data) <- c('tf','target')

ath_wheat <- read.delim('ath_IWGSCv1p1.one2one',header = F,stringsAsFactors = F)
ath_wheat <- ath_wheat[which(ath_wheat$V3=="RBH"),1:2]
colnames(ath_wheat) <- c('ath','wheat')

me1 <- merge(data,ath_wheat,by.x='tf',by.y='ath',all=F)
me1 <- me1[,c(3,2)]
colnames(me1) <- c('wheat_tf','target')

me2 <- merge(me1,ath_wheat,by.x='target',by.y='ath',all = F)

me2 <- me2[,c(2,3)]

write.table(me2,'conserved_PWM_raw.txt',row.names = F,sep = '\t',quote = F,col.names = F)
