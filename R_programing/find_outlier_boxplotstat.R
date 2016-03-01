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
    
  #}
    return(boxplot_data)
}



a = save_boxplot(files_list, directory)
a$stats[5,]