require 'csv'

def distinguish_gem(file_path)
  CSV.foreach(file_path) do |row|
    if row[1] == "1"
      puts row[0]
    end
  end
end

directory_path = "../Library_Page/outlier_status/"
files = Dir.entries(directory_path)
for i in 3...files.length do
  distinguish_gem("#{directory_path}#{files[i]}")
end
