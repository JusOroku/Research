require 'csv'



def distinguish_gem(file_path)
  outlier_files_path = "../Library_Page/outlier.csv"
  non_outlier_files_path = "../Library_Page/non_outlier.csv"
  CSV.foreach(file_path) do |row|
    if row[1] == "1"
      CSV.open(outlier_files_path, "a+") do |csv|
        csv << ["#{row[0]}"]
      end
    end

    if row[1] == "0"
      CSV.open(non_outlier_files_path, "a+") do |csv|
        csv << ["#{row[0]}"]
      end
    end
  end
end

directory_path = "../Library_Page/outlier_status/"
files = Dir.entries(directory_path)
for i in 3...files.length do
  distinguish_gem("#{directory_path}#{files[i]}")
end
