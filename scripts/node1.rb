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
    @io.read(@button_pin).to_i == 1 ? false : true
  end
  
  def opend?
    @io.read(@button_pin).to_i == 1 ? true : false
  end
  
  def status
    @io.read(@button_pin).to_i == 1 ? :opened : :closed
  end
  
end

Door.supervise_as :door_actor

DCell.start :id => "node1", :addr => "tcp://127.0.0.1:4000"

sleep