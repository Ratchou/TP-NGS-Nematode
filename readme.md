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