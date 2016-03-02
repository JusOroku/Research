library(ade4)
library(cluster)
library(fpc)
files_list <- "../../Library_Page/category_score/"

directory <- list.files(path = files_list)


save_boxplot <- function(files_list, directory) {
  boxplot <- "../Library_Page/Boxplot/"
  for(i in 1:length(directory)){
    a = paste(files_list, directory[i], sep = "")
    print(a)
    mydata <- read.csv(a)
    jpeg_file <- gsub(".csv", ".jpg", directory[i])
    plot_name = paste(boxplot,jpeg_file,sep = "")
    main_name = gsub(".jpg", "", jpeg_file)
    jpeg(file = plot_name)
    boxplot(mydata[["score"]], main = main_name)
    dev.off()
  }
}



get_best_k <- function(score_data) {
  best_cluster = NULL
  best_mean = NULL
  unique_datapoint = unique(score_data)
  
  for (i in 2:(nrow(unique_datapoint)-1)) {
    k_means_cluster <- kmeans_calculate(score_data,i)  
    dis_matrix <- daisy(score_data)
    silhouette_value = silhouette(k_means_cluster$cl,dis_matrix)
    silhouette_mean = mean(silhouette_value[,3])
    print(silhouette_mean)
    if(is.null(best_mean) || silhouette_mean > best_mean){
      best_cluster = k_means_cluster
      best_mean = silhouette_mean
    }
  }
  
  return(best_cluster)
  
}

get_silhouette_value <- function(files_list,directory){
  a = paste(files_list, directory[7], sep = "")
  csv_data <- read.csv(a)
  score <- csv_data[["score"]]
  score_data = data.frame(score)
  best_cluster = get_best_k(score_data)
  dis_matrix <- daisy(score_data)
  silhouette_value = silhouette(best_cluster$cl,dis_matrix)
  return(silhouette_value)
  
}

kmeans_calculate <- function(data, k){
  k_means = kmeans(data,k)
  return(k_means)
}

