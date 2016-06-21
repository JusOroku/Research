    library(rmongodb)
    library(pracma)
    create_gems_matrix <- function(mongo_object) {
        
      #crete a list of gem data 
      gem_name = c()
      gem_description = c()
      gem_size = c()
      gem_license = c()
      gem_required_ruby = c()
      gem_homepage = c()
      gem_documentation = c()
      gem_source_code = c()
      gem_bug_tracker = c()
      gem_authors = c()
      gem_owners = c()
      gem_dependencies = c()
      
      #get data from mongoDB and insert into list
      for( i in 1:length(mongo_object)) {
        gem_name = c(gem_name, mongo_object[[i]]$gem_name)
        gem_description = c(gem_description, mongo_object[[i]]$gem_description)
        gem_size = c(gem_size, mongo_object[[i]]$gem_size)
        gem_license = c(gem_license, mongo_object[[i]]$gem_license)
        gem_required_ruby = c(gem_required_ruby, mongo_object[[i]]$require_ruby_version)
        gem_homepage = c(gem_homepage, mongo_object[[i]]$homepage)
        gem_documentation = c(gem_documentation, mongo_object[[i]]$documentation)
        gem_source_code = c(gem_source_code, mongo_object[[i]]$source_code)
        gem_bug_tracker = c(gem_bug_tracker, mongo_object[[i]]$bug_tracker)
        gem_authors = c(gem_authors, mongo_object[[i]]$authors)
        gem_owners = c(gem_owners, mongo_object[[i]]$owners)
        gem_dependencies = c(gem_dependencies, mongo_object[[i]]$dependencies)
      }
      
      #change all of numeri0c string data into numeric value
      
      gem_description = lapply(gem_description, as.numeric)
      gem_size = lapply(gem_size, as.numeric)
      gem_homepage = lapply(gem_homepage, as.numeric)
      gem_documentation = lapply(gem_documentation, as.numeric)
      gem_source_code = lapply(gem_source_code, as.numeric)
      gem_bug_tracker = lapply(gem_bug_tracker, as.numeric)
      gem_authors = lapply(gem_authors, as.numeric)
      gem_owners = lapply(gem_owners, as.numeric)
      gem_dependencies = lapply(gem_dependencies, as.numeric)
        
    #combine all of gem attribute and create matrix using name as a  row name
    gem_list = cbind(gem_description, gem_size, gem_license,gem_required_ruby,gem_homepage,gem_documentation,gem_source_code,gem_bug_tracker,gem_authors,gem_owners,gem_dependencies)

    rownames(gem_list) <- gem_name      
    return(gem_list)
    }
    
    calculate_distance_matrix <- function(gem_matrix) {
      dist_matrix = c()
      for(i in 1:nrow(gem_matrix)) {
        gem_i_distance_list = c()
        for(j in 1:nrow(gem_matrix)) {
          distance_value_i_j = calculate_distance_value(gem_matrix[i,], gem_matrix[j,])
          gem_i_distance_list = c(gem_i_distance_list, distance_value_i_j)
        }
        dist_matrix = rbind(dist_matrix, gem_i_distance_list)
      }
      return(dist_matrix)
    }  
      
    #calculate distance matrix from data_frame
    calculate_distance_value <- function(row_x, row_y) {
      cumulative_distance = 0
      for( i in 1:length(row_x) ) {
        distance = calculate_distance_XY(row_x[[i]], row_y[[i]])
        cumulative_distance = cumulative_distance + distance
      }
      cumulative_distance = sqrt(cumulative_distance)/length(row_x)
      return(cumulative_distance)
    }
    
    calculate_distance_XY <- function (x, y) {
      if(is.numeric(x) & is.numeric(y)){
        return ( (x-y)^2 )
      }
      else {
        if(strcmpi(x,y)){
          return(0)
        }
        else{
          return(1)
        }
      }
    }
    
    #main program 
    if(mongo.is.connected(mongo_connection) == TRUE) {
      mongo.get.databases(mongo_connection)
      database_name <- "rubygems"
      database <- mongo.get.database.collections(mongo_connection, database_name)
      collection_name <- "rubygems.rubygem_revised2"
      pop <- mongo.find.all(mongo_connection, collection_name)
      #mongo.count(mongo_connection, collection_name)
      #gem_matrix = create_gems_matrix(pop)
      #di = calculate_distance_matrix(gem_matrix)
    } else {
      print("Connect to Mongo DB First")
    }
      