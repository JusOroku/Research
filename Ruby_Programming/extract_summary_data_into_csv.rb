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

def get_table_data(file_directory,page)
    file_name = "summary_page_#{page}.html"
    doc = open_files_nokogiri("#{file_directory}#{file_name}")
    #extract library name from Total page table ##http://bestgems.org/total
    table_tag_name = '//div[@class="row-fluid marketing"]//table[@class= "table table-striped"]'
    doc = extract_from_tag(doc,table_tag_name)
    table_object = extract_from_tag(doc,"//tr/td")
    #after finish this line we got overview table
    return table_object
end

def push_data_into_array(table_object,rank_array,total_download_array,name_array,summary_array)
  for_loop_count = table_object.length / 4 #normally no remainders
  for i in 0...for_loop_count do
    for j in 0..3 do
      index = (4*i) + j
      if j == 0
        rank = table_object[index].children.to_s
        rank_array.push(rank)
      elsif j == 1
        total_download =  table_object[index].children
        total_download_array.push(total_download)
      elsif j == 2
        name =  table_object[index].children.children.to_s
        name_array.push(name)
      else
        summary = table_object[index].children.to_s
        summary_array.push(summary)
      end
    end
  end
end

def write_data_into_csv(filesname,rank_array,total_download_array,name_array,summary_array)
  CSV.open(filesname, "wb") do |csv|
    for index in 0..rank_array.length do
      csv << [rank_array[index], name_array[index], summary_array[index], total_download_array[index]]
    end
  end
end

#Main method
rank_array = Array.new
total_download_array = Array.new
name_array = Array.new
summary_array = Array.new
file_directory = "/Volumes/Data/Ruby Project/Summary/"
for i in 1..5474
  # define path to summary_files_folder
  table_object = get_table_data(file_directory,i)

  #extract data and push into all of arrays
  #prepare data to save into csv files
  push_data_into_array(table_object,rank_array,total_download_array,name_array,summary_array)
end
#Write All of Array into CSV
csv_files_name = "/Volumes/Data/Ruby Project/CSV/data_CSV.csv"
write_data_into_csv(csv_files_name,rank_array,total_download_array,name_array,summary_array)
