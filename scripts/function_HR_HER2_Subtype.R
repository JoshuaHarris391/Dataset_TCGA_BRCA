
subtype_HR_HER2 <- function(ER_VAR, PR_VAR, HER2_VAR, ID_VAR, INPUT_DF){
  
  # # debugging vars
  # ER_VAR = "ER_Status"
  # PR_VAR = "PR_Status"
  # HER2_VAR = "HER2_Final_Status"
  # ID_VAR = "Complete_TCGA_ID"
  # INPUT_DF = TCGA_NATURE_CLIN
  
  # Subsetting clinical DF for receptors
  complete_IHC_cases <- INPUT_DF %>% 
    dplyr::select(., c(all_of(ID_VAR), all_of(ER_VAR), all_of(PR_VAR), all_of(HER2_VAR))) %>% 
    na.omit()
  
  # Defining function to determine subtype
  annotate_subtype <- function(x){
    
    # Converting variables to integer
    if (!is.integer(x)){
      x[1] <- ifelse(x[1] == "Positive", 1, ifelse(x[1] == "Negative", 0, NULL))
    } 
    if (!is.integer(x)){
      x[2] <- ifelse(x[2] == "Positive", 1, ifelse(x[2] == "Negative", 0, NULL))
    } 
    if (!is.integer(x)){
      x[3] <- ifelse(x[3] == "Positive", 1, ifelse(x[3] == "Negative", 0, NULL))
    }
    
    # Making conditions
    cond_res <- x == c(1, 1, 1)
    
    
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
  complete_IHC_cases$IHC_SUBTYPE <- apply(complete_IHC_cases[, 2:4], 1, annotate_subtype)
  complete_IHC_cases$IHC_SUBTYPE <- factor(complete_IHC_cases$IHC_SUBTYPE, levels = names(table(complete_IHC_cases$IHC_SUBTYPE)))
  
  # Adding subtype annotation back into inputdf
  OUTPUT_DF <- dplyr::left_join(INPUT_DF, complete_IHC_cases[, c(ID_VAR, "IHC_SUBTYPE")], by = ID_VAR)
  return(OUTPUT_DF)
}

