require 'wiringpi'

module Gatorate
  class Door 
    def initialize(pin=8)
      @io = WiringPi::GPIO.new
      @io.mode(pin, INPUT)
    end
     
    def pin_state
      @io.read(@button_pin).to_i == 1 ? :open : :closed
    end
    alias :pin_state :status
  end
end