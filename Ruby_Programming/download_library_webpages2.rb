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

def download_gems_page (name_array, number_array)
  bestgems_web_url = "http://bestgems.org/gems/"
  rubygems_web_url = "https://rubygems.org/gems/"
  bestgems_directory = "/Volumes/Data/Ruby Project/Library_Page/bestgems/"
  rubygems_directory = "/Volumes/Data/Ruby Project/Library_Page/rubygems/"
  random_module = Random.new
  base_time = 5
    for i in 0...name_array.length do
       write_files(bestgems_web_url, name_array[i], bestgems_directory, number_array[i])
       print "bestgems_#{name_array[i]}"
       write_files(rubygems_web_url, name_array[i], rubygems_directory, number_array[i])
       print " rubygems_#{name_array[i]}"
       random_interval_time = random_module.rand(-3.0...1.0)
       total_time = base_time + random_interval_time
       sleep(base_time)
    end

end

name_array = ["GridVid", "scent", "spacedozer", "RZM"]
number_array = [38145, 40763, 41546, 47486]


base_time = 2
index = 1
download_gems_page(name_array, number_array)
