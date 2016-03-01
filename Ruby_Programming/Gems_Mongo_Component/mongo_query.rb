require_relative 'mongo_connect'
require 'bson'
$connection = Mongo_connect.new()
$client = $connection.connect_mongo()

#get dependent list and computing to get the array of [gem: amount]
def get_dependent_amount_list(dependent_hash)
  dependent_hash = dependent_hash.sort_by {|key,value| value * (-1)}
  puts dependent_hash.length
  dependent_hash.each do |key, value|
    puts "#{key}: #{value}"
  end
  return dependent_hash
end

#same as above but get the owner list instead
#get owner list and computing to get the array of [owner: amount]
def get_owners_amount_list(owner_hash)
  owner_hash = owner_hash.sort_by {|key,value|  value * (-1)}
  puts owner_hash.length
  owner_hash.each do |key, value|
    puts "#{key}: #{value}"
  end
  return owner_hash
end

def write_files(hash,file_name)
  File.open("#{file_name}.txt", 'w') do |f|
    hash.each {|key,values| f.puts("#{key}: #{values}")}
  end
end

#get the collection from Mongo
ruby_collection = $client[:rubygem]

i = 1
dependent_amount = Hash.new(0)
owners_amount = Hash.new(0)
ruby_collection.find().projection(:gem_name => 1,:dependencies => 1, :owners => 1).each do |a|
  #puts "gem #{i}"
  #print a["dependencies"]
  a["dependencies"].each do |gems|
    dependent_amount[gems] += 1
  end
  a["owners"].each do |owners_name|
    owners_amount[owners_name] += 1
  end
end

#dependent_hash = get_dependent_amount_list(dependent_amount)
owner_hash = get_owners_amount_list(owners_amount)
write_files(owner_hash,"owners_list")



#$client[:rubytest].indexes.create_one({:current_total_download => 1})
