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

def get_total_download(doc)
  tag_name = '//span[@class="downloads"]'
  download_data = extract_from_tag(doc,tag_name)
  return download_data[1].children
end

def get_total_ranking(doc)
  tag_name = '//div[@class="span6"]//p//em'
  ranking_data = extract_from_tag(doc,tag_name)
  return ranking_data[0].children
end
##-- got HTML body data to make it easy to get the inside data
def get_download_array_data(doc)
    #extract library name from Total page table ##http://bestgem.org/total
    body_tag_name = '//script'
    body_data = extract_from_tag(doc,body_tag_name)
    prepare_data = body_data[1].to_s
    download_array = get_download_array(prepare_data)
    return download_array
end

def get_ranking_array_data(doc)

    #extract library name from Total page table ##http://bestgem.org/total
    body_tag_name = '//script'
    body_data = extract_from_tag(doc,body_tag_name)
    prepare_data = body_data[1].to_s
    download_array = get_ranking_array(prepare_data)

end

def get_download_array(script_string)
    start_index = script_string.index("['Date', 'Total Downloads'")
    end_index = script_string.index("]);")
    result = script_string[start_index..end_index]
    return result
end

def get_ranking_array(script_string)
    start_index = script_string.index("['Date', 'Total Rank'")
    script_string = script_string[start_index..-1]
    end_index = script_string.index("]);")
    result = script_string[0..end_index]
    return result
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

file_directory = "../Library_Page/bestgems/1_rake.html"
web_doc = get_web_page(file_directory)
total_download = get_total_download(web_doc)
total_ranking = get_total_ranking(web_doc)
puts total_download
puts total_ranking
daily_download_extract = get_download_array_data(web_doc)
daily_rank_extract = get_ranking_array_data(web_doc)
download_array = get_data_into_array(daily_download_extract)
ranking_array = get_data_into_array(daily_rank_extract)
puts download_array[5]
#puts ranking_array
