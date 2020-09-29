# Function to calculate subtype
annotate_subtype <- function(x){
  
  # Defining variables to pull
  vars <- c("ER_STATUS_BY_IHC", "PR_STATUS_BY_IHC", "IHC_HER2")
  # Pulling variables from row string
  y <- x[vars]
  # Test for receptor positivity
  cond_res <- y == c("Positive", "Positive", "Positive")
  
  
  # returning NA if all values are NA
  if(sum(is.na(cond_res)) == 3) {
    return("Undetermined")
  }
  
  # Making NA undetermined
  cond_res[is.na(cond_res)] <- "Undetermined"
  
  # Determine if TNBC
  if("FALSE" == cond_res[1] && "FALSE" == cond_res[2] && "FALSE" == cond_res[3]) {
    return("TNBC")
  }


  # Determine HR Status
  if("TRUE" == cond_res[1] | "TRUE" == cond_res[2]) {
    HR_TEST <- "HR+"
  } else if("FALSE" == cond_res[1] && "FALSE" == cond_res[2]) {
    HR_TEST <- "HR-"
  } 
  
  # Need to fix what happens to ER = NA, PR = Neg or vice versa

    
    
  # Determine HER2 Status
  if("TRUE" == cond_res[3]) {
    HER2_TEST <- "HER2+"
  } else if("FALSE" == cond_res[3]) {
    HER2_TEST <- "HER2-"
  } else if("Undetermined" == cond_res[3]){
    HER2_TEST <- FALSE
  }
  
  # Need to consider if ER+ PR+ HER2=NA is worth defining as HR+
  # Might be better to just remove all patients with incomplete IHC status


  # Returning Subtype
  if(HER2_TEST == FALSE){
    subtype <- paste(HR_TEST)
  } else {
    subtype <- paste(HR_TEST, HER2_TEST, sep = "/")
    return(subtype)
  }


  
}


# Adding subtype to TCGA_BRCA_CLIN_MATCHED
TCGA_BRCA_CLIN_MATCHED$SUBTYPE <- apply(TCGA_BRCA_CLIN_MATCHED[1:40,], 1, annotate_subtype) %>% factor(., levels = c("HR-", "HR+", "HR-/HER2-", "HR-/HER2+", "HR+/HER2-", "HR+/HER2+", "TNBC"))

apply(TCGA_BRCA_CLIN_MATCHED[120,], 1, annotate_subtype)

# Suggest subsetting complete cases, since NA values could still mean the tumour is HR + etc