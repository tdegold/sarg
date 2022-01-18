punkteTable <- function(x){
  d1 <- c("Punkte für Beispiel")
  for(i in 1:length(x)){
    d1 <- cbind(d1, as.character(i))
  }
  d1 <- cbind(d1, "Summe")
  d2 <- data.frame("maximal erreichbar:")
  asum <- 0
  for(ex in x){
    meta <- exams::read_metainfo(ex)
    asum = asum + sum(meta$points)
    d2 <- cbind(d2, as.character(sum(meta$points)))
  }
  d2 <- cbind(d2, as.character(asum))
  names(d2) <- 1:length(d2)
  d3 <- data.frame("erreicht:")
  for(i in 1:(length(d2)-1)){
    d3 <- cbind(d3, "")
  }
  names(d3) <- 1:length(d3)
  d <- rbind(d2, d3)
  names(d) <- d1
  table <- xtable(d)
  format <- "|c|l"
  for(i in 1:(length(d)-1)){
    format <- paste0(format, "|c")
  }
  format <- paste0(format, "|")
  align(table) <- format
  temf <- tempfile()
  print(table, include.rownames = FALSE, hline.after = c(-1:dim(d)[1]), floating=FALSE, tabular.environment="tabularx", width="\\textwidth")#, file = temf)
  #return(str_replace_all(temf, "\\\\", "/"))
}
punkteTable(dir())
m
