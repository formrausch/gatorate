require 'socket'

module Gatorate
  class NoIPAddress < StandardError; end
  
  class IP
    def self.find
      ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private? }
      raise NoIPAddress if ip.nil?  
      ip.ip_address
    end
  end
end