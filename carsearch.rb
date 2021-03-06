require 'addressable/uri'

def create_query
  options = {}

  puts "Minimum year?"
  options[:autoMinYear] = gets.chomp.to_i

  puts "Maximum year?"
  options[:autoMaxYear] = gets.chomp.to_i

  puts "Minimum price?"
  options[:minAsk] = gets.chomp.to_i

  puts "Maximum price?"
  options[:maxAsk] = gets.chomp.to_i

  puts "What country of manufacturing?"
  puts "Your options are: japan | america | korea | europe | any"
  country = gets.chomp.downcase
  options[:query] = convert_country_to_manufacturer(country)

  puts "Any additional parameters?"
  params = gets.chomp.downcase
  options[:query] = options[:query] + params

  converted_region = convert_region('') #TODO

  puts "What is the seller type?"
  puts "Your options are: owner | dealer | both"
  seller_type = gets.chomp.downcase

  puts "Only include results with pictures? [y/n]"
  pictures_req = (['true', 't', 'y', 'yes'].include?(gets.chomp)) ? true : false

  converted_seller_type = convert_seller_type ( seller_type )
  create_search_string(converted_region, converted_seller_type, pictures_req,
    options)
end

def create_search_string(region, seller_type, pictures_req, query_options)
  
  defaults = {
    :query => "",
    :zoomToPosting => "",
    :minAsk => "",
    :maxAsk => "",
    :autoMinYear => "", 
    :autoMaxYear => ""
  }

  query_options = defaults.merge(query_options)
  query_options[:hasPic] = 1 if pictures_req
  # query_options[:srchType] = 'T' if search_by_title

  search_URI = Addressable::URI.new(
    :scheme => "http",
    :host => "#{region}.craigslist.org",
    :path => "/search/#{seller_type}",
    :query_values => query_options
    ).to_s

  search_URI
end

def convert_seller_type ( seller_type )
  case seller_type.downcase
  when 'owner'
    'cto'
  when 'dealer'
    'ctd'
  else
    'cta'
  end
end

def convert_country_to_manufacturer (country)
  if (['japanese','japan'].include?(country))
    '(honda | toyota | nissan)'
  elsif (['american','america'].include?(country))
    '(ford | chev*)'
  elsif (['european','europe'].include?(country))
    '(bmw | audi | mercedes | mercedes-benz | benz)'
  elsif (['korean','korea'].include?(country))
    '(hyundai | kia)'
  else 
    ''
  end
end

#probably also need a parser for all current makes and models

def convert_region ( region )
  #parse the .txt file into a hash.
  "sfbay"
end
