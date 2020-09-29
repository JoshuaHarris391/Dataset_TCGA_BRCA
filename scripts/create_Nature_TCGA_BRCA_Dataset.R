library(tidyverse)
# Loading Nature clinical information and counts
load(file = "data/clinical/FB_BRCA_TCGA.RData")
# Finding matched patients in both datasets
keep <- match(NATURE_CLIN$Complete_TCGA_ID, colnames(EXP_COUNTS)) %>% na.omit()
# Extrating gene names and entrz ids
TCGA_NATURE_GENE_ID <- EXP_COUNTS[, 1:2]
# Subsetting counts df
TCGA_NATURE_COUNTS <- EXP_COUNTS[, keep]
# Making row names entrz_ID names
rownames(TCGA_NATURE_COUNTS) <- TCGA_NATURE_GENE_ID$Entrez_ID
# Adding HR/HER2 subtype 
source(file = "scripts/function_HR_HER2_Subtype.R")
TCGA_NATURE_CLIN <- subtype_HR_HER2("ER_Status", "PR_Status", "HER2_Final_Status", "Complete_TCGA_ID", NATURE_CLIN_COUNTS)
# Creating CPM dataframe 
TCGA_NATURE_CPM <- edgeR::cpm(TCGA_NATURE_COUNTS) %>% as.data.frame()
# Saving TCGA_NATURE datbase
system("mkdir -p 'data/Nature'")
save(TCGA_NATURE_CLIN, TCGA_NATURE_COUNTS, TCGA_NATURE_GENE_ID, TCGA_NATURE_CPM, file = "data/Nature/TCGA_NATURE.Rdata")
