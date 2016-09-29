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
}

maps_csv_into_gem_matrix <- function(clustering_gem_matrix, csv_data){
  #TODO find matrix data from CSV data and create a new gem matrix that have a gem data from name list csv file
}

row_names = get_gems_name_in_each_cluster(clustering_object, 2)
clus = create_gem_matrix_by_cluster_group(row_names,gem_matrix)
