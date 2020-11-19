# TP NGS Nematode

Readme du projet NGS 

## Raw RNA-Seq data download

Data was downloaded from the NCBI [Geo database, with the accession code GSE98935](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE98935).

Samples chosen in than work correspond to RNA-Seq data for *Caenorhabditis elegans*:
* N2 (wild type)
* *alg-5(tm1163) I* (mutant)
* *alg-1(gk214) X* (mutant)
in three biological replicates each.

These correspond respectively to accession numbers:
* SRR5564855, SRR5564856, SRR5564857
* SRR5564858, SRR5564859, SRR5564860
* SRR5564861, SRR5564862, SRR5564863

The data was downloaded using the script telechargement.sh
It uses the tool fastq-dump of the SRA-toolkit. 
The downloaded data corresponds to paired-end data, which is why the output format was defined with the `--split-3` option to separate information from paired ends into different fastqc files and output files were zipped using the `--gzip` option.
Rq: the download of the last file stopped with an error report. It was run again individually. 

## Quality analysis of the data

Data quality was analysed using `fastqc` and visualised using `multiqc` (see script fastqc_data.sh).
The Multiqc quality report can be visualized [here](https://github.com/Ratchou/TP-NGS-Nematode/blob/master/multiqc_report.html).
It shows the presence of adapter sequences.

## Sequence cleaning 

Sequence cleaning was performed using the `trimmomatic` tool with the option `-phred33` and the steps `ILLUMINACLIP:$primer_sequence:2:30:10:2:keepBothReads`, `LEADING:3`, `TRAILING:3`, and `SLIDINGWINDOW:4:15`.
The contents of the file `$primer_sequence` are available [here]. 
Data quality was analysed as in the previous section (see script fastqc_trimmed_data.sh)
The Multiqc quality report can be visualized [here](https://github.com/Ratchou/TP-NGS-Nematode/blob/master/multiqc_report2.html).

## Transcript expression quantification
The transcriptome of C. elegans was downloaded from [ensembldatabase](https://www.ensembl.org/index.html):
`curl ftp://ftp.ensembl.org/pub/release-101/fasta/caenorhabditis_elegans/cdna/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz -o celegansT.fa.gz`

It was indexed using the `index` option of salmon (transcriptome_download.sh)

Transcript expression quantification was performed using the `salmon` tool (see salmon.sh script), letting `salmon` automatically detect the library type of sequencing reads (`-lA` option), and giving as input the index previously generated on the transcriptome data and the two trimmed files generated for each sample.
The output data can analysis can be seen [here](https://github.com/Ratchou/TP-NGS-Nematode/blob/master/multiqc_report3.html). 