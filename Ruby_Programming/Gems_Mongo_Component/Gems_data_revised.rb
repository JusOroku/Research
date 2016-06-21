require 'nokogiri'


##Keeping all gem data and prepare to insert in mongoDB
class Gems_data_revised
  attr_reader :rubygems_data, :bestgems_data, :gem_name, :gem_description, :gem_size, :gem_license, :require_ruby_version, :boolean_array, :gem_total_download, :gem_ranking, :gem_author, :gem_owners, :gem_development_dependencies, :download_array, :ranking_array, :history_array
  def initialize(gem_name)
      @rubygems_data = get_rubygems_body("../Library_Page/rubygems/#{gem_name}")
      @bestgems_data = open_files_nokogiri("../Library_Page/bestgems/#{gem_name}")
      @gem_name = get_gem_name(rubygems_data)
      @gem_description = get_gem_description(@rubygems_data)
      @gem_size = get_gem_size(@rubygems_data)
      @gem_license = get_gem_license(@rubygems_data)
      @require_ruby_version = get_gem_ruby_required_version(@rubygems_data)
      @boolean_array = get_hp_doc_sc_bt_boolean(@rubygems_data)
      @gem_author = get_gem_authors(@rubygems_data)
      @gem_owners = get_gem_owners(@rubygems_data)
      @gem_development_dependencies = get_gem_development_dependencies(@rubygems_data)
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
    text = gem_description.children.to_s
    return text.split.length #Text
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
      return 0
    end
    return dev_array.length
  end

  # get Authors name of a gem

  def get_gem_authors(document_file)
    authors_tag_name = '//div[@class="gem__members"]//ul[@class="t-list__items"]//li//p'
    gem_authors = extract_from_tag(document_file,authors_tag_name)
    gem_authors_array = gem_authors.children.to_s.split(", ")
    return gem_authors_array.length

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
    return owner_name.length #Array
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
    boolean_array = {"homepage" => 0, "documentation" => 0, "source_code" => 0, "bug_tracker" => 0}
    item_list.each do |text|
      if text.to_s == "Homepage"
        boolean_array["homepage"] = 1
      elsif text.to_s == "Source Code"
        boolean_array["source_code"] = 1
      elsif text.to_s == "Documentation"
        boolean_array["documentation"] = 1
      elsif text.to_s == "Bug Tracker"
        boolean_array["bug_tracker"] = 1
      end
    end
    return boolean_array
  end

end
