library(ade4)
library(cluster)
library(fpc)
files_list <- "../../Library_Page/category_score/"

directory <- list.files(path = files_list)


save_boxplot <- function(files_list, directory) {
  #for(i in 1:length(directory)){
    a = paste(files_list, directory[1], sep = "")
    print(a)
    mydata <- read.csv(a)
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

read_silhouette_value <- function(){
  kmeans_files_list <- "../../Library_Page/kmeans/"
  kmeans_directory <- list.files(path = kmeans_files_list)
  a = paste(kmeans_files_list, kmeans_directory[1], sep = "")
  print(a)
  mydata <- read.csv(a)
}

read_MADN_data <- function(){
  MADN_files_list <- "../../Library_Page/MADN/"
  MADN_directory <- list.files(path = MADN_files_list)
  a = paste(MADN_files_list, MADN_directory[1], sep = "")
  print(a)
  mydata <- read.csv(a)
  outlier_value_list = rep_len(0, length(mydata[["k_MADN"]]))
  for(i in 1:length(mydata[["k_MADN"]])) {
    if(mydata[["k_MADN"]][i] > 2.24) {
      outlier_value_list[i] <- 1
    }
    print(outlier_value_list)
  }
  
  outlier_boolean_matrix <- matrix(outlier_value_list,
                                   nrow = length(mydata[["k_MADN"]]),
                                   ncol = 1)
  return(outlier_boolean_matrix)
}
a = save_boxplot(files_list, directory)
b = read_MADN_data()
a
b