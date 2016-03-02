library(ade4)
library(cluster)
library(fpc)
files_list <- "../../Library_Page/category_score/"

directory <- list.files(path = files_list)

get_best_k <- function(score_data) {
  best_cluster = NULL
  best_mean = NULL
  unique_datapoint = unique(score_data)
  
  for (i in 2:(nrow(unique_datapoint)-1)) {
    k_means_cluster <- kmeans_calculate(score_data,i)  
    dis_matrix <- daisy(score_data)
    silhouette_value = silhouette(k_means_cluster$cl,dis_matrix)
    silhouette_mean = mean(silhouette_value[,3])
    if(is.null(best_mean) || silhouette_mean > best_mean){
      best_cluster = k_means_cluster
      best_mean = silhouette_mean
    }
  }
  
  return(best_cluster)
  
}

get_silhouette_value <- function(files_list,directory){
  path <- "../../Library_Page/kmeans/"
  x_name <- "cluster"
  y_name <- "width"
  for(i in 1:length(directory)){
  a = paste(files_list, directory[i], sep = "")
  csv_data <- read.csv(a)
  score <- csv_data[["score"]]
  score_data = data.frame(score)
  u_data = unique(score_data)
  if(nrow(u_data) <= 2) {
    next
  }
  best_cluster = get_best_k(score_data)
  dis_matrix <- daisy(score_data)
  silhouette_value = silhouette(best_cluster$cl,dis_matrix)
  txt_file <- gsub(".csv", ".csv", directory[i])
  file_name = paste(path,txt_file,sep = "")
  new_data = data.frame(silhouette_value[,1], silhouette_value[, 3])
  names(new_data) <- c(x_name, y_name)
  write.csv(x=new_data, file = file_name, row.names = FALSE)
  }
}

kmeans_calculate <- function(data, k){
  k_means = kmeans(data,k)
  return(k_means)
}

silhouette_mean = get_silhouette_value(files_list, directory)
x_name <- "cluster"
y_name <- "width"
new_data = data.frame(silhouette_mean[,1], silhouette_mean[, 3])
names(new_data) <- c(x_name, y_name)
new_data
write.csv(x=new_data, file = "../testk.csv", row.names = FALSE)

