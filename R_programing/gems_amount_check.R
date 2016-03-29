library(ade4)
library(cluster)
library(fpc)

files_list <- "../../Library_Page/kmeans/"
directory <- list.files(path = files_list)
l = 0
for(i in 1:length(directory)) {
  file_path = paste(files_list, directory[i], sep = "")
  print(file_path)
  mydata <- read.csv(file_path)
  cluster = mydata[["cluster"]]
  l = l + length(cluster)
}
print(length(directory))
print(l)
