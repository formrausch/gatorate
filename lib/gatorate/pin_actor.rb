require 'celluloid'
require 'wiringpi'

class PinActor
  include Celluloid
  include Celluloid::IO
  include Celluloid::Logger
  include Webhook::Pusher

  # we'll use params instead of ruby 2.0
  # named arguments because ruby 2 is
  # not available on raspberry pi without
  # manual (3h) install

  def self.spawn(name=self.actor_name, params={})
    self.supervise_as name, params[:pin], params[:frequency]

    yield Actor[name] if block_given?

    Actor[name].start
    Actor[name]
  end

  def initialize(pin, frequency)
    @pin = pin
    @frequency = frequency
  end

  def start
  end

  def io
    @io ||= WiringPi::GPIO.new(WPI_MODE_SYS)
  end

  def read_pin
    io.read(@pin).to_i
  end

  def write_pin(value)
    io.write(@pin, value)
  end
end
