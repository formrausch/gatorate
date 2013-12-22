require 'dcell'
require_relative 'support/ip'

module Gatorate
  class Observer
    def initialize(config)
      begin

        DCell.start :addr => "tcp://#{config["ip"]}:#{config["port"]}", :id => config["node"]
        Gatorate::Door.run
        Gatorate::LED.run

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


module Gatorate
  class LED
    include Celluloid

    def self.run
      Gatorate::LED.supervise_as :led_actor
      Celluloid::Actor[:led_actor].on
    end

    def initialize(pin=17)
      @led_pin = pin
      @io = WiringPi::GPIO.new(WPI_MODE_SYS)
    end

    def on
      @io.write(@led_pin, HIGH)
      after(0.1) {off}
    end

    def off
      @io.write(@led_pin, LOW)
      after(2) {on}
    end

  end
end

