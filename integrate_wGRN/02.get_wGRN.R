#!/usr/bin/env Rscript

# combine high-quality interactions into wheat integrative regulatory network.

# remove low-quality
system("cat all_matrix.txt | gawk '{num=$2+$3+$4+$5+$6+$7+$8;if($7+$8!=num&&$5+$8!=num&&$4+$8!=num&&$4+$5+$8!=num)print}' > all_matrix_removeOnlyPWM.txt")
data2 <- read.delim('all_matrix_removeOnlyPWM.txt',header = F,stringsAsFactors = F)
colnames(data2) <- c('interactions','PCC','GENIE3','cCOE','PWM','cPWM','TFbinding','openchromatin')

# normalize GENIE3
max_GENIE3 <- max(data2$GENIE3)
data2$GENIE3 <- (data2$GENIE3/max_GENIE3)/2+0.5
data2[which(data2$GENIE3==0.5),"GENIE3"] <- 0
# normalize PWM
data2[which(data2$PWM<0),'PWM'] <- 0
max_PWM <- max(data2$PWM)
data2$PWM <- (data2$PWM/max_PWM)/2+0.5
data2[which(data2$PWM==0.5),"PWM"] <- 0
# normalize cPWM
data2[which(data2$cPWM<0),'cPWM'] <- 0
max_cPWM <- max(data2$cPWM)
data2$cPWM <- (data2$cPWM/max_cPWM)/2+0.5
data2[which(data2$cPWM==0.5),"cPWM"] <- 0
# normalize open chromatin
data2$openchromatin <- log2(data2$openchromatin+1)
max_openchromatin <- max(data2$openchromatin)
data2$openchromatin <- (data2$openchromatin/max_openchromatin)/2+0.5
data2[which(data2$openchromatin==0.5),"openchromatin"] <- 0

# sum
data3 <- data2[,2:8]
data2$sum <- apply(data3,1,sum)

# filter
data4 <- data2[which(data2$sum>=1.4),]
write.table(data4,'highQuality_interactions.txt',row.names = F,col.names = T,sep = '\t',quote = F)

system("cut -f1 highQuality_interactions.txt | sed 1d | sed 's/_/\t/g' > highQuality_interactions.list")
