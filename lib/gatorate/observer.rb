require 'dcell'
require 'yell'
require 'yell-adapters-syslog'

require_relative 'support/ip'

module Gatorate
  class Observer #< Celluloid::SupervisionGroup
    include Celluloid::Logger


    def initialize(config)
      begin
        logger = Yell.new do |l|
          l.adapter STDOUT, :level => [:debug, :info, :warn]
          l.adapter STDERR, :level => [:error, :fatal]

          l.adapter :syslog
        end

        Celluloid.logger = logger

        DCell.start :addr => "tcp://#{config["ip"]}:#{config["port"]}", :id => config["node"]

        door = Gatorate::Door.spawn :door, 0, 0.1 do |gate|
          gate.check_status
        end

        heartbeat = Gatorate::Heartbeat.spawn :heartbeat, 17, 10 do |beat|
          beat.on
        end

        # Lighter
        door.add_webhook('http://10.0.1.41:9292/events')

        # tombook
        heartbeat.add_webhook('http://10.0.1.56:9292/heartbeat')
        door.add_webhook('http://10.0.1.56:9292/events')

        # Doris
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
      rescue
        exit_gracefully("I don't know why we can't start")
      end
    end

    def exit_gracefully(why="")
      Celluloid.terminate
      warn why
    end
  end
end



