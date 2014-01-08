require 'celluloid/autostart'
require 'dcell'
require 'yell'
require 'yell-adapters-syslog'

require_relative 'support/ip'

module Gatorate
  class Observer
    include Celluloid::Logger

    def initialize(config)
      setup_logger

      begin
        DCell.start addr: "tcp://#{config["ip"]}:#{config["port"]}",
                    id:   config["node"]

        door      = Gatorate::Door.spawn :door, pin: 0, frequency: 0.1
        heartbeat = Gatorate::Heartbeat.spawn :heartbeat, pin: 17, frequency: 3

        ## tombook
        heartbeat.add_webhook('http://192.168.2.104:9292/heartbeat')

        ## Doris
        heartbeat.add_webhook('http://formrausch-doris.herokuapp.com/heartbeat')
        door.add_webhook('http://formrausch-doris.herokuapp.com/events')

        info "** Running DCell on #{config["ip"]}:#{config["port"]} with id #{config["node"]}"

        sleep

      rescue IOError
        exit_gracefully("Gatorate is already running or redis is not installed")
      rescue ::Redis::CannotConnectError
       exit_gracefully("Please start redis-server")
      rescue NoIPAddress
        exit_gracefully("Could not get IP address") if local_ip.nil?
      end
    end

    def exit_gracefully(why="")
      Celluloid.terminate
      warn why
    end

    def setup_logger
      logger = Yell.new do |l|
        l.adapter STDOUT, :level => [:debug, :info, :warn]
        l.adapter STDERR, :level => [:error, :fatal]

        l.adapter :syslog
      end

      Celluloid.logger = logger
    end
  end
end



