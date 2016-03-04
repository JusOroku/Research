library(lme4)
library(influence.ME)
files_list <- "../../Library_Page/category_score/"

directory <- list.files(path = files_list)

Median_absolute_deviation_N <- function(files_list, directory) {
  path <- "../../Library_Page/MADN/"
  x_name <- "index"
  y_name <- "k_MADN"
  for(i in 1:length(directory)){
    a = paste(files_list, directory[i], sep = "")
    csv_data <- read.csv(a)
    score <- csv_data[["score"]]
    score_data = data.frame(score)
    score_mad = mad(score)
    score_madn = score_mad/0.6745
    k_vector = c()
    index_vector = c()
    score_median = median(score)
    for(l in 1:length(score)){
      k = abs(score[l] - score_median)/ score_madn
      k_vector = c(k_vector, k)
      index_vector = c(index_vector, l)
    }
    file_name = paste(path,directory[i],sep = "")
    new_data = data.frame(index_vector, k_vector)
    names(new_data) <- c(x_name, y_name)
    write.csv(x=new_data, file = file_name, row.names = FALSE)
    
  }
  
}

Median_absolute_deviation_N(files_list, directory)
