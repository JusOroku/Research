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

def get_web_page(file_directory)
    doc = open_files_nokogiri("#{file_directory}")
    return doc
end

def get_download_array_data(doc)
    #extract library name from Total page table ##http://bestgem.org/total
    body_tag_name = '//script'
    body_data = extract_from_tag(doc,body_tag_name)
    prepare_data = body_data[1].to_s
    download_array = get_download_array(prepare_data)
    return download_array
end

def get_download_array(script_string)
    start_index = script_string.index("['Date', 'Total Downloads'")
    end_index = script_string.index("]);")
    first_result = script_string[start_index..end_index]
    return first_result
end

def get_data_into_array(text_data)
  data_array = Array.new
  check_point = true
  i = 0
  text_data.each_line do |text|
     if check_point == true
       check_point = false
       next
     end
     text.strip!
     data_array.push(Array.new)
     data_text = text[1..-3]
     data_text.gsub!("'","")
     data_text.gsub!(",","")
     data_text = data_text.split(" ")
     data_array[i].push(data_text)
     i = i+1
  end
  return data_array
end

file_directory = "/Volumes/Data/Ruby Project/Library_Page/totalgems.html"
web_doc = get_web_page(file_directory)
a = get_download_array_data(web_doc)
array = get_data_into_array(a)

for i in 0...array.length do
  download_data = array[i][0]
  puts download_data[3]
end
