require 'csv'
require './key.rb'
require './lib/whitepages.rb'

w = Whitepages.new(Key.key)

CSV.foreach("../lawrence/indian_hill.csv") do |row|
  (name1,andx,name2,firstname,lastname,year,company,addressno,street,address1,city,state,postalcode,phone,emailaddress,x,ownorrent)=row
  if address1 
    address1 = address1.strip()
    if address1 == 'Address 1'
      next
    elsif address1 == ''
      next
    else
      # use row here...
      #print row,"\n"
      print address1," ",city,", ", state," ", postalcode,"\n"
      arg = { "street"  => address1, 
                                 "city"    => city,
                                 'postal_code' => postalcode,
                                 "state"   => state }
      print arg
      data = w.reverse_address(arg)
      print data
      exit
      abort("test")
    end 
  end
end
