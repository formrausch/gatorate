require 'celluloid'
require 'wiringpi'

class PinActor
  include Celluloid
  include Celluloid::IO
  include Celluloid::Logger

  include Webhook::Pusher

  def initialize(options)
    @pin = options[:pin]
    @frequency = options[:frequency]

    start if self.respond_to? :start
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
