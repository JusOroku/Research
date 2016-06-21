library(rmongodb)
  
create_gems_data_frame <- function(mongo_object) {
    
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
    gem_required_ruby = c(gem_required_ruby, mongo_object[[i]]$required_ruby_version)
    gem_homepage = c(gem_homepage, mongo_object[[i]]$homepage)
    gem_documentation = c(gem_documentation, mongo_object[[i]]$documentation)
    gem_source_code = c(gem_source_code, mongo_object[[i]]$source_code)
    gem_bug_tracker = c(gem_bug_tracker, mongo_object[[i]]$bug_tracker)
    gem_authors = c(gem_authors, mongo_object[[i]]$authors)
    gem_owners = c(gem_owners, mongo_object[[i]]$owners)
    gem_dependencies = c(gem_dependencies, mongo_object[[i]]$dependencies)
  }
    
  #combine all of gem attribute and create data frame using name as a  row name
  gem_list = cbind(gem_description, gem_size, gem_license,gem_required_ruby,gem_homepage,gem_documentation,gem_source_code,gem_bug_tracker,gem_authors,gem_owners,gem_dependencies)
  gem_dataframe = data.frame(gem_list)
  rownames(gem_dataframe) <- gem_name
    
  return(gem_dataframe)
}
  
#calculate distance matrix from data_frame
calculate_distancematrix <- function(data_frame) {
  
}

#main program 
if(mongo.is.connected(mongo_connection) == TRUE) {
  mongo.get.databases(mongo_connection)
  database_name <- "rubygems"
  database <- mongo.get.database.collections(mongo_connection, database_name)
  collection_name <- "rubygems.rubygem_revised2"
  pop <- mongo.find.all(mongo_connection, collection_name)
  #mongo.count(mongo_connection, collection_name)
  list = create_gems_data_frame(pop)
  print(list["rake",])
} else {
  print("Connect to Mongo DB First")
}
  
