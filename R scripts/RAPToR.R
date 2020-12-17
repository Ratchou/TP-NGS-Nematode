#Running RAPToR

BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = T)
devtools::install_github("LBMC/wormRef")
library("RAPToR")
library("wormRef")

#Choose the right library, we choose "Cel_larv_YA"
list_refs("wormRef")

#Loading the reference dataset
ref_dataset <- prepare_refdata("Cel_larv_YA", "wormRef", n.inter = 600)

##Comparing the datasets
ae_data <- ae(samp = txi.salmon$abundance, refdata = ref_dataset$interpGE, ref.time_series = ref_dataset$time.series)
#Organising the data by groups
strains <- factor(sample_names$strain, levels = c("WT", "alg-1","alg-5"))
#Plotting the results
plot(ae_data, groups = strains, show.boot_estimates = T)
boxplot(ae_data$age.estimates[,1]~strains, 
        main= "Age estimates for each strain",
        ylab = "age (hours post hatching)",
        ylim = c(42, 46.5))
points(ae_data$age.estimates[,1]~strains, lwd=2)
