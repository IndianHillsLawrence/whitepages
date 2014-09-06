require 'csv'
require './key.rb'
require './lib/whitepages.rb'

w = Whitepages.new(Key.key)

CSV.foreach("../lawrence/indian_hill.csv") do |row|
  (name1,andx,name2,firstname,lastname,year,company,
   addressno,street,address1,city,state,postalcode,phone,emailaddress,x,ownorrent)=row
  if address1 
    address1 = address1.strip()
    if address1 == 'Address 1'
      next
    elsif address1 == ''
      next
    else
      # use row here...
      print row,"\n"
      print address1," ",city,", ", state," ", postalcode,"\n"
      #https://proapi.whitepages.com/2.0/location.json?street_line_1=2439%20Alabama;city=Lawrence;zip=66046;state=KS;api_key=69be98ce4343a8d5adfa18f11ea75ef7
      #https://proapi.whitepages.com/2.0/location.json/?street_line_1=2439%20Alabama&city=Lawrence&zip=66046&state=KS&api_key=69be98ce4343a8d5adfa18f11ea75ef7 HTTP/1.1\r\nAccept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3\r\nAccept: */*\r\nUser-Agent: Ruby\r\nConnection: close\r\nHost: proapi.whitepages.com:443\r\n\r\n"
      arg = {
        #'house' => addressno,
        #"street"  => street, 
        "street_line_1"  => address1, 
        "city"    => city,
        'zip' => postalcode,
        "state"   => state }
      print arg
      if not Dir.exists? 'output'
        Dir.mkdir('output')
      end
      filename = 'output/' + address1.gsub(' ', '_') + '.json'
      if not File.exists? filename
        File.open(filename, 'w') do |file| 
          data = w.reverse_address(arg)
          print data
          file.write data
        end
      end
    end 
  end
end
