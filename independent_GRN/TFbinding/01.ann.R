#!/usr/bin/env Rscript

# annotate DAP-seq peaks on promoters

library(GenomicFeatures)
library(ChIPseeker)
library(diffloop)
library(stringr)

mus <- makeTxDbFromGFF("WheatTu.gene.gff",format = 'gff3')

file_list <- read.delim('sample.list',header = F,stringsAsFactors = F);file_list <- file_list$V1


for (i in 1:length(file_list)){

  file <- file_list[i]
  
  # 500bp
  peakAnno <- annotatePeak(paste0(file,'_peaks.narrowPeak'),
                           tssRegion = c(-500,500),TxDb = mus)
  out <- as.data.frame(peakAnno)
  colnames(out) <- c('chr','start','end','width','strand',
                     'peak','int(-10*log10qvalue)','v',
                     'fold_enrichment','-log10(pvalue)',
                     '-log10(qvalue)','relative summit position to peak start',
                     'annotation','geneChr','geneStart','geneEnd',
                     'geneLength','geneStrand','geneId','transcriptId',
                     'distanceToTSS')
  out <- out[,c(1,2,3,4,6,9,10,11,13,14,15,16,17,18,19,20,21)]

  out2 <- out[str_detect(out$annotation,'Promoter'),]

  write.table(out2,paste0(file,'_ann.txt'),row.names = F,col.names = T,quote=F,sep = '\t')

}
