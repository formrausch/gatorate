require 'celluloid'
require 'socket'

class NoIPAddress < StandardError; end

def exit_gracefully(why='')
  puts why
  Celluloid.shutdown
  exit
end
  
def local_ip
  ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
  raise NoIPAddress if ip.nil?  
  ip.ip_address
end