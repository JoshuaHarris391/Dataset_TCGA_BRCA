#######################################################
# Download and copy data
#######################################################
rm(list = ls())
# system("bash scripts/download_tcga_brca_rnaseq.sh")
# system("bash scripts/copy_Firebrowse_clinical.sh")


#######################################################
# Combine count data
#######################################################
# system("bash scripts/combine_counts.sh")
source(file = "scripts/combine_export_data.R")


#######################################################
# Importing clinical data from firebrowse and matching to samples
# Subset counts df to match patients with clincal annotation
# Add additional clinical variables from nature clin
#######################################################
rm(list = ls())
source(file = "scripts/match_clinical_annotation.R")


#######################################################
# Adding Subtype information
#######################################################
source(file = "scripts/annotate_clin_subtype.R")
source(file = "scripts/annotate_clin_subtype_nature.R")


#######################################################
# Calculating CPM on TMM normalised counts
#######################################################
source(file = "scripts/edgeR_TMM_count_normalisation.R")

#######################################################
# Saving clinical df and counts
#######################################################
# Saving count df
dir.create("./data/Matched_Data", recursive = T, showWarnings = F)
write_delim(TCGA_BRCA_COUNTS_DF_CLIN_MATCHED, path = "./data/Matched_Data/TCGA_BRCA_COUNTS_DF_CLIN_MATCHED.txt")
write_delim(TCGA_BRCA_CPM_DF_CLIN_MATCHED, path = "./data/Matched_Data/TCGA_BRCA_CPM_DF_CLIN_MATCHED.txt")
write_delim(TCGA_BRCA_CLIN_MATCHED, path = "./data/Matched_Data/TCGA_BRCA_CLIN_MATCHED.txt")
write_delim(GENE_ID_REF, path = "./data/Matched_Data/GENE_ID_REF")
save(TCGA_BRCA_COUNTS_DF_CLIN_MATCHED, TCGA_BRCA_CLIN_MATCHED, GENE_ID_REF, TCGA_BRCA_CPM_DF_CLIN_MATCHED, file = "./data/Matched_Data/TCGA_BRCA_DATASET_MATCHED.Rdata")

# Loading newly saved data
rm(list = ls())
load(file = "./data/Matched_Data/TCGA_BRCA_DATASET_MATCHED.Rdata")
