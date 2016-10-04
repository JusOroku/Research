library(rmongodb)
library(pracma)
library(cluster)
library(factoextra)


#After we get clustering object map them back into gem_matrix
#Then distinguish between outlier gem and non outlier gem
#

get_size_of_each_cluster_group <- function(clustering_object)  {
  return(clustering_object$clusinfo[,"size"])
}

get_gems_name_in_each_cluster <- function(clustering_object, cluster_number) {
  row_names = row.names(normalize_distance_matrix[clustering_object$cluster == cluster_number,])
  return(row_names)
}

create_gem_matrix_by_cluster_group <- function(row_names,gem_matrix){
  return(gem_matrix[row_names,])
}

read_gems_name_from_csv <- function(file_path){
  #TODO read file from CSV and save it into list
  file_data = read.csv(file_path, header = FALSE, stringsAsFactors = FALSE)
  return(file_data)
}

maps_csv_into_gem_matrix <- function(clustering_gem_matrix, csv_data){
  #TODO find matrix data from CSV data and create a new gem matrix that have a gem data from name list csv file
  gem_name_list = c()
  for(i in 1:length(row.names(clustering_gem_matrix))){
      if(is.element(row.names(clustering_gem_matrix)[i],csv_data[[1]])){
        gem_name_list = c(gem_name_list, row.names(clustering_gem_matrix)[i])
      }
  }
  return(clustering_gem_matrix[gem_name_list,])
}

flow_process <- function(){
  outlier_file_path = "/Volumes/Data/PunArm_Research/Library_Page/new_outlier.csv"
  non_outlier_file_path = "/Volumes/Data/PunArm_Research/Library_Page/new_non_outlier.csv"
  outlier_list = read_gems_name_from_csv(outlier_file_path)
  non_outlier_list = read_gems_name_from_csv(non_outlier_file_path)
  row_names = get_gems_name_in_each_cluster(clustering_object, 2)
  clus = create_gem_matrix_by_cluster_group(row_names,gem_matrix)
  outlier_cluster_matrix = maps_csv_into_gem_matrix(clus, outlier_list)
  non_outlier_cluster_matrix = maps_csv_into_gem_matrix(clus, non_outlier_list)  
}
