require 'wiringpi'

module Gatorate
  class Door 
    
    def initialize(pin=0)
      @button_pin = pin
      @io = WiringPi::GPIO.new(WPI_MODE_SYS)
      #@io.mode(pin, INPUT)
    end
     
    def status
      @io.read(@button_pin).to_i == 1 ? :open : :closed
    end
  end
end

