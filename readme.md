# TP NGS Nematode

Readme du projet NGS 

## Project aims 

Lon non-coding RNAs have been shown to have an impact in a variety of organisms. In *Caenorhabditis elegans*, long non-coding RNAs intreact with argonaut proteins such as ALG-1 or ALG-5, and are thought to have a variety of effects on gene expression.

We here try to reproduce the results obtained in 
**Brown, Kristen C, Joshua M Svendsen, Rachel M Tucci, Brooke E Montgomery, and Taiowa A Montgomery.
2017. “ALG-5 Is a miRNA-Associated Argonaute Required for Proper Developmental Timing in the
Caenorhabditis Elegans Germline.” Nucleic Acids Research 45 (15). Oxford University Press: 9093–9107.**
where the authors generated four mutant lines for various Argonaut proteins (ALG-1, ALG-2, andALG-5) in *C. elegans*, so as to compare gene expression in this background with RNA seq. 
However, *C. elegans* is a fast developing organism (65 hours), thus, a classic sample might contain individuals at different developmental stages. We therefore additionnaly propose a critical discussion of the results, by an analysis of the effects of developmental variation on the RNA-seq results.

## Software 

### Tools
* sratoolkit.2.10.0
[https://hpc.nih.gov/apps/sratoolkit.html](https://hpc.nih.gov/apps/sratoolkit.html)
* FastQC v0.11.8
[https://www.bioinformatics.babraham.ac.uk/projects/fastqc/](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* multiqc version 1.9
[https://multiqc.info/](https://multiqc.info/)
* Trimmomatic version 0.39
[http://www.usadellab.org/cms/?page=trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
* salmon 0.14.1
[https://combine-lab.github.io/salmon/](https://combine-lab.github.io/salmon/)

### R and R packages
* R version 4.0.3
* devtools version 2.3.2
[https://www.r-project.org/nosvn/pandoc/devtools.html](https://www.r-project.org/nosvn/pandoc/devtools.html)
* limma version 3.46.0
[https://bioconductor.org/packages/release/bioc/html/limma.html](https://bioconductor.org/packages/release/bioc/html/limma.html)
* tximport version 1.18.0
[https://bioconductor.org/packages/release/bioc/html/tximport.html](https://bioconductor.org/packages/release/bioc/html/tximport.html)
* RAPToR version 1.1.4
[https://github.com/LBMC/RAPToR](https://github.com/LBMC/RAPToR)
* wormRef version 0.4.0
[https://github.com/LBMC/wormRef](https://github.com/LBMC/wormRef)
* DESeq2 version 1.30.0
[https://bioconductor.org/packages/release/bioc/html/DESeq2.html](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)

### OS
The analysis was performed on Ubuntu 20.04 LTS.

## Raw RNA-Seq data download

Data was downloaded from the NCBI [Geo database, with the accession code GSE98935](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE98935).

Samples chosen in that work correspond to RNA-Seq data for *Caenorhabditis elegans*:
* N2 (wild type)
* *alg-5(tm1163) I* (mutant)
* *alg-1(gk214) X* (mutant)
in three biological replicates each.

These correspond respectively to accession numbers:
* SRR5564855, SRR5564856, SRR5564857
* SRR5564858, SRR5564859, SRR5564860
* SRR5564861, SRR5564862, SRR5564863

The data was downloaded using the script `telechargement.sh`
It uses the tool `fastq-dump` of the SRA-toolkit. 
The downloaded data corresponds to paired-end data, which is why the output format was defined with the `--split-3` option to separate information from paired ends into different `fastq` files and output files were zipped using the `--gzip` option.

Rq: the download of the last file stopped with an error report. It was run again individually. 

## Quality analysis of the data

Data quality was analysed using `fastqc` and visualised using `multiqc` (see script `fastqc_data.sh`).
The Multiqc quality report can be visualized [here](https://github.com/Ratchou/TP-NGS-Nematode/blob/master/multiqc_report.html).
It shows the presence of adapter sequences.

## Sequence cleaning 

Sequence cleaning was performed using the `trimmomatic` tool with the option `-phred33` and the steps:
* `ILLUMINACLIP:$primer_sequence:2:30:10:2:keepBothReads`: this step cuts adapter Illumina-specific sequences of the `primer_sequence.txt` file from the data,
a maximum mismatch count of 2 which still allowed a full match to be performed, a
palindromeClipThreshold of 30 specifying how accurate the match between the two 'adapter ligated' reads must be for PE palindrome read alignment, and a
simpleClipThreshold of 10 specifying how accurate the match between any adapter sequence must be against a read. The `:2:keepBothReads` option allowed to keep redundant information.
* `LEADING:3`, `TRAILING:3`: minimum quality to keep a base set to 3
* `SLIDINGWINDOW:4:15` this option averages the quality of the data over a sliding window of 4 bases and cuts under a quality threshold of 15.

The contents of the file `$primer_sequence` are available [here](https://github.com/Ratchou/TP-NGS-Nematode/commit/374513a43fa102d73a0f401ed20d04311b425a4e). 
Data quality was analysed as in the previous section (see script `fastqc_trimmed_data.sh`)
The Multiqc quality report can be visualized [here](https://github.com/Ratchou/TP-NGS-Nematode/blob/master/multiqc_report2.html).

## Transcript expression quantification
The transcriptome of C. elegans (Caenorhabditis elegans assembly: WBcel235, last updated on 06/08/2020) was downloaded from [ensembldatabase](https://www.ensembl.org/Caenorhabditis_elegans/Info/Index)

It was indexed using the `index` option of `salmon` (`transcriptome_download.sh`)

Transcript expression quantification was performed using the `salmon` tool (see `salmon.sh` script), letting `salmon` automatically detect the library type of sequencing reads (`-lA` option), and giving as input the index previously generated on the transcriptome data and the two trimmed files generated for each sample.
The output data can analysis can be seen [here](https://github.com/Ratchou/TP-NGS-Nematode/blob/master/multiqc_report3.html). 

## Differential expression analysis

### Data import with `tximport`
This can be found in the `data import with tximport`script.
The differential expression analysis was run using the matrix of counts generated previously.
The matrix of counts was imported using the `tximport`  package in R [https://wormbase.org/tools/enrichment/tea/tea.cgi](https://wormbase.org/tools/enrichment/tea/tea.cgi). 
The corresponding code can be found in the `data import with tximport script`.
The tximport function was run with the arguments 
* `type='salmon'` to indicate that the input data is salmon data
* `tx2gene = wormRef::Cel_genes[, c("transcript_name", "wb_id")]`: this argument allows to match the gene and the gene id generated during the salmon analysis. Here we use the reference file from wormRef for *C. elegans*.

### Differential expression analysis with DESeq2
A differential expression analysis was run using the R package `DESeq2`. The corresponding code can be found in the script `DESeq analysis`.
The `DESeq` function of DESeq2 was applied to a `dds`object containing the dataset imported in the previous step in a DESeq2 format. The results were selected for an alpha cutoff of 0.05 as in the cited article. 
We found 2422 genes for which the adjusted p-value for differential expression was under 0.05 between WT and *alg1*, and 109 between WT and *alg5*.
These genes are represented in the following graph. Blue dots represent genes showing significant differences in expression.

<img src="https://github.com/Ratchou/TP-NGS-Nematode/blob/master/DESeq2%20plots.png" alt="DESeq2 analysis. Blue dots represent genes showing significant differences in expression." width="100%"/>

### GO terms analysis
Following the DESeq2 analysis, lists of upregulated and downregulated genes were generated and submitted to a GO term analysis on the [Wormbase tool](https://wormbase.org/tools/enrichment/tea/tea.cgi). 
Associated results tables and terms can be viewed in the `GO analysis` folder. 
As in the cited article, *alg5* presented few differentially expressed genes and the GO analysis did not provide a lot of statistically significant categories. 
For *alg1*, a number of categories are associated with molting, life cycle, or defense response, which are vast categories potentially influenced by impairements or delays in development due to the mutation. To try to investigate the influence of the developmental effects, we used the `RAPToR` package.

## Analysis of developmental effects on the differential expression analysis using RAPToR
As explained above, a mutation may have a specific effect on a number of actually significant targets, but the changes in the expression of these, in turn, might lead to changes in developmental timing, resulting in a broad modification of the gene expression pattern. 
To try to separate the effects of the mutation for this potential developmental bias, we used the package RAPToR, which estimates the developmental age of each sample against a reference (`RAPToR` script).
The reference dataset was here built from wormRef with the `prepare_refdata` function. We chose `"Cel_larv_YA"` stage from the wormRef base according to the ages stated in the cited reference, and `n.inter=600`.
The age of the experimental dataset was estimated with the `ae` function, which we ran on the abundances from the salmon data imported with tximport. 
The results are shown in the plot below.

<img src="https://github.com/Ratchou/TP-NGS-Nematode/blob/master/Estimated%20age.png" alt="Estimated age." width="50%"/>

Once this analysis performed, one can estimate the change between two reference samples (`getrefTP` function of the `RAPToR` script) for two studied lines, and compute the correlation with the change experimentally observed between the two samples (`refCompare` function of the `RAPToR` script). 
For *alg1*, we found a correlation coefficient r=0.528 , and for *alg5*, r=0.322.
This can be visualized in the following graph.

<img src="https://github.com/Ratchou/TP-NGS-Nematode/blob/master/Correlation%20plots%20RAPToR.png" alt="Correlation between change for age references and change for samples." width="100%"/>

Genes differentially expressed only in the experimental data would align on the y=0 line.

## How to get rid of developmental bias?
Thus, we see that the developmental changes potentially have an important impact on the results cited in the paper. To distinguish both it might be possible to perform a differential expression analysis on data normalized to the reference sample (for example, by dividing the counts for each gene in the experimental sample by the counts for each gene on the reference sample).