library(ade4)
library(cluster)
library(fpc)
files_list <- "../../Library_Page/category_score/"

directory <- list.files(path = files_list)


save_boxplot <- function(files_list, directory) {
  boxplot <- "../Library_Page/Boxplot_stat/"
  #for(i in 1:length(directory)){
    a = paste(files_list, directory[1], sep = "")
    print(a)
    mydata <- read.csv(a)
    jpeg_file <- gsub(".csv", ".jpg", directory[1])
    plot_name = paste(boxplot,jpeg_file,sep = "")
    main_name = gsub(".jpg", "", jpeg_file)
    #jpeg(file = plot_name)
    boxplot_data = boxplot(mydata[["score"]], main = main_name, plot = FALSE)
    #dev.off()
    total_length = length(mydata[["score"]])
    outlier_length = length(boxplot_data$out)
    append_length = total_length - outlier_length
    #because score of [1] >= [2], if [2] is a outlier, 1 is also a outlier
    one_value_list <- rep_len(1, outlier_length)
    zero_value_list <- rep_len(0,append_length)
    outlier_boolean_matrix <- matrix(c(one_value_list,zero_value_list),
                                     nrow = total_length,
                                     ncol = 1)
    
    
    
    
    
  #}
    
    return(outlier_boolean_matrix)
}



a = save_boxplot(files_list, directory)
a