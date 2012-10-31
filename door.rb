# door.rb

require 'dcell'
require 'wiringpi'


class Door
  include Celluloid
  
  def initialize
    @button_pin = 8
    @io = WiringPi::GPIO.new
    @io.mode(@button_pin,INPUT)
  end
  
  def closed?
    button_state  == 1 ? false : true
  end
  
  def opend?
    button_state == 1 ? true : false
  end
  
  def status
    button_state == 1 ? :opened : :closed
  end
  
  private
  
  def button_state
    @io.read(@button_pin).to_i
  end
  
end

Door.supervise_as :door_actor

DCell.start :id => "door", :addr => "tcp://10.0.1.164:4000"

sleep