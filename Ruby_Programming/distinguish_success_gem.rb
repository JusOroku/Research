require 'csv'

def distinguish_gem(file_path)
  CSV.foreach(file_path) do |row|
    puts row[1]
  end
end


file_path = 
