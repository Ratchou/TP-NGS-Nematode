#Running RAPToR

#Installing the required packages
BiocManager::install("limma")
devtools::install_github("LBMC/RAPToR", build_vignettes = T)
devtools::install_github("LBMC/wormRef")
library("RAPToR")
library("wormRef")

#Choose the right reference library, and loadind the reference dataset, we choose "Cel_larv_YA"
list_refs("wormRef")
ref_dataset <- prepare_refdata("Cel_larv_YA", "wormRef", n.inter = 600)

##Estimating the age of the experimental dataset by comparison to the reference dataset
ae_data <- ae(samp = txi.salmon$abundance, refdata = ref_dataset$interpGE, ref.time_series = ref_dataset$time.series)

#Organising the data by groups
strains <- factor(sample_names$strain, levels = c("WT", "alg-1","alg-5"))

#Plotting the results
par(mfrow=c(1,1))
plot(ae_data, groups = strains, show.boot_estimates = T)
boxplot(ae_data$age.estimates[,1]~strains, 
        main = "Estimated age of each condition",
        xlab = "Strains",
        ylab = "Estimated age (hours post hatching)",
        ylim = c(42, 46),
        names= c("WT", "alg-1(gk214)X", "alg-5(tm1163)I"))
points(ae_data$age.estimates[,1]~strains, lwd=2)


# Analysing the effects of developmental stages on DE analysis.

# These tests perform an differential expression analysis between the samples 
# and between the refrence datasets for each sample, 
# which allows to study the correlation between both
# The analysis is performed independently from DESeq2

getrefTP <- function(ref, ae_obj, ret.idx = T){
  # function to get the indices/GExpr of the reference matching sample age estimates.
  idx <- sapply(ae_obj$age.estimates[,1], function(t) which.min(abs(ref$time.series - t)))
  if(ret.idx)
    return(idx)
  return(ref$interpGE[,idx])
}

getrefTP(ref_dataset, ae_data)

refCompare <- function(samp, ref, ae_obj, fac){
  # function to compute the reference changes and the observed changes
  ovl <- format_to_ref(samp, getrefTP(ref, ae_obj, ret.idx = F))
  lm_samp <- lm(t(ovl$samp)~fac)
  lm_ref <- lm(t(ovl$ref)~fac)
  return(list(samp=lm_samp, ref=lm_ref, ovl_genelist=ovl$inter.genes))
}

rc <- refCompare(samp = log1p(txi.salmon$abundance), 
                 ref = ref_dataset, 
                 ae_obj = ae_data, 
                 fac = strains)

# rc$samp$coefficients and rc$ref$coefficients have 3 lines, 
# 2nd line gives the changes for alg-1 vs WT, 3rd line gives changes for alg5 vs WT
print(rc$samp$coefficients[, 1:5])
print(rc$ref$coefficients[, 1:5])

#We determine the correlation between the change for the sample and the change for the reference
cor(rc$samp$coefficients[2, ], rc$ref$coefficients[2, ])#alg-1 0.5280868
cor(rc$samp$coefficients[3, ], rc$ref$coefficients[3, ])#alg-5 0.322157

#plot logFCs ref vs samp
col_alg1 <- rep("grey", length(rc$ovl_genelist))

col_alg5 <- rep("grey", length(rc$ovl_genelist))

par(pty = 's', mfrow=c(1,2))
plot(x = rc$samp$coefficients[2, ], y = rc$ref$coefficients[2, ], 
     xlim=c(-4, 5), ylim=c(-5, 4), 
     main = "alg1 vs WT", 
     xlab = "samples log1p(FC)", ylab = "reference log1p(FC)",
     col = col_alg1,
     pch = 19)
points(x= rc$samp$coefficients[2,rc$ovl_genelist %in% cbind(rownames(resSig1_DR))], 
       y = rc$ref$coefficients[2,rc$ovl_genelist %in% cbind(rownames(resSig1_DR))],
       col ="lightpink",
       pch = 1)
points(x= rc$samp$coefficients[2,rc$ovl_genelist %in% cbind(rownames(resSig1_UR))], 
       y = rc$ref$coefficients[2,rc$ovl_genelist %in% cbind(rownames(resSig1_UR))],
       col ="lightcoral",
       pch = 1)
legend('bottomright', legend = c('downregulated', 'upregulated', 'not significant'), 
       col = c('lightpink', 'lightcoral', 'grey'), pch = c(1, 1 ,19), pt.cex = 1.5)

plot(x = rc$samp$coefficients[3, ], y = rc$ref$coefficients[3, ], 
     xlim=c(-4, 5), ylim=c(-5, 4), 
     main = "alg5(tm1163) vs WT", 
     xlab = "samples log1p(FC)", ylab = "reference log1p(FC)",
     col = col_alg5,
     pch = 19)
points(x= rc$samp$coefficients[3,rc$ovl_genelist %in% cbind(rownames(resSig5_DR))], 
       y = rc$ref$coefficients[3,rc$ovl_genelist %in% cbind(rownames(resSig5_DR))],
       col ="lightpink",
       pch = 1)
points(x= rc$samp$coefficients[3,rc$ovl_genelist %in% cbind(rownames(resSig5_UR))], 
       y = rc$ref$coefficients[3,rc$ovl_genelist %in% cbind(rownames(resSig5_UR))],
       col ="lightcoral",
       pch = 1)

legend('bottomright', legend = c('downregulated', 'upregulated', 'not significant'), 
       col = c('lightpink', 'lightcoral', 'grey'), pch = c(1, 1 ,19) , pt.cex = 1.5)


#Getting the correlation coefficients just for the genes differentially expressed in the DESeq2 analysis

#for alg1 0.3897111
cor(rc$samp$coefficients[2, 
                         (rc$ovl_genelist %in% cbind(rownames(resSig1_DR))) | (rc$ovl_genelist %in% cbind(rownames(resSig1_DR)))], 
    rc$ref$coefficients[2, 
                        (rc$ovl_genelist %in% cbind(rownames(resSig1_DR))) | (rc$ovl_genelist %in% cbind(rownames(resSig1_DR)))])

#for alg5 -0.2811763
cor(rc$samp$coefficients[3, 
                         (rc$ovl_genelist %in% cbind(rownames(resSig5_DR))) | (rc$ovl_genelist %in% cbind(rownames(resSig5_DR)))], 
    rc$ref$coefficients[3, 
                        (rc$ovl_genelist %in% cbind(rownames(resSig5_DR))) | (rc$ovl_genelist %in% cbind(rownames(resSig5_DR)))])

