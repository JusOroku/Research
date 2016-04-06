require 'nokogiri'
require 'open-uri'
require 'csv'

#crawling each category in Ruby-toolbox websites
def open_files_nokogiri(file_name)
  doc = File.open(file_name) { |f| Nokogiri::HTML(f)}
  return doc
end

def open_web(web_name)
  doc = Nokogiri::HTML(open(web_name,"User-agent" => "foobar"))
  return doc
end

def extract_from_tag(document,tag_name)
    doc = document.xpath(tag_name)
    return doc
end

def get_content_data(file_directory)
    doc = open_files_nokogiri("#{file_directory}")
    #extract library name from Total page table ##http://bestgem.org/total
    body_tag_name = '//div[@id="main"]//div[@id="content"]//ul[@class="group_items"]//a[@href]'
    body_data = extract_from_tag(doc,body_tag_name)
    return body_data
end

def write_files (copy_web_page,directory,web_name)

  web_document = open_web(copy_web_page)
  output_file = File.new("#{directory}#{web_name}",'w+')
  output_file.write(web_document)
end

file_directory = "../toolbox_category.html"
web_page = get_content_data(file_directory)

category_link = Array.new
category_name = Array.new
i = 1
web_page.each do |link|
  link = link.to_s
  href_index = link.index("href")
  link = link[href_index+6..-1]
  close_backet_index = link.index('">')
  link = link[0..close_backet_index-1]
  category_link.push("https://www.ruby-toolbox.com#{link}")
  category_name.push("#{i}_#{link[12..-1]}.html")
  i = i+1
end

folder_path = "../Library_Page/toolbox_category/"
for i in 0...category_link.length do
  puts category_link[i]
  puts category_name[i]
  write_files(category_link[i], folder_path, category_name[i])
  sleep(3)
end
