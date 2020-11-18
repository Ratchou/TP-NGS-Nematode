#Running salmon on the data

#!/bin/bash

#Defining directories and creating a directory to run salmon
main_directory="/home/rstudio/data/mydatalocal/data/"
data_directory="$main_directory/sra_trimmed_data_test/"
cd $main_directory
mkdir -p salmon_analysis_test
output_directory="$main_directory/salmon_analysis_test/"
cd $output_directory

# Download the transcriptome

curl ftp://ftp.ensembl.org/pub/release-101/fasta/caenorhabditis_elegans/cdna/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz -o celegansT.fa.gz

#Building an index for salmon

salmon index -t celegansT.fa.gz -i celegans_index

#Create a list of accessions

SRR="SRR5564855
SRR5564856
SRR5564857
SRR5564858
SRR5564859
SRR5564860
SRR5564861
SRR5564862
SRR5564863"

# Run the analysis


for nom in $SRR
do
sample1="$data_directory/paired_${nom}_1.fastq.gz"
sample2="$data_directory/paired_${nom}_2.fastq.gz"
echo "Processing sample ${nom}"
salmon quant -i celegans_index -l A \
         -1 $sample1 \
         -2 $sample2 \
         -p 8 --validateMappings -o $output_directory/${nom}_quantif
done 


