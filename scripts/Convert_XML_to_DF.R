convert_XML_to_DF <- function(XML_Path){
  # Reading XML 
  xml_obj <- xml2::read_xml(paste0(XML_Path))
  # Defining node
  xmldoc <- XML::xmlParse(xml_obj)
  rootNode <- XML::xmlRoot(xmldoc)
  # Pulling data
  data <- XML::xmlSApply(rootNode,function(x) XML::xmlSApply(x, XML::xmlValue))
  # Converting to DF
  xml_df <- data.frame(t(data$patient),row.names=NULL)
  # Returning DF
  return(xml_df)
}


