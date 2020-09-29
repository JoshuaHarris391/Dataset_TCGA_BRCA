# Building combined DF from XMLs
source("scripts/Convert_XML_to_DF.R")
# Loading xml file path file
xml_file_paths <- read.table("data/gdc_clinial_combined_xml_filenames.txt", header = F)
xml_file_paths <- as.list(xml_file_paths$V1)

# Initialising dataframe 
gdc_clinical_df <- data.frame()
# Building data frame with xmls
for (i in 1:length(xml_file_paths)) {
  # Define file path
  path <- xml_file_paths[[i]]
  paste0("Converting :: ", path) %>% print()
  # Extracting data
  tmp_df <- convert_XML_to_DF(path)
  # Combining data frames
  gdc_clinical_df <- rbind(gdc_clinical_df, tmp_df)
}
