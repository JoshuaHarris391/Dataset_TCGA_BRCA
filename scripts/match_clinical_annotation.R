library(tidyverse)
# loading FB data
load(file = "data/clinical/FB_BRCA_TCGA.RData")
# Loading processed TCGA data
load(file = "data/RNAseq/combined_count_data/TCGA_BRCA_COUNTS.RData")

# Importing json file with UUIDs and filenames
UUID_FILENAMES_REF <- jsonlite::fromJSON("./gdc_manifest/gdc_uuid_filename.json")

# Extracting case ID
CASE_ID <- list()
for (i in 1:nrow(UUID_FILENAMES_REF)) {
  CASE_ID[paste0(i)] <- UUID_FILENAMES_REF[i, "cases"][[1]] %>% select(case_id) %>% as.character()
}
UUID_FILENAMES_REF$CASE_ID <- unlist(CASE_ID)
# Creating new column for filename_ID
UUID_FILENAMES_REF$FILENAME_REF <-  gsub("\\.htseq\\.counts\\.gz", "", UUID_FILENAMES_REF$file_name)


# Loading TCGA raw clinical df
RAW_TCGA_CLIN <- read.table(file = "data/clinical/clinical.cases_selection.2020-04-01/clinical.tsv", header = T, sep = "\t")
# Subsetting case ID and submitter ID
RAW_TCGA_CLIN_lookup <- RAW_TCGA_CLIN[, 1:2] %>% as.data.frame()
# Removing duplicates
RAW_TCGA_CLIN_lookup <- dplyr::filter(RAW_TCGA_CLIN_lookup, !(duplicated(RAW_TCGA_CLIN_lookup$case_id)))
# Renaming cols
colnames(RAW_TCGA_CLIN_lookup) <- c("CASE_ID", "PATIENT_ID")
# Making data char vectors
RAW_TCGA_CLIN_lookup[] <- lapply(RAW_TCGA_CLIN_lookup, as.character) 
# Matching filename UUID to RAW_TCGA_CLIN_lookup
m <- match(RAW_TCGA_CLIN_lookup$CASE_ID, UUID_FILENAMES_REF$CASE_ID)
RAW_TCGA_CLIN_lookup$FILENAME_REF <- UUID_FILENAMES_REF[m, "FILENAME_REF"]

# Joining RAW_TCGA_CLIN_lookup to CLIN_POST 
dim(CLIN_POST)
dim(RAW_TCGA_CLIN_lookup)
TCGA_BRCA_CLIN_MATCHED <- dplyr::inner_join(RAW_TCGA_CLIN_lookup, CLIN_POST, by = "PATIENT_ID")

# Adding in Nature clin by left join. Missing cases from nature clin will just get NA
colnames(NATURE_CLIN)[1] <- "PATIENT_ID"
TCGA_BRCA_CLIN_MATCHED <- dplyr::left_join(TCGA_BRCA_CLIN_MATCHED, NATURE_CLIN, by = "PATIENT_ID")

########################################################################
# Subsetting count DF for patients that have clinical annotation
########################################################################
m <- match(TCGA_BRCA_CLIN_MATCHED$FILENAME_REF, colnames(TCGA_BRCA_COUNTS_DF))
# Adding ensemble ID column to match reference
m <- c(1, m)
TCGA_BRCA_COUNTS_DF_CLIN_MATCHED <- TCGA_BRCA_COUNTS_DF[, m]

# Saving full ensembl IDs into vector
ENSEMBL_ID_FULL_DF <- TCGA_BRCA_COUNTS_DF_CLIN_MATCHED[, 'ENSEMBL_ID'] %>% as.data.frame()
ENSEMBL_ID_FULL_DF$GENEID <- TCGA_BRCA_COUNTS_DF_CLIN_MATCHED$ENSEMBL_ID %>%
  str_replace(pattern = ".[0-9]+$",
              replacement = "")
colnames(ENSEMBL_ID_FULL_DF)[1] <- "ENSEMBL_ID_FULL"

# Removing ENSEMBL ID version numbers
TCGA_BRCA_COUNTS_DF_CLIN_MATCHED$ENSEMBL_ID <- TCGA_BRCA_COUNTS_DF_CLIN_MATCHED$ENSEMBL_ID %>%
  str_replace(pattern = ".[0-9]+$",
              replacement = "")

############################################################
# Convert from ensembl.gene to gene.symbol
############################################################
ensembl.genes <- TCGA_BRCA_COUNTS_DF_CLIN_MATCHED$ENSEMBL_ID %>% as.character()
# Creating DF for gene names matched with ensemble IDs
GENE_ID_REF <- ensembldb::select(EnsDb.Hsapiens.v79::EnsDb.Hsapiens.v79, keys= ensembl.genes, keytype = "GENEID", columns = c("SYMBOL","GENEID"))
# Adding full ensemble IDs
GENE_ID_REF <- inner_join(GENE_ID_REF, ENSEMBL_ID_FULL_DF, by = "GENEID")

# Function to find ENSEMBL ID
gene_to_ensembl <- function(gene){
  dplyr::filter(GENE_ID_REF, GENE_ID_REF$SYMBOL == gene) %>% dplyr::select(columns = "GENEID") %>% as.character()
}

# Making ensembl ID rownames
rownames(TCGA_BRCA_COUNTS_DF_CLIN_MATCHED) <- TCGA_BRCA_COUNTS_DF_CLIN_MATCHED$ENSEMBL_ID
# Removing ENSEMBl ID
TCGA_BRCA_COUNTS_DF_CLIN_MATCHED <- dplyr::select(TCGA_BRCA_COUNTS_DF_CLIN_MATCHED, !("ENSEMBL_ID"))


################################################
# Creating matched CPM df
################################################
# loading edge R
library(edgeR)
# converting to CPM
TCGA_BRCA_CPM_DF_CLIN_MATCHED <- edgeR::cpm(TCGA_BRCA_COUNTS_DF_CLIN_MATCHED) %>% as.data.frame()
# Saving df
dir.create("./data/Matched_Data", recursive = T, showWarnings = F)


