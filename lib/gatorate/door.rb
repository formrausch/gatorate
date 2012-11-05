require 'celluloid'

module Gatorate
  class Door
    include Celluloid  
  
    def initialize
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
    require './door_on_raspberrypi'    
  rescue LoadError
    Celluloid.logger.info 'This is running on a desktop machine'
  end  
end

Gatorate::Door.supervise_as :door_actor
