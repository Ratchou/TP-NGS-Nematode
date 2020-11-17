#Analysis of real trimmed data

#creating directory for fastqc files
data_directory="/home/rstudio/data/mydatalocal/data/"
cd $data_directory
mkdir -p sra_trimmed_data_quality
cd sra_trimmed_data_quality

# fastqc analysis

for fichier in $data_directory/sra_trimmed_data/*
  do
  fastqc $fichier --outdir . -t 6
done

#multiqc analysis

multiqc --outdir \
/home/rstudio/data/mydatalocal/data/sra_trimmed_data_quality/ \
/home/rstudio/data/mydatalocal/data/sra_trimmed_data_quality/