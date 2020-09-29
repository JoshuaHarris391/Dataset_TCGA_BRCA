# creating DGE object 
library(tidyverse)
library(edgeR)
TCGA_DGE <- edgeR::DGEList(counts=TCGA_BRCA_COUNTS_DF_CLIN_MATCHED, genes=rownames(TCGA_BRCA_COUNTS_DF_CLIN_MATCHED))
# Calculating normalisation factors 
TCGA_DGE <- edgeR::calcNormFactors(TCGA_DGE, method="TMM")
# Calculating TMM normalised CPM
TCGA_BRCA_CPM_DF_CLIN_MATCHED <- edgeR::cpm(TCGA_DGE) %>% as.data.frame()

# References:
# https://hbctraining.github.io/DGE_workshop/lessons/02_DGE_count_normalization.html
# https://www.biostars.org/p/317701/