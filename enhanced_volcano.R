#import libraries
library(DESeq2)
library(ggplot2)

#input files in csv format
count<-read.csv('count.csv')
meta<-read.csv('metadata.csv')

########################################################
dds<-DESeqDataSetFromMatrix(countData=count, 
                            colData=meta, 
                            design=~condition, tidy = TRUE)
dds<-DESeq(dds)                
res<-results(dds)
res<-na.omit(res)

topT <- as.data.frame(res)

library(EnhancedVolcano)

keyvals <- 
  ifelse(topT$log2FoldChange < -1 & topT$pvalue < 0.05, 'royalblue',
         ifelse(topT$log2FoldChange > 1 & topT$pvalue < 0.05, 'red2',
                'grey30'))

keyvals[is.na(keyvals)] <- 'grey30'
names(keyvals)[keyvals == 'red2'] <- 'upregulated'
names(keyvals)[keyvals == 'grey30'] <- 'not significant'
names(keyvals)[keyvals == 'royalblue'] <- 'downregulated'

empty_labels <- rep("", nrow(topT))

EnhancedVolcano(topT,
                x = 'log2FoldChange',
                y = 'pvalue',
                
                pCutoff = 0.05,
                FCcutoff = 1,
                
                title = 'Control vs. Resistant',
                lab = empty_labels,
                
                cutoffLineType = 'twodash',
                cutoffLineWidth = 0.8,
                pointSize = 2.0,
                labSize = 4.0,
                widthConnectors = 0.05,
                colCustom = keyvals,
                xlim = c(-6, 6),
                ylim = c(0, 12))
