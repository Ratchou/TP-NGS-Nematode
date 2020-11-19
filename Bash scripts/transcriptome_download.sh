#Downloading and indexing the transcriptome

#definig the directory
main_directory="/home/rstudio/data/mydatalocal/data/"
cd $main_directory
mkdir -p salmon_analysis_test
output_directory="$main_directory/salmon_analysis_test/"
cd $output_directory

# Download the transcriptome

curl ftp://ftp.ensembl.org/pub/release-101/fasta/caenorhabditis_elegans/cdna/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz -o celegansT.fa.gz

#Building an index for salmon

salmon index -t celegansT.fa.gz -i celegans_index
