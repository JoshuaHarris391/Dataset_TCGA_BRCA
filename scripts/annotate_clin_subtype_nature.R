
# Subsetting clinical DF for receptors
complete_IHC_cases <- TCGA_BRCA_CLIN_MATCHED %>% select(c("CASE_ID", "ER_Status", "PR_Status", "HER2_Final_Status"))
# Subsetting cases NA in ER status
complete_IHC_cases <- dplyr::filter(complete_IHC_cases, !(is.na(complete_IHC_cases$ER_Status)))
# Subsetting cases NA in PR status
complete_IHC_cases <- dplyr::filter(complete_IHC_cases, !(is.na(complete_IHC_cases$PR_Status)))
# Subsetting cases NA in IHC_HER2 status
complete_IHC_cases <- dplyr::filter(complete_IHC_cases, !(is.na(complete_IHC_cases$HER2_Final_Status)))

# Defining function to determine subtype
annotate_subtype <- function(x){
  
  # Test for receptor positivity
  cond_res <- x == c("Positive", "Positive", "Positive")
  
  # Testing for TNBC
  if(cond_res[1] == "FALSE" && cond_res[2] == "FALSE" && cond_res[3] == "FALSE"){
    return("TNBC")
  }
  
  # HR testing
  if(cond_res[1] == "TRUE" | cond_res[2] == "TRUE") {
    HR_TEST <- "HR-Pos"
  } else if(cond_res[1] == "FALSE" && cond_res[2] == "FALSE") {
    HR_TEST <- "HR-Neg"
  }
  
  # Testing for HER2
  if(cond_res[3] == "TRUE"){
    HER2_TEST <- "HER2-Pos"
  }else if(cond_res[3] == "FALSE"){
    HER2_TEST <- "HER2-Neg"
  }
  
  # Returning subtype
  subtype <- paste(HR_TEST, HER2_TEST, sep = "_")
  return(subtype)
  
}

# Adding annotations
complete_IHC_cases$SUBTYPE_NATURE <- apply(complete_IHC_cases[, 2:4], 1, annotate_subtype)
complete_IHC_cases$SUBTYPE_NATURE <- factor(complete_IHC_cases$SUBTYPE_NATURE, levels = names(table(complete_IHC_cases$SUBTYPE_NATURE)))

# Adding subtype annotation to TCGA_BRCA_CLIN_MATCHED
TCGA_BRCA_CLIN_MATCHED <- dplyr::left_join(TCGA_BRCA_CLIN_MATCHED, complete_IHC_cases[, c("CASE_ID", "SUBTYPE_NATURE")], by = "CASE_ID")
