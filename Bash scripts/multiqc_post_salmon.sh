#checking salmon data


#creating directory for files
data_directory="/home/rstudio/data/mydatalocal/data/"
cd $data_directory
mkdir -p test_data_post_salmon
cd test_data_post_salmon


#multiqc analysis

multiqc --outdir \
/home/rstudio/data/mydatalocal/data/test_data_post_salmon/ \
/home/rstudio/data/mydatalocal/data/sra_data_quality/ $data_directory/salmon_analysis
