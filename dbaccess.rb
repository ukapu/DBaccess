require 'rubygems'
require 'sequel'
require 'csv'

DB = Sequel.connect(:adapter=>'mysql', :host=>'127.0.0.1', :port=>'3307', :database=>ENV['DB'], :username=>ENV['USR'], :password=>ENV['PWD'])

def createcsv(dataarray, filename) 
  CSV.open(filename, "wb") do |csv|
    csv << ["user id", "email", "number of pledges"]

    dataarray.each do |x| 
      puts x
      x[:pledges] = pledges.where(:fk_user_id => x[:id]).count 
      if x[:pledges] > 0
        csv << x.values
      end
    end

  end
end

users = DB[:users]
pledges = DB[:pledges]
enabled = users.where(:enabled => 1)

#idemails = enabled.select(:id).select_append(:uid).all
twoyears = enabled.where(:id => 3363..4416).select(:id).select_append(:uid).all

createcsv(twoyears, "homelplist-twoyears.csv")
