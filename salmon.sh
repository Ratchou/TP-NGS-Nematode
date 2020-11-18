#Running salmon on the real data

#!/bin/bash

#Defining directories and creating a directory to run salmon

main_directory="/home/rstudio/data/mydatalocal/data/"

#directory where the experimental data is stored
data_directory="$main_directory/sra_trimmed_data/"

#directory where the indexation of C. elegans transcriptome is stored
transcriptome_directory="$main_directory/salmon_analysis_test"

#new directory to êrform the salmon analysis
cd $main_directory
mkdir -p salmon_analysis
output_directory="$main_directory/salmon_analysis/"
cd $output_directory


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
salmon quant -i $transcriptome_directory/celegans_index -l A \
         -1 $sample1 \
         -2 $sample2 \
         -p 8 --validateMappings -o $output_directory/${nom}_quantif
done 
