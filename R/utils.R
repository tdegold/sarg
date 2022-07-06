utils.get_all_examples <- function(){
  df_examples <- data.frame()
  for (ex in dir(EXAMPLES_PATH)) {
    meta <- exams::read_metainfo(paste0(EXAMPLES_PATH,ex))
    df_examples <- rbind(df_examples,
                         data.frame(meta$name,
                                    paste(meta$section, collapse = ", "),
                                    sum(meta$points),
                                    meta$type,
                                    meta$file)
    )
  }
  names(df_examples) <- c("Name", "Section", "Sum of Points", "Type", "File")
  # Return them sorted alphabetically by column Name
  return(df_examples)
}

utils.path_replace <- function(path, replacewith = ""){
  if(Sys.info()[1] == "Windows"){
    return(str_replace_all(path, "\\\\", replacewith))
  }else{
    return(str_replace_all(guid, "/", replacewith))
  }
}

utils.gen_pointscale_path <- function(x){
  d1 <- c("Punkte für Beispiel")
  j <- 1
  d2 <- data.frame("maximal erreichbar:")
  asum <- 0
  d3 <- data.frame("erreicht:")
  format <- "|c|l"
  for(i in x){
    d1 <- cbind(d1, as.character(j))
    j <- j+1
    metap <- exams::read_metainfo(paste0(EXAMPLES_PATH,"/",i))$points
    asum = asum + sum(metap)
    d2 <- cbind(d2, as.character(sum(metap)))
    d3 <- cbind(d3, "")
    format <- paste0(format, "|c")
  }
  d1 <- cbind(d1, "Summe")
  d2 <- cbind(d2, as.character(asum))
  d3 <- cbind(d3, "")
  names(d2) <- 1:length(d2)
  names(d3) <- 1:length(d3)
  d <- rbind(d2, d3)
  names(d) <- d1
  table <- xtable(d)
  format <- paste0(format, "|c|")
  align(table) <- format
  temf <- tempfile()
  print(table, include.rownames = FALSE, hline.after = c(-1:dim(d)[1]), floating = FALSE, file = temf)
  return(utils.path_replace(path = temf, replacewith = "/"))
}

utils.reorder <- function(x, userinput = ""){
  if(userinput == ""){ return(x)}
  new <- as.integer(str_split(userinput, ",")[[1]])
  return(x[new,])
}
