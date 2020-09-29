# Setting wd
# setwd("~/Dropbox/Research/PhD/Bioinformatics/Datasets/Dataset_TCGA_BRCA/data/RNAseq")
library(tidyverse)
# getting list of files 
system("ls -1 ./data/RNAseq/read_counts > ./data/RNAseq/count_filenames.txt")

# loading list of files
count_filenames <- read.delim("./data/RNAseq/count_filenames.txt", header = F)
count_filenames <- count_filenames$V1 %>% as.character()

# Getting sample names
count_sample_names <- gsub(".htseq.counts.txt", "", count_filenames)

# Removing dataframe 
if(exists("TCGA_BRCA_COUNTS_DF")){
  rm(TCGA_BRCA_COUNTS_DF) 
} 


# Building combined table
for (i in count_filenames) {
  # Reading file 
  file_path <- paste("./data/RNAseq/read_counts/", i, sep = "")
  input_df <- read.delim(file_path, header = F)
  
  if(exists("TCGA_BRCA_COUNTS_DF")){
    TCGA_BRCA_COUNTS_DF <- left_join(TCGA_BRCA_COUNTS_DF, input_df, by="V1")
  } else {
    TCGA_BRCA_COUNTS_DF <- input_df
  }
}

# Creating sample reference table
ID <- seq(1, length(count_sample_names)) %>% as.character()
ID <- paste0("ID_", ID)
CASE_ID <- count_sample_names
FILENAME <- count_filenames
ID_REF_TABLE <- data.frame(ID, CASE_ID, FILENAME)
write_delim(ID_REF_TABLE, path = "./data/RNAseq/combined_count_data/ID_REF_TABLE.txt")

# Renaming columns
colnames(TCGA_BRCA_COUNTS_DF) <- c("ENSEMBL_ID", count_sample_names)

# Saving count df
dir.create("./data/RNAseq/combined_count_data/", recursive = T, showWarnings = F)
write_delim(TCGA_BRCA_COUNTS_DF, path = "./data/RNAseq/combined_count_data/TCGA_BRCA_COUNTS_DF.txt")
save(TCGA_BRCA_COUNTS_DF, ID_REF_TABLE, file = "./data/RNAseq/combined_count_data/TCGA_BRCA_COUNTS.RData")

