require 'nokogiri'


##Keeping all gem data and prepare to insert in mongoDB
class Gems_data
  attr_reader :rubygems_data, :bestgems_data, :gem_name, :gem_description, :gem_size, :gem_license, :require_ruby_version, :boolean_array, :gem_total_download, :gem_ranking, :gem_author, :gem_owners, :gem_development_dependencies, :download_array, :ranking_array, :history_array
  def initialize(gem_name)
      @rubygems_data = get_rubygems_body("/Volumes/Data/Ruby Project/Library_Page/rubygems/#{gem_name}")
      @bestgems_data = open_files_nokogiri("/Volumes/Data/Ruby Project/Library_Page/bestgems/#{gem_name}")
      @gem_name = get_gem_name(rubygems_data)
      @gem_description = get_gem_description(@rubygems_data)
      @gem_size = get_gem_size(@rubygems_data)
      @gem_license = get_gem_license(@rubygems_data)
      @require_ruby_version = get_gem_ruby_required_version(@rubygems_data)
      @boolean_array = get_hp_doc_sc_bt_boolean(@rubygems_data)
      @gem_total_download = get_total_download(@bestgems_data)
      @gem_ranking = get_total_ranking(@bestgems_data)
      @gem_author = get_gem_authors(@rubygems_data)
      @gem_owners = get_gem_owners(@rubygems_data)
      @gem_development_dependencies = get_gem_development_dependencies(@rubygems_data)
      daily_download_extract = get_download_array_data(bestgems_data)
      daily_rank_extract = get_ranking_array_data(bestgems_data)
      @download_array = get_data_into_array(daily_download_extract)
      @ranking_array = get_data_into_array(daily_rank_extract)
      @history_array = create_history_array(download_array, ranking_array)
  end

  def open_files_nokogiri(file_name)
    doc = File.open(file_name) { |f| Nokogiri::HTML(f)}
    return doc
  end

  def extract_from_tag(document,tag_name)
      doc = document.xpath(tag_name)
      return doc
  end

  def get_rubygems_body(file_directory)
      doc = open_files_nokogiri("#{file_directory}")
      #extract library name from Total page table ##http://bestgem.org/total
      body_tag_name = '//div[@class="l-wrap--b"]'
      body_data = extract_from_tag(doc,body_tag_name)

      return body_data
  end

  def get_gem_name (document_file)
    name_tag_name = '//h1[@class="t-display page__heading"]//a'
    gem_name = extract_from_tag(document_file,name_tag_name)
    return gem_name.children
  end

  def get_gem_description (document_file)
    description_tag_name = '//div[@class="gem__intro"]//div[@class="gem__desc"]//p'
    gem_description = extract_from_tag(document_file,description_tag_name)
    gem_description.children #Text
  end

  def get_gem_size(document_file)
    begin
      gem_version_tag_name = '//div[@class="versions"]//ol[@class="gem__versions t-list__items"]//li'
      gem_version_table = extract_from_tag(document_file, gem_version_tag_name)
      gem_size_tag_name = '//span[@class="gem__version__date"]'
      gem_size = extract_from_tag(gem_version_table,gem_size_tag_name)
      gem_size_string = gem_size[0].children.to_s[1..-2]
      #split number and KB,MB
      size_array = gem_size_string.split
      #check if MB size * 1024
      if size_array[1] == "MB"
        real_kb_size = size_array[0].to_f * 1024
      else
        real_kb_size = size_array[0].to_f
      end

      return real_kb_size
    rescue
      return 0.0
    end
  end

  #get development dependencies list of a gem
  def get_gem_development_dependencies(document_file)
    development_dependencies_tag_name = '//div[@class="dependencies"]//div[@class="t-list__items"]//a//strong'
    gem_development_dependencies = extract_from_tag(document_file,development_dependencies_tag_name)
    gem_dev =  gem_development_dependencies.children #Array
    dev_array = Array.new
    gem_dev.each do |lib|
      dev_array.push(lib.to_s)
    end
    if dev_array.length < 1
      return ["null"]
    end
    return dev_array
  end

  # get Authors name of a gem

  def get_gem_authors(document_file)
    authors_tag_name = '//div[@class="gem__members"]//ul[@class="t-list__items"]//li//p'
    gem_authors = extract_from_tag(document_file,authors_tag_name)
    gem_authors_array = gem_authors.children.to_s.split(", ")
    return gem_authors_array

  end

  # get owners name of a gem

  def get_gem_owners(document_file)
    owners_tag_name = '//div[@class="gem__members"]//div[@class="gem__owners"]//a'
    gem_owners = extract_from_tag(document_file,owners_tag_name)
    gem_owners_array = gem_owners
    owner_name = Array.new
    gem_owners_array.each do |gem_owner|
      gem_owner = gem_owner.to_s
      start_index = gem_owner.index("title")
      last_index = gem_owner.index("href")
      name = gem_owner[start_index+7..last_index-3]
      owner_name.push(name)
    end
    return owner_name #Array
  end

  #get number of total download of a gem
  def get_gem_total_download(document_file)
    gem_total_download_tag_name = '//span[@class="gem__downloads"]'
    gem_total_download = extract_from_tag(document_file,gem_total_download_tag_name)
    return gem_total_download.children[0]
  end

  # get a license of a gem
  def get_gem_license(document_file)
    gem_license_tag_name = '//span[@class="gem__ruby-version"]//p'
    gem_license = extract_from_tag(document_file, gem_license_tag_name)
    return gem_license.children
  end

  # get a required version of ruby of a gem
  def get_gem_ruby_required_version(document_file)
    gem_ruby_require_tag_name = '//i[@class="gem__ruby-version"]'
    gem_ruby_require = extract_from_tag(document_file, gem_ruby_require_tag_name)
    ruby_require_string = gem_ruby_require.children.to_s.strip
    if(ruby_require_string == "NONE")
      return 0.to_s
    else
      version = ruby_require_string.split
      return version[1].to_s
    end
  end

  # get other gems attribute such as homepage, source code, etc.
  def get_gem_item_list(document_file)
    gem_item_list_tag_name = '//div[@class="t-list__items"]//a'
    gem_item_list = extract_from_tag(document_file, gem_item_list_tag_name)
    return gem_item_list.children
  end

  def get_hp_doc_sc_bt_boolean(document_file)
    item_list = get_gem_item_list(document_file)
    boolean_array = {"homepage" => false, "documentation" => false, "source_code" => false, "bug_tracker" => false}
    item_list.each do |text|
      if text.to_s == "Homepage"
        boolean_array["homepage"] = true
      elsif text.to_s == "Source Code"
        boolean_array["source_code"] = true
      elsif text.to_s == "Documentation"
        boolean_array["documentation"] = true
      elsif text.to_s == "Bug Tracker"
        boolean_array["bug_tracker"] = true
      end
    end
    return boolean_array
  end

  def get_total_download(doc)
    tag_name = '//span[@class="downloads"]'
    download_data = extract_from_tag(doc,tag_name)
    total_download = download_data[1].children
    total_download_string_value = total_download.to_s.split(",")
    power_factor = total_download_string_value.length
    total_download_integer = 0
    for i in 0...power_factor do
      operand = total_download_string_value[i].to_i
      operand = operand * (10 ** (3* (power_factor-1-i) ))
      total_download_integer += operand
    end
    return total_download_integer
  end

  def get_total_ranking(doc)
    tag_name = '//div[@class="span6"]//p//em'
    ranking_data = extract_from_tag(doc,tag_name)
    total_ranking = ranking_data[0].children
    total_ranking_string_value = total_ranking.to_s.split(",")
    power_factor = total_ranking_string_value.length
    total_ranking_integer = 0
    for i in 0...power_factor do
      operand = total_ranking_string_value[i].to_i
      operand = operand * (10 ** (3* (power_factor-1-i) ))
      total_ranking_integer += operand
    end
    return total_ranking_integer
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

  def create_history_array(download_data, ranking_data)
    history_array = Array.new
    for i in 0...download_data.length do
      history_array[i] = Hash.new
      download_raw_array = download_data[i][0]
      ranking_raw_array = ranking_data[i][0]
      history_array[i]["Year"] = download_raw_array[2].to_i
      history_array[i]["Month"] = download_raw_array[0].to_s
      history_array[i]["Date"] = download_raw_array[1].to_i
      history_array[i]["tDownload"] = download_raw_array[3].to_i
      history_array[i]["dDownload"] = download_raw_array[4].to_s
      history_array[i]["tRanking"] = ranking_raw_array[3].to_i
      history_array[i]["dRanking"] = ranking_raw_array[4].to_s
     end
    return history_array[0..-2]
  end

end
