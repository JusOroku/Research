library(rmongodb)
library(pracma)
library(cluster)
library(factoextra)

cluster_plot <- function(distanece_matrix, clustering_object){
  clusplot(distanece_matrix, clustering_object$cluster, color = TRUE, shade = TRUE)
}

#Plot a cluster and save into jpeg file
save_clustering_result <- function(normalize_distance_matrix){
  clustering_result_path <- "/Volumes/Data/PunArm_Research/Library_Page/clustering/normalplot_number_"
  asw <- numeric(46)
  for(i in 2:4){
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

pam_cluster <- function(normalize_distance_matrix, cluster_number){
  clustering_object = pam(normalize_distance_matrix, cluster_number, diss = TRUE)
  return(clustering_object)
}
#The Best Clustering is with 32 clusters group

#fviz_silhouette(clustering_object)
