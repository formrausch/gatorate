require 'dcell'
require 'gatorate/support/ip'

module Gatorate
  class Observer
    def initialize(config)
      begin
        DCell.start :addr => "tcp://#{config["ip"]}:#{config["port"]}", :id => config["node"]
        Celluloid.logger.info "** Running DCell on #{config["ip"]}:#{config["port"]} with id #{config["node"]}"
        sleep
      rescue Celluloid::ZMQ::Socket::IOError
        exit_gracefully("Gatorate is already running")
      rescue Redis::CannotConnectError
       exit_gracefully("Please start redis-server")
      rescue NoIPAddress
        exit_gracefully("Could not get IP address") if local_ip.nil?  
      end
    end
    
    def exit_gracefully(why="")
      Celluloid.terminate
      Celluloid.logger.warn why
    end  
  end
end