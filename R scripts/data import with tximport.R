# Import of salmon files with tximport
library(devtools)
BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = T)
devtools::install_github("LBMC/wormRef")

#import of tximport
library(tximport)

#import the matrix of counts in the right format for DESeq2 with tximport
#prior to running this code, a file "sample_names.csv" was created, with SRR ID, sample name (strain+replicate), and strain information for ecah sample

#getting the salmon files
accessions <- c("SRR5564855_quantif","SRR5564856_quantif","SRR5564857_quantif",
                "SRR5564858_quantif","SRR5564859_quantif","SRR5564860_quantif",
                "SRR5564861_quantif","SRR5564862_quantif","SRR5564863_quantif")
samples <- c("SRR5564855","SRR5564856","SRR5564857",
             "SRR5564858","SRR5564859","SRR5564860",
             "SRR5564861","SRR5564862","SRR5564863")
salmon_directory <- "/ifb/data/mydatalocal/data/salmon_analysis"
files <- file.path(salmon_directory, accessions, "quant.sf")
#renaming the files
sample_names <- read.table("sample_names.csv", header=TRUE, sep=';')
names(files) <- (sample_names$sample_name)

#running tximport
txi.salmon <- tximport(files, type = "salmon", tx2gene = wormRef::Cel_genes[, c("transcript_name", "wb_id")])
head(txi.salmon$counts)

#checking the data graphically
logcounts <- log1p(txi.salmon$counts)
head(logcounts)
plot(logcounts[,1], logcounts[,2], 
     main = "WT1 vs WT2", xlab = "WT1", ylab = "WT2")


#log representation of counts
logcounts <- log1p(txi.salmon$counts)

par(mfrow = c(1,2))
plot(logcounts[, 1], logcounts[, 2], 
     main = "1 vs 2", xlab = "1", ylab = "2")

plot(logcounts[, 1], logcounts[, 5], 
     main = "1 vs 5", xlab = "1", ylab = "5")

#plotting variance vs mean expression for the dataset
vargenes <- apply(logcounts, 1, var)
avggenes <- apply(logcounts, 1, mean)

plot(avggenes, vargenes)


