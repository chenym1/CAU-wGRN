#!/usr/bin/env Rscript

# merge TPMs

library(tximport)
library(dplyr)
library(rjson)

#samples
samplelist <- read.delim('highquality_RNA-seq_sample.txt',header = F,stringsAsFactors = F)
samplelist <- samplelist$V1

# mapping stat 
total_stat <- data.frame(stringsAsFactors = F)
for(i in 1:length(samplelist)){
  sample <- samplelist[i]
  data <- fromJSON(file = paste0(sample,'/run_info.json'))
  total_stat[i,1] <- sample
  total_stat[i,2:12] <- as.character(data)
}

# transcript to gene id
t2g <- read.table('transcript2gene.txt', header = TRUE,stringsAsFactors = F)

# kallisto sample list
files <- c()
for(sample in samplelist){
  files <- c(files,paste0(sample,'/abundance.tsv'))
}
names(files) <- samplelist

# merge TPMs
data <- tximport(files, type = "kallisto", tx2gene = t2g)
save(data,file = 'tximport_out.Rdata')
counts <- data.frame(data$abundance,stringsAsFactors = F)
write.table(counts,'TPMs.txt',sep = '\t',quote = F)


fileexp <- function(x){
  x <- as.numeric(x)
  exp_sample_num <- length(which(x>=3))
  if (exp_sample_num>=2){
    exp <- TRUE
  }else{
    exp <- FALSE
  }
  return(exp)
}

exp_counts <- counts[apply(counts,1,fileexp),]

write.table(exp_counts,'exp_TPMs.txt',sep = '\t',quote = F)

