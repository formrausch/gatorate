require 'dcell'
require 'wiringpi'
require 'rest_client'

module Gatorate
  class Heartbeat
    include Celluloid
    include Celluloid::Logger

    def self.spawn(name: :heartbeat_actor, pin:17, frequency:10)
      self.supervise_as name, pin, frequency
      Actor[name].on
      Actor[name]
    end

    def initialize(pin, frequency)
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
        begin
          # from doris client
          timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"
          RestClient.post hook, {'type' => 'heartbeat', 'timestamp' => timestamp}.to_json, :content_type => :json, :accept => :json

          #options = {type: :heartbeat, timestamp: Time.now}
          #HTTP.post hook, form: {payload: options.to_json}

          info "|> Connect #{hook} |> #{timestamp}"
        rescue Errno::ECONNREFUSED => e
          warn "!! Could not connect to #{hook}"
        end
      end
    end

    def add_webhook(url)
      @hooks << url
    end
  end
end

