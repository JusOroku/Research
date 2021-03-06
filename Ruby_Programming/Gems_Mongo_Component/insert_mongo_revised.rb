require_relative 'mongo_connect'
require_relative 'Gems_data_revised'
require 'csv'
$connection = Mongo_connect.new()
$client = $connection.connect_mongo()


##dummy method
def insert_gems_data_into_mongo(gem_id, gem_name, gem_description, gem_size, gem_license, require_ruby_version, homepage, documentation, source_code, bug_tracker, current_total_download, ranking, author, owner, dependencies)
  $client[:rubytest].insert_one({gem_id: 1, gem_name: gem_name, gem_description: gem_description, gem_size: gem_size, gem_license: gem_license, require_ruby_version: require_ruby_version, homepage: homepage, documentation: documentation, source_code: source_code, bug_tracker: bug_tracker, current_total_download: current_total_download, ranking: ranking, author: author, owner: owner, dependencies: dependencies})
end


##real method
def insert_gems_object_into_mongo(gem_object,id)
  $client[:rubygem_revised].insert_one({gem_id: id, gem_name: gem_object.gem_name.to_s, gem_description: gem_object.gem_description, gem_size: gem_object.gem_size, gem_license: gem_object.gem_license.to_s, require_ruby_version: gem_object.require_ruby_version.to_s, homepage: gem_object.boolean_array["homepage"], documentation: gem_object.boolean_array["documentation"], source_code: gem_object.boolean_array["source_code"], bug_tracker: gem_object.boolean_array["bug_tracker"],authors: gem_object.gem_author, owners: gem_object.gem_owners, dependencies: gem_object.gem_development_dependencies})
end

def insert_gems_object_into_mongo_toolbox(gem_object,id) #only from toolboxb website
  $client[:rubygem_revised2].insert_one({gem_id: id, gem_name: gem_object.gem_name.to_s, gem_description: gem_object.gem_description, gem_size: gem_object.gem_size, gem_license: gem_object.gem_license.to_s, require_ruby_version: gem_object.require_ruby_version.to_s, homepage: gem_object.boolean_array["homepage"], documentation: gem_object.boolean_array["documentation"], source_code: gem_object.boolean_array["source_code"], bug_tracker: gem_object.boolean_array["bug_tracker"],authors: gem_object.gem_author, owners: gem_object.gem_owners, dependencies: gem_object.gem_development_dependencies})
end
def insert_all (files,index,gems_list_array)
  begin
  check_index = index

  for i in index...files.length do
    check_index = i
    id_array = files[i].split("_")
    id_integer = id_array[0].to_i
    gem_object = Gems_data_revised.new(files[i])
    if( gems_list_array.include?(gem_object.gem_name.to_s) )
    puts "#{gem_object.gem_name} #{gem_object.gem_description}"
    insert_gems_object_into_mongo_toolbox(gem_object, id_integer)
    end

  end
  rescue
    insert_all(files, check_index+1)
  end
end

def get_all_gems_name(directory)
  name_array = Array.new
  CSV.foreach(directory) do |row|
    name_array.push(row[0])
  end
  return(name_array)
end

#rails = Gems_data.new("1_rake.html")
#$nsert_gems_object_into_mongo(rails)
#puts rails.history_array



gems_list_file_path = "../Library_Page/gems_list.csv"
gems_list_array = get_all_gems_name(gems_list_file_path)
files = Dir.entries("../Library_Page/rubygems/")
insert_all(files,3,gems_list_array)
##Error 7280
  # for i in 3...files.length do
  #   id_array = files[i].split("_")
  #   id_integer = id_array[0].to_i
  #   gem_object = Gems_data.new(files[i])
  #   puts gem_object.gem_name
  #   insert_gems_object_into_mongo(gem_object, id_integer)
  #  end
