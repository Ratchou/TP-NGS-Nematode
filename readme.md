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