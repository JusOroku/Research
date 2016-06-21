files_list <- "../../Library_Page/outlier_status/"
directory <- list.files(path = files_list)

save_outlier_status <- function(directory){
  files_list <- "../../Library_Page/outlier_status/"
  #print(length(directory))
  count = 0
  gems_list = rep_len("TRUE", 264)
  for(i in 1:length(directory)){
    file_path = paste(files_list, directory[i], sep = "")
    name_data <- read.csv(file_path)
    
    for(l in 1:length(name_data[["status"]] )) {
      #check wether gems is outlier or not, status: 1 = outlier 0 = not outlier
      if(name_data[["status"]][l] == "1") {
        #print(name_data[["name"]][l])
        count = count + 1
        gems_list[count] <- name_data$name[1]
      }
    }
  }
  print(gems_list)
}

save_outlier_status(directory)