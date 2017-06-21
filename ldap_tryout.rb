require 'net/ldap'


def try_auth
  ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)
  puts "export PW=<your passwd> to test " unless ENV["PW"]
  auth = ldap.bind(method: :simple, username: "uid=s0553427, ou=Users, o=f4, dc=htw-berlin, dc=de", password: "#{ENV["PW"]}")
  puts "authorization successful: #{auth} (#{auth.class})"
end


def try_search
  ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)

  puts "export PW=<your passwd> to test " unless ENV["PW"]
  ldap.bind(method: :simple, username: "uid=s0553427, ou=Users, o=f4, dc=htw-berlin, dc=de", password: "#{ENV["PW"]}")
  # search
  treebase = "uid=s0553427, ou=Users, o=f4, dc=htw-berlin, dc=de"
  f = Net::LDAP::Filter.eq("uid", "s0553427")

  r = ldap.search(:base => treebase, :filter => f)

  # Net::LDAP::Entry

  puts r.size
  e = r.first
  puts e.inspect

  puts e.uid
  puts e.objectclass

end


def try_search2
  ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)
  treebase = "o=f4, dc=htw-berlin, dc=de"
  f = Net::LDAP::Filter.eq("uid", "*")
  r = ldap.search(:base => treebase, :filter => f)
  puts ldap.get_operation_result
  puts r.map(&:uid).inspect
  puts r.first
  puts r.size
end


def try_search3

  ldap = Net::LDAP.new :host => "portia.f4.htw-berlin.de",
                       :port => 389,
                       :auth => {
                           :method => :simple,
                           :username => "uid=s0553427, ou=Users, o=f4, dc=htw-berlin, dc=de",
                           :password => "#{ENV["PW"]}"
                       }

  filter = Net::LDAP::Filter.eq( "uid", "s0553427" )
  treebase = "uid=s0553427, ou=Users, o=f4, dc=htw-berlin, dc=de"

  ldap.search( :base => treebase, :filter => filter ) do |entry|
    puts "DN: #{entry.dn}"
    entry.each do |attr, values|
      puts ".......#{attr}:"
      values.each do |value|
        puts "          #{value}"
      end
    end
  end

  puts ldap.get_operation_result

end

#try_auth
#try_search
#try_search2

try_search3