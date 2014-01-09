require 'celluloid/autostart'
require 'colorize'
require 'dcell'
require 'yell'
require 'yell-adapters-syslog'

require_relative 'support/ip'

module Gatorate
  class Network
    include Celluloid::Logger

    def initialize options
      @options = options

      setup_logger
      start_network
    end

    def start_network
      options = @options

      begin
        DCell.start addr: dcell_uri(options),
                    id:   options["node"],
                    registry: registry_config(options)

        info "** Running DCell #{options["node"]} on #{options["ip"]}:#{options["port"]}".magenta
        info "** using Redis #{options[:redis]} as registry".magenta

      rescue IOError
        exit_gracefully("Gatorate is already running or redis is not installed")
      rescue ::Redis::CannotConnectError
       exit_gracefully("Please start redis-server")
      rescue NoIPAddress
        exit_gracefully("Could not get IP address") if local_ip.nil?
      end
    end


    def dcell_uri(options)
      "tcp://#{options["ip"]}:#{options["port"]}"
    end

    def registry_config(options)
      redis = URI.parse(options[:redis])

      {
        adapter: 'redis',
        host: redis.host,
        port: redis.port
      }
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
