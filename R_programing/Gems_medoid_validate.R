library(rmongodb)
library(pracma)
library(cluster)
library(factoextra)


cvnn <- function(clustering_object){
  
  
}

cluster_plot <- function(distanece_matrix, clustering_object){
  clusplot(distanece_matrix, clustering_object$cluster, color = TRUE, shade = TRUE)
}

save_clustering_result <- function(normalize_distance_matrix){
  clustering_result_path <- "/Volumes/Data/PunArm_Research/Library_Page/clustering/normalplot_number_"
  asw <- numeric(46)
  for(i in 2:46){
    path = paste(clustering_result_path, i, sep = "")
    path = paste(path, ".jpg", sep = "")
    print(path)
    clustering_object = pam(normalize_distance_matrix, i, diss = TRUE)
    asw[i] <- clustering_object$silinfo$avg.width
    jpeg(file = path)
    plot(clustering_object, col = 2:i, border=NA)
    dev.off()
  }
  
}
 
clustering_object = pam(normalize_distance_matrix, 3, diss = TRUE)
fviz_silhouette(clustering_object)
row.names(normalize_distance_matrix[clustering_object$cluster == 2,])

