library(ade4)
library(cluster)
library(fpc)
files_list <- "../Library_Page/category_score/"

directory <- list.files(path = files_list)

mantel_test <- function(files_list, directory) {
  a = paste(files_list, directory[1], sep = "")
  csv_data <- read.csv(a)
  csv_data
  score <- csv_data[["score"]]
  dists = NULL
  for (i in 1:length(score)){
    remove_i_index_array = score[-i]
    print(remove_i_index_array)
    dists <- dist(remove_i_index_array)
    a = mantel.rtest(dists,dists)
    print (dists)
  }
}

mantel_test(files_list, directory)
