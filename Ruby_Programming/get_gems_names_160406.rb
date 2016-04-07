require 'nokogiri'
require 'csv'
#for each gems in category, get score of each gems and keep it in csv files
#outputs file will be used in R language to find outlier

def open_files_nokogiri(file_name)
  doc = File.open(file_name) { |f| Nokogiri::HTML(f)}
  return doc
end

def extract_from_tag(document,tag_name)
    doc = document.xpath(tag_name)
    return doc
end

def get_content_data(file_directory)
    doc = open_files_nokogiri("#{file_directory}")
    #extract library name from Total page table ##http://bestgem.org/total
    body_tag_name = '//div[@id="main"]//div[@id="content"]//div[@class="box-header"]'
    body_data = extract_from_tag(doc,body_tag_name)
    return body_data
end

def get_gems_name(document)
  tag_name = '//div[@class="attribute-section rubygem"]//div[@class="attr-inner"]//h4//a[@class="tipsy-w"]'
  score_data = extract_from_tag(document,tag_name)
  return score_data.children
end

def get_name(document)
  tag_name = '//h3//a'
  name_data = extract_from_tag(document,tag_name)
  return name_data.children
end


files = Dir.entries("../Library_Page/toolbox_category/")
gems_name_hash = Hash.new()


for i in 3...files.length do
   doc = get_content_data("../Library_Page/toolbox_category/#{files[i]}")
   name = get_name(doc)
   gems_name = get_gems_name(doc)
   for i in 0...name.length-1 do
     gems_name_hash["#{name[i]}"] = gems_name[i].to_s
   end
end
former_outlier_files_path = "../Library_Page/outlier.csv"
former_non_outlier_files_path = "../Library_Page/non_outlier.csv"
new_outlier_files_path = "../Library_Page/new_outlier.csv"
new_non_outlier_files_path = "../Library_Page/new_non_outlier.csv"
CSV.foreach(former_outlier_files_path) do |row|
  puts "#{gems_name_hash[row[0]]}"
  CSV.open(new_outlier_files_path, "a+") do |csv|
    csv << ["#{gems_name_hash[row[0]]}"]
  end
end

 CSV.foreach(former_non_outlier_files_path) do |row|
   if(gems_name_hash[row[0]] == "")
     next
   end
   puts "#{row[0]} #{gems_name_hash[row[0]]}"
   CSV.open(new_non_outlier_files_path, "a+") do |csv|
     csv << ["#{gems_name_hash[row[0]]}"]
   end
 end
