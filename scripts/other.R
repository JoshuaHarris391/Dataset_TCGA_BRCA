return_apply_row <- function(x){
  
  # Defining variables to pull
  vars <- c("ER_STATUS_BY_IHC", "PR_STATUS_BY_IHC", "IHC_HER2")
  # Pulling variables from row string
  y <- x[vars]
  return(y)
}
  

complete_IHC_cases <- TCGA_BRCA_CLIN_MATCHED %>% select(c("ER_STATUS_BY_IHC", "PR_STATUS_BY_IHC", "IHC_HER2"))

# Subsetting cases NA in ER status
complete_IHC_cases <- dplyr::filter(complete_IHC_cases, !(is.na(complete_IHC_cases$ER_STATUS_BY_IHC)))
# Subsetting cases NA in PR status
complete_IHC_cases <- dplyr::filter(complete_IHC_cases, !(is.na(complete_IHC_cases$PR_STATUS_BY_IHC)))
# Subsetting cases NA in IHC_HER2 status
complete_IHC_cases <- dplyr::filter(complete_IHC_cases, !(is.na(complete_IHC_cases$IHC_HER2)))

