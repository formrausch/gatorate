require 'celluloid'
require 'wiringpi'

class PinActor
  include Celluloid
  include Celluloid::Logger

  def self.spawn(name=self.actor_name, pin=17, frequency=10)
    self.supervise_as name, pin, frequency
    yield Actor[name] if block_given?
    Actor[name]
  end

  def initialize(pin, frequency)
    @pin   = pin
    @frequency = frequency

    @io = WiringPi::GPIO.new(WPI_MODE_SYS)
  end

  def io
    @io
  end

  def read_pin
    io.read(@pin).to_i
  end

  def write_pin(value)
    io.write(@pin, value)
  end
end
