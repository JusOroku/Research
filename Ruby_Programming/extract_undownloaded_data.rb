require 'nokogiri'
require 'csv'
#Main method
number_array = Array.new(109477,0)

file_directory = "../Library_Page/rubygems/"
all_gems_files = Dir.entries(file_directory)
all_gems_files.each do |items|
  text = items.split("_")
  inte = text[0].to_i
  number_array[inte] = 1
end

count = 0
for i in 1...number_array.length do
  if number_array[i] == 0
    puts "#{i} library #{all_gems_files[i]}"
    count +=1
  end
end


puts count
