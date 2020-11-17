#creating directory for fastqc files
data_directory="/home/rstudio/data/mydatalocal/data/"
cd $data_directory
mkdir -p sra_data_test_quality
cd sra_data_test_quality

# fastqc analysis

for fichier in $data_directory/sra_data_test/*
  do
  fastqc $fichier --outdir . -t 6
done