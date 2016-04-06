require 'nokogiri'
require 'csv'

#get gems attribute from rubygems website
#this is prototype almost all method was used in Gems_data.rb
def open_files_nokogiri(file_name)
  doc = File.open(file_name) { |f| Nokogiri::HTML(f)}
  return doc
end

def extract_from_tag(document,tag_name)
    doc = document.xpath(tag_name)
    return doc
end

##-- got HTML body data to make it easy to get the inside data
def get_data(file_directory)
    doc = open_files_nokogiri("#{file_directory}")
    #extract library name from Total page table ##http://bestgem.org/total
    body_tag_name = '//div[@class="l-wrap--b"]'
    body_data = extract_from_tag(doc,body_tag_name)

    return body_data
end

## get a name of a gem
def get_gem_name (document_file)
  name_tag_name = '//h1[@class="t-display page__heading"]//a'
  gem_name = extract_from_tag(document_file,name_tag_name)
  return gem_name.children
end

## get a description of a gem
## TODO convert it into array
def get_gem_description (document_file)
  description_tag_name = '//div[@class="gem__intro"]//div[@class="gem__desc"]//p'
  gem_description = extract_from_tag(document_file,description_tag_name)
  return gem_description.children #Text
end

def get_gem_size(document_file)
  gem_version_tag_name = '//div[@class="versions"]//ol[@class="gem__versions t-list__items"]//li'
  gem_version_table = extract_from_tag(document_file, gem_version_tag_name)
  gem_size_tag_name = '//span[@class="gem__version__date"]'
  gem_size = extract_from_tag(gem_version_table,gem_size_tag_name)
  gem_size_string = gem_size[0].children.to_s[1..-2]
  return gem_size_string
end

#get development dependencies list of a gem
def get_gem_development_dependencies(document_file)
  development_dependencies_tag_name = '//div[@class="dependencies"]//div[@class="t-list__items"]//a//strong'
  gem_development_dependencies = extract_from_tag(document_file,development_dependencies_tag_name)
  return gem_development_dependencies.children #Array
end

# get Authors name of a gem

def get_gem_authors(document_file)
  authors_tag_name = '//div[@class="gem__members"]//ul[@class="t-list__items"]//li//p'
  gem_authors = extract_from_tag(document_file,authors_tag_name)
  gem_authors_array = gem_authors.children.to_s.split(", ")
  return gem_authors_array

end

# get owners name of a gem

def get_gem_owners(document_file)
  owners_tag_name = '//div[@class="gem__members"]//div[@class="gem__owners"]//a'
  gem_owners = extract_from_tag(document_file,owners_tag_name)
  gem_owners_array = gem_owners
  owner_name = Array.new
  gem_owners_array.each do |gem_owner|
    gem_owner = gem_owner.to_s
    start_index = gem_owner.index("title")
    last_index = gem_owner.index("href")
    name = gem_owner[start_index+7..last_index-3]
    owner_name.push(name)
  end
  return owner_name #Array
end

#get number of total download of a gem
def get_gem_total_download(document_file)
  gem_total_download_tag_name = '//span[@class="gem__downloads"]'
  gem_total_download = extract_from_tag(document_file,gem_total_download_tag_name)
  return gem_total_download.children[0]
end

# get a license of a gem
def get_gem_license(document_file)
  gem_license_tag_name = '//span[@class="gem__ruby-version"]//p'
  gem_license = extract_from_tag(document_file, gem_license_tag_name)
  return gem_license.children
end

# get a required version of ruby of a gem
def get_gem_ruby_required_version(document_file)
  gem_ruby_require_tag_name = '//i[@class="gem__ruby-version"]'
  gem_ruby_require = extract_from_tag(document_file, gem_ruby_require_tag_name)
  return gem_ruby_require.children.to_s.strip
end

# get other gems attribute such as homepage, source code, etc.
def get_gem_item_list(document_file)
  gem_item_list_tag_name = '//div[@class="t-list__items"]//a'
  gem_item_list = extract_from_tag(document_file, gem_item_list_tag_name)
  return gem_item_list.children
end

#Main method
file_directory = "../Library_Page/rubygems/308_hoe.html"
test_extract = get_data(file_directory)
gem_name = get_gem_name(test_extract)
gem_description = get_gem_description(test_extract)
gem_development_dependencies = get_gem_development_dependencies(test_extract)
gem_authors = get_gem_authors(test_extract)
gem_owners = get_gem_owners(test_extract)
gem_total_download = get_gem_total_download(test_extract)
gem_license = get_gem_license(test_extract)
gem_ruby_require = get_gem_ruby_required_version(test_extract)
gem_item_list = get_gem_item_list(test_extract)
gem_size = get_gem_size(test_extract)
puts "Name:"
puts ""
puts gem_name
puts "-----"
puts "Description:"
puts ""
puts gem_description
puts "-----"
puts "Size:"
puts ""
puts gem_size
puts "-----"
puts "Development dependencies list:"
puts ""
puts gem_development_dependencies
puts "-----"
puts "Author lists:"
puts ""
puts gem_authors
puts "-----"
puts "Owners list:"
puts ""
puts gem_owners
puts "-----"
puts "Total Download (rubygems):"
puts ""
puts gem_total_download
puts "-----"
puts "License:"
puts ""
puts gem_license
puts "-----"
puts "Required Ruby Version:"
puts ""
puts gem_ruby_require
puts "-----"
puts "Other Items List:"
puts ""
puts gem_item_list
