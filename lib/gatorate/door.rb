require 'celluloid'

module Gatorate
  class Door
    include Celluloid

    def self.run
      Gatorate::Door.supervise_as :door_actor
    end

    def initialize(pin=8)
      @button_pin = pin
      @status = :open
    end

    def open?
      puts status
      status == :open
    end

    def closed?
      !open?
    end

    def status
      @status
    end

    def status=(state)
      @status = state
    end
  end

  begin
    require_relative 'door_on_raspberrypi'
  rescue LoadError => e
  Celluloid.logger.info e
    Celluloid.logger.info 'This is running on a desktop machine'
  end
end


