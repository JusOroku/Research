require 'nokogiri'
require 'open-uri'
require 'csv'

def open_web(web_name)
  doc = Nokogiri::HTML(open(web_name))
  return doc
end

def write_files (copy_web_page,library_name,directory,index)

  web_document = open_web(copy_web_page + library_name)
  output_file = File.new("#{directory}#{index}_#{library_name}.html",'w+')
  output_file.write(web_document)
end

def download_gems_page (csv_array, start_page, end_page)
  bestgems_web_url = "http://bestgems.org/gems/"
  rubygems_web_url = "https://rubygems.org/gems/"
  bestgems_directory = "/Volumes/Data/Ruby Project/Library_Page/bestgems/"
  rubygems_directory = "/Volumes/Data/Ruby Project/Library_Page/rubygems/"
  random_module = Random.new
  base_time = 5
  error_check = start_page - 1
  begin
    for i in (start_page-1)...end_page do
      library_name = csv_array[i][1]
      error_check = i

       write_files(bestgems_web_url, library_name, bestgems_directory, i+1)
       print "bestgems_#{library_name}"
       write_files(rubygems_web_url, library_name, rubygems_directory, i+1)
       print " rubygems_#{library_name}"
       random_interval_time = random_module.rand(-3.0...1.0)
       total_time = base_time + random_interval_time
       puts " #{base_time} page #{i+1}"
       sleep(base_time)
    end
   rescue
     sleep(300)
     puts " Continue from page #{error_check}"
     download_gems_page(csv_array, error_check+2, end_page)
   end
end

# bestgems_web_url = "http://bestgems.org/gems/"
# rubygems_web_url = "https://rubygems.org/gems/"
# bestgems_directory = "/Volumes/Data/Ruby Project/Library_Page/"
csv_directory_path = "/Volumes/Data/Ruby Project/CSV/data_CSV.csv"
base_time = 2
index = 1

array_of_CSV = CSV.read(csv_directory_path)
end_length = array_of_CSV.length
puts end_length
download_gems_page(array_of_CSV, 100001, end_length)
# CSV.foreach("/Volumes/Data/Ruby Project/CSV/data_CSV.csv") do |row|
#   library_name = row[1]
#   library_name_array.push(library_name)
#
# end
# for page in 1501..5474 doss
#   doc = open_web(base_web_url + page.to_s)
#   write_summary_files(doc,file_directory,page)
#   print "write files page #{page} complete"
#
#   total_time = base_time + random_interval_time
#   sleep(total_time)
#   puts " Sleep #{total_time} second"
# end
