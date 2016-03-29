  source("vote_outlier_160302.R")
  
  summary_list = rep_len(TRUE, length(directory))
  x_axis_name = "name"
  y_axis_name = "status"
  outlier_folder_path = "../../Library_Page/outlier_status/"
  name_folder_path = "../../Library_Page/category_score/"
  
  for(i in 1:length(summary_list)) {
    
    file_path = paste(name_folder_path, directory[i], sep = "")
    name_data <- read.csv(file_path)
    name = name_data[["name"]]
    outlier_list = vote_outlier_check(directory[i])
    outlier_file_name = paste(outlier_folder_path,directory[i],sep = "")
    save_data = data.frame(name, outlier_list)
    names(save_data) <- c(x_axis_name, y_axis_name)
    write.csv(x=save_data, file = outlier_file_name, row.names = FALSE)
    
  }
