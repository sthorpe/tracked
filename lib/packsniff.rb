# this line imports the libpcap ruby bindings
require 'pcaplet'
require 'rubygems'
require 'active_record'
require 'yaml'
require '../app/models/site.rb'
require 'pusher'

Pusher.app_id = '6976'
Pusher.key = '5a3dbd9931f93f1b450a'
Pusher.secret = '6c413766351af6f3d42b'

ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql2',
  :database => 'trakd_development',
  :username => 'root',
  :password => '',
  :host     => 'localhost')


# create a sniffer that grabs the first 1500 bytes of each packet
$network = Pcaplet.new('-s 1500 -i en1')

# create a filter that uses our query string and the sniffer we just made
$filter = Pcap::Filter.new('tcp and dst port 80', $network.capture)

# add the new filter to the sniffer
$network.add_filter($filter)

# iterate over every packet that goes through the sniffer
for p in $network
  # if the packet matches the filter and the regexp...
  if $filter =~ p and p.tcp_data =~ /GET(.*)HTTP.*Host:([^\r\n]*)/xm
    # print the local IP of the requestor and the requested URL
    puts "#{p.src} - http://#{$2.strip}#{$1.strip}"
    site = Site.find_by_name("#{$2.strip}")
    if site
      site.count = (site.count.to_i + 1)
    else
      site = Site.new(:name => "#{$2.strip}", :url => "http://#{$2.strip}#{$1.strip}", :count => 1)
    end
    site.save!
  end
end
