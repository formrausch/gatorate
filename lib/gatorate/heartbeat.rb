require 'dcell'
require 'wiringpi'

module Gatorate
  class Heartbeat
    include Celluloid

    def self.run(name=:led_actor)
      self.supervise_as name
      Actor[name].on
    end

    def initialize(pin=17, frequency=10)
      @led_pin   = pin
      @frequency = frequency

      @io = WiringPi::GPIO.new(WPI_MODE_SYS)
      @hooks = []
    end

    def on
      @io.write(@led_pin, HIGH)
      notify_webhooks
      after(0.1) { off }
    end

    def off
      @io.write(@led_pin, LOW)
      after(@frequency) { on }
    end

    def notify_webhooks
      @hooks.each do |hook|
        options = {type: :heartbeat, timestamp: Time.now}
        HTTP.post hook, form: {payload: options.to_json}
        Celluloid.logger.info "|> #{hook} |> #{options}"
      end
    end

    def add_webhook(url)
      @hooks << url
    end
  end
end

