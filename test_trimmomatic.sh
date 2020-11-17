#Script for the trimming of the data by trimmomatic

#!/bin/bash

#depository with the data
DataDirectory="/home/rstudio/data/mydatalocal/data/sra_data_test/"

#name of accesssions
SRR="SRR5564855
SRR5564856
SRR5564857
SRR5564858
SRR5564859
SRR5564860
SRR5564861
SRR5564862
SRR5564863"

#Running the trimomatic on the data
primer_sequence="data/mydatalocal/TP-NGS-Nematode/primers.fasta"
cd $DataDirectory
cd ../
mkdir -p sra_trimmed_data_test
cd sra_trimmed_data_test

for nom in $SRR
do
  nom1="$DataDirectory/${nom}_1.fastq.gz"
  nom2="$DataDirectory/${nom}_2.fastq.gz"
  paired_output_1="paired_${nom}_1.fastq.gz"
  unpaired_output_1="unpaired_${nom}_1.fastq.gz"
  paired_output_2="paired_${nom}_2.fastq.gz"
  unpaired_output_2="unpaired_${nom}_2.fastq.gz"
  java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar \
  PE -phred33 $nom1 $nom2 \
  $paired_output_1 $unpaired_output_1 $paired_output_2 $unpaired_output_2 \
  ILLUMINACLIP:primers.fasta:2:30:10:2:keepBothReads \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15
done


