library(ade4)
library(cluster)
library(fpc)

files_list <- "../../Library_Page/kmeans/"
directory <- list.files(path = files_list)

save_boxplot <- function(file_name) {
    score_folder_path = "../../Library_Page/category_score/"
    file_path = paste(score_folder_path, file_name, sep = "")
    #print(file_path)
    mydata <- read.csv(file_path)
    boxplot_data = boxplot(mydata[["score"]], plot = FALSE)
    total_length = length(mydata[["score"]])
    outlier_length = length(boxplot_data$out)
    append_length = total_length - outlier_length
    #because score of [1] >= [2], if [2] is a outlier, 1 is also a outlier
    one_value_list <- rep_len(1, outlier_length)
    zero_value_list <- rep_len(0,append_length)
    outlier_boolean_matrix <- matrix(c(one_value_list,zero_value_list),
                                     nrow = total_length,
                                     ncol = 1)
  #}
    return(outlier_boolean_matrix)
}

read_silhouette_value <- function(file_name){
  kmeans_folder_path = "../../Library_Page/kmeans/"
  file_path = paste(kmeans_folder_path, file_name, sep = "")
  #print(file_path)
  mydata <- read.csv(file_path)
  cluster = mydata[["cluster"]]
  silhouette_width = mydata[["width"]]
  #print(cluster)
  #print(silhouette_width)
  duplicate_list = unique(cluster[duplicated(cluster)])
  #print(duplicate_list)
  outlier_value_list = rep_len(0, length(cluster))
  for(i in 1:length(silhouette_width)) {
    if(silhouette_width[i] < 0){
      outlier_value_list[i] <- 1
      next
    }
    if(!(cluster[i] %in% duplicate_list)){
      outlier_value_list[i] <- 1
      next
    }
  }
  return(outlier_value_list)
}

read_MADN_data <- function(file_name){
  MADN_folder_path = "../../Library_Page/MADN/"
  file_path = paste(MADN_folder_path, file_name, sep = "")
  #print(file_path)
  mydata <- read.csv(file_path)
  outlier_value_list = rep_len(0, length(mydata[["k_MADN"]]))
  for(i in 1:length(mydata[["k_MADN"]])) {
    if(mydata[["k_MADN"]][i] > 2.24) {
      outlier_value_list[i] <- 1
    }
  }
  
  outlier_boolean_matrix <- matrix(outlier_value_list,
                                   nrow = length(mydata[["k_MADN"]]),
                                   ncol = 1)
  return(outlier_boolean_matrix)
}

vote_outlier <- function(file_path){
  boxplot_outputs = save_boxplot(file_path)
  MADN_outputs = read_MADN_data(file_path)
  kmeans_outputs = read_silhouette_value(file_path)
  outputs_matrix = cbind(boxplot_outputs,MADN_outputs,kmeans_outputs)
  outputs_list = rowSums(outputs_matrix)
  summary_outlier_list = rep_len(0, length(outputs_list))
  for(i in 1:length(summary_outlier_list)) {
    if(outputs_list[i] > 1) {
      summary_outlier_list[i] <- 1
    }
  }
 if(sum(summary_outlier_list) == 1) {
   return("Not Competitive")
 }
  else {
    return("Competitive")
  }
}

vote_outlier_check <- function(file_path){
  boxplot_outputs = save_boxplot(file_path)
  MADN_outputs = read_MADN_data(file_path)
  kmeans_outputs = read_silhouette_value(file_path)
  outputs_matrix = cbind(boxplot_outputs,MADN_outputs,kmeans_outputs)
  outputs_list = rowSums(outputs_matrix)
  summary_outlier_list = rep_len(0 , length(outputs_list))
  for(i in 1:length(summary_outlier_list)) {
    if(outputs_list[i] > 1) {
      summary_outlier_list[i] <- 1
    }
  }
  return(summary_outlier_list) 
}



