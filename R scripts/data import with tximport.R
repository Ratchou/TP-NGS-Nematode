# Import of salmon files with tximport
library(devtools)
BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = T)
devtools::install_github("LBMC/wormRef")

#import of tximport
library(tximport)

accessions_files <- c("SRR5564855_quantif","SRR5564856_quantif","SRR5564857_quantif",
                "SRR5564858_quantif","SRR5564859_quantif","SRR5564860_quantif",
                "SRR5564861_quantif","SRR5564862_quantif","SRR5564863_quantif")
samples <- c("SRR5564855","SRR5564856","SRR5564857",
             "SRR5564858","SRR5564859","SRR5564860",
             "SRR5564861","SRR5564862","SRR5564863")
salmon_directory <- "/ifb/data/mydatalocal/data/salmon_analysis"
files <- file.path(salmon_directory, accessions, "quant.sf")
sample_names <- read.table("sample_names.csv", header=TRUE, sep=';')
names(files) <- (sample_names$sample_name)
txi.salmon <- tximport(files, type = "salmon", tx2gene = wormRef::Cel_genes[, c("transcript_name", "wb_id")])
head(txi.salmon$counts)



