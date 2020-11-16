# Script to download data

#!/bin/bash

# Create a working directory:

data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

# Create a directory where the data will be downloaded
mkdir -p sra_data_test
cd sra_data_test

# Make a list of SRR accessions:
SRR="SRR5564855
SRR5564856
SRR5564857
SRR5564858
SRR5564859
SRR5564860
SRR5564861
SRR5564862
SRR5564863"

# For each SRR accession, download the data :

for accession in $SRR
do
  fastq-dump --split-3 --gzip -X 100000 --defline-seq '@$ac_$si/$ri' --defline-qual "+" $i
done

# Checking the file

zcat SRR13063853_1.fastq.gz | head -n10

