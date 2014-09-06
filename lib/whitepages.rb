require 'json'
require 'net/https'
require 'uri'
require 'open-uri'
#This class holds the methods for consuming the Whitepages API
class Whitepages

  #Initialize the Whitepages class
  # * api_key - The API key obtained from the Whitpages Developer website
  def initialize(api_key)
    api_version = "2.0"
    
    @api_key = api_key
    @base_uri = "https://proapi.whitepages.com"
    @find_person_uri = @base_uri     + "/" + api_version +  "/person.json" +  "?"
    @reverse_phone_uri = @base_uri   + "/" + api_version +  "/phone.json" +  "?"
    @reverse_address_uri = @base_uri + "/" + api_version +  "/location.json" +  "?"
    
    @uri = URI.parse(@base_uri)

  end
  
  #Retrieves contact information about a person, such as a telephone number and address
  #Accepts a hash:
  # * firstname - First Name
  # * lastname - Last Name (*REQUIRED*)
  # * house - May take a range, in the form [start-end]
  # * apt - Apartment
  # * street_line_1 - Street
  # * city - City
  # * state - State
  # * zip - ZipCode/PostalCode
  # * areacode - AreaCode
  # * metro - Whether or not to expand the search to the metro area
  #More details may be found here: http://developer.whitepages.com/docs/Methods/find_person
  def find_person(options)
    uri = build_uri(options, "find_person")
    return proc(uri)
  end

  #Retrieves contact information about a telephone number
  #Accepts a hash:
  # * phone - May be 7 digits if state provided otherwise 10 (*REQUIRED*)
  # * state - Two digit code for the state
  #More details may be found here: http://developer.whitepages.com/docs/Methods/reverse_phone
  def reverse_phone(options)  
    uri = build_uri(options, "reverse_phone")
    return proc(uri)
  end

  def proc(uri)
    stream = open(uri)
    raise 'web service error' if (stream.status.first != '200')
    data = stream.read    
    return JSON.parse(data)
  end
  #Retrieves contact information about the people at an address
  # * house - May take a range, in the form [start-end]
  # * apt - Apartment
  # * street_line_1 - Street (*REQUIRED*)
  # * street_line_2 
  # * city - City
  # * state_code - State
  # * postal_code - ZipCode/PostalCode
  # * areacode - AreaCode
  #More details may be found here: http://developer.whitepages.com/docs/Methods/reverse_address
  def reverse_address(options)
    #https://proapi.whitepages.com/2.0/location.json?street_line_1=413%20E%20Lowe%20St&city=Seattle&state=WA&api_key=KEYVAL

    uri = build_uri(options, "reverse_address")
#    print uri
    return proc(uri)

  end
  
  private 
  
  #Build the appropriate URL
  def build_uri(options, type)
    case type
    when "reverse_phone"
      built_uri = @reverse_phone_uri
    when "reverse_address"
      built_uri = @reverse_address_uri
    when "find_person"
      built_uri = @find_person_uri
    end
    
    options.each do |key,value|
      if value != nil
        built_uri = built_uri + key + "=" + value.gsub(' ', '%20') + "&"
      end
    end
    
    built_uri = built_uri + "api_key=" + @api_key 
    return built_uri
  end
    
end
