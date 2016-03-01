require 'nokogiri'
require 'csv'
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

def get_score(document)
  tag_name = '//li[@class="score"]//a'
  score_data = extract_from_tag(document,tag_name)
  return score_data.children
end

def get_name(document)
  tag_name = '//h3//a'
  name_data = extract_from_tag(document,tag_name)
  return name_data.children
end


files = Dir.entries("Library_Page/toolbox_category/")
for i in 3...files.length do
   doc = get_content_data("Library_Page/toolbox_category/#{files[i]}")
   name = get_name(doc)
   score = get_score(doc)
   file_name = files[i].to_s
   file_name = file_name[0..-6]
    CSV.open("Library_Page/category_score/#{file_name}.csv", 'wb') do |csv|
      csv << ["name","score"]
      for j in 0...name.length-1 do
        csv << ["#{name[j]}","#{score[j]}"]
      end
    end
end
