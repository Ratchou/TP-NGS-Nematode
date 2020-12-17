
#Loading DESeq2
library(DESeq2)

#Running DESeq2
sample_names$strain <- factor(sample_names$strain, levels = c("WT", "alg-5", "alg-1"))
dds <- DESeqDataSetFromTximport(txi.salmon,
                              colData = sample_names,
                              design= ~ strain)
dds <- DESeq(dds)

#get the results tables, alpha = 0.05 as in the paper
resultsNames(dds) # lists the coefficients
res_alg5_WT <- results(dds, name = "strain_alg.5_vs_WT", alpha = 0.05)
res_alg1_WT <- results(dds, name = "strain_alg.1_vs_WT", alpha = 0.05)

#order the results
res5_p_Ordered <- res[order(res_alg5_WT$pvalue),]
res1_p_Ordered <- res[order(res_alg1_WT$pvalue),]

summary(res1_p_Ordered)
summary(res5_p_Ordered)

#number of genes for which the adjusted p-value is under 0.05
sum(res_alg1_WT$padj < 0.05, na.rm=TRUE)
sum(res_alg5_WT$padj < 0.05, na.rm=TRUE)

#plotting the results
par(mfrow = c(1,2))
plotMA(res_alg1_WT, ylim=c(-13,13), main="alg-1 vs WT")
plotMA(res_alg5_WT, ylim=c(-13,13), main="alg-5(tm1163) vs WT")

#printing the list of genes included in the analysis


#printing the subset of results which pass the adjusted p-value of 0.05
resSig1_DR <- subset(res1_p_Ordered, (padj < 0.05 & log2FoldChange < 0))
resSig1_UR <- subset(res1_p_Ordered, (padj < 0.05 & log2FoldChange > 0))
resSig5_DR <- subset(res5_p_Ordered, (padj < 0.05 & log2FoldChange < 0))
resSig5_UR <- subset(res5_p_Ordered, (padj < 0.05 & log2FoldChange > 0))

write.table(cbind(rownames(res1_p_Ordered)), row.names = F, col.names = F, quote = FALSE,
            file="all_genes.csv")
write.table(cbind(rownames(resSig1_DR)), row.names = F, col.names = F, quote = FALSE,
          file="alg1_downregulated_genes.csv")
write.table(cbind(rownames(resSig1_UR)), row.names = F, col.names = F, quote = FALSE,
            file="alg1_upregulated_genes.csv")
write.table(cbind(rownames(resSig5_DR)), row.names = F, col.names = F, quote = FALSE,
          file="alg5_downregulated_genes.csv")
write.table(cbind(rownames(resSig5_DR)), row.names = F, col.names = F, quote = FALSE,
            file="alg5_upregulated_genes.csv")