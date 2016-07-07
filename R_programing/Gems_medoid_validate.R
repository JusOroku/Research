library(rmongodb)
library(pracma)
library(cluster)



clustering_object = pam(normalize_distance_matrix, 10, diss = TRUE)
