require 'dcell'
require_relative 'support/ip'

module Gatorate
  class Observer
    def initialize(config)
      begin

        DCell.start :addr => "tcp://#{config["ip"]}:#{config["port"]}", :id => config["node"]
        Gatorate::Door.run
        Gatorate::Heartbeat.run

        # Doris
        Celluloid::Actor[:led_actor].add_webhook('http://formrausch-doris.herokuapp.com/heartbeat')
        Celluloid::Actor[:door_actor].add_webhook('http://formrausch-doris.herokuapp.com/events')

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



