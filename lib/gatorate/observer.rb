require 'dcell'
require_relative 'support/ip'


module Gatorate
  class Observer #< Celluloid::SupervisionGroup
    include Celluloid::Logger

    def initialize(config)
      begin
        DCell.start :addr => "tcp://#{config["ip"]}:#{config["port"]}", :id => config["node"]

        door      = Gatorate::Door.spawn #name: :door_actor, pin: 18, frequency: 5
        heartbeat = Gatorate::Heartbeat.spawn #name: :hearbeat_actor, pin:17, frequency:10

        # local test
        heartbeat.add_webhook('http://vcap.me:5000/heartbeat')
        door.add_webhook('http://vcap.me:5000/events')

        # Doris
        heartbeat.add_webhook('http://formrausch-doris.herokuapp.com/heartbeat')
        door.add_webhook('http://formrausch-doris.herokuapp.com/events')

        info "** Running DCell on #{config["ip"]}:#{config["port"]} with id #{config["node"]}"

        sleep

      rescue Celluloid::ZMQ::Socket::IOError
        exit_gracefully("Gatorate is already running")
      rescue ::Redis::CannotConnectError
       exit_gracefully("Please start redis-server")
      rescue NoIPAddress
        exit_gracefully("Could not get IP address") if local_ip.nil?
      end
    end

    def exit_gracefully(why="")
      terminate
      warn why
    end
  end
end



