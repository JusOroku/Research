require 'nokogiri'
require 'open-uri'

def open_web(web_name)
  doc = Nokogiri::HTML(open(web_name))
  return doc
end

def write_summary_files (copy_web_page,paste_file,page)
  output_file = File.new("#{paste_file}summary_page_#{page}.html",'w+')
  output_file.write(copy_web_page)

end

base_web_url = "http://bestgems.org/total?page="
random_module = Random.new
file_directory = "/Volumes/Data/Ruby Project/Summary/"
base_time = 2
for page in 1501..5474 do
  doc = open_web(base_web_url + page.to_s)
  write_summary_files(doc,file_directory,page)
  print "write files page #{page} complete"
  random_interval_time = random_module.rand(-1.0..1.0)
  total_time = base_time + random_interval_time
  sleep(total_time)
  puts " Sleep #{total_time} second"
end
