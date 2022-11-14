#!/usr/bin/env Rscript

# the physical network were assigned different weights by considering the distance of PWM to TSS.
# the dynamic parameter α is based on the comprehensive evaluation of wGRN using the TF mutant or overexpression lines.
# combine independent network.

dynamic_parameter_cutoff <- 1.2 

# combine independent.
data2 <- read.delim('all_matrix_removeOnlyPWM.txt',header = F,stringsAsFactors = F)
colnames(data2) <- c('interactions','PCC','GENIE3','cCOE','PWM','cPWM','TFbinding','openchromatin')

# norm GENIE3
max_GENIE3 <- max(data2$GENIE3)
data2$GENIE3 <- (data2$GENIE3/max_GENIE3)/2+0.5
data2[which(data2$GENIE3==0.5),"GENIE3"] <- 0
# norm PWM
data2[which(data2$PWM<0),'PWM'] <- 0
max_PWM <- max(data2$PWM)
data2$PWM <- (data2$PWM/max_PWM)/2+0.5
data2[which(data2$PWM==0.5),"PWM"] <- 0
# norm cPWM
data2[which(data2$cPWM<0),'cPWM'] <- 0
max_cPWM <- max(data2$cPWM)
data2$cPWM <- (data2$cPWM/max_cPWM)/2+0.5
data2[which(data2$cPWM==0.5),"cPWM"] <- 0
# norm TF binding
max_TFbinding <- max(data2$TFbinding)
data2$TFbinding <- (data2$TFbinding/max_TFbinding)/2+0.5
data2[which(data2$TFbinding==0.5),"TFbinding"] <- 0
# norm open chromatin
data2$openchromatin <- log2(data2$openchromatin+1)
max_openchromatin <- max(data2$openchromatin)
data2$openchromatin <- (data2$openchromatin/max_openchromatin)/2+0.5
data2[which(data2$openchromatin==0.5),"openchromatin"] <- 0

# sum
data3 <- data2[,2:8]
data2$sum <- apply(data3,1,sum)

# filter
data4 <- data2[which(data2$sum>=score_cutoff),]
write.table(data4,'highQuality_interactions.txt',row.names = F,col.names = T,sep = '\t',quote = F)

