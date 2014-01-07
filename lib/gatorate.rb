require_relative 'gatorate/version'
require_relative 'gatorate/support/ip'
require_relative 'gatorate/support/irb'


module Webhook
  def hooks
    @hooks ||= []
  end

  def notify_webhooks
    hooks.each do |hook|
      begin
        send_webhook(hook)
      rescue Errno::ECONNREFUSED => e
        warn "!! Could not connect to #{hook}"
      end
    end
  end

  def add_webhook(url)
    hooks << url
  end
end

module PinActor
  include Celluloid
  include Celluloid::Logger

  def self.spawn(name=self.actor_name, pin=17, frequency=10)
    self.supervise_as name, pin, frequency
    yield self if block_given?
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
    io.read(@pin)
  end

  def write_pin(value)
    io.write(@pin, LOW)
  end
end


require_relative 'gatorate/door'
require_relative 'gatorate/heartbeat'

require_relative 'gatorate/observer'

require_relative 'gatorate/console'
require_relative 'gatorate/web'
