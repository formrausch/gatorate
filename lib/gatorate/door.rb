require 'celluloid'
require_relative 'support/digital_pin'
require 'rest_client'

module Gatorate
  class Door
    include Celluloid
    include Celluloid::Logger

    def self.spawn(name=:door_actor, pin=8, frequency=5)
      Gatorate::Door.supervise_as name, pin, frequency
      Actor[name]
    end

    def initialize(pin, frequency)
      @button_pin = pin
      @frequency  = frequency

      @hooks = []

      begin
        @pin = Artoo::Adaptors::IO::DigitalPin.new(pin, 'r')
      rescue Exception => e
        Celluloid.logger.info e.inspect
        Celluloid.logger.info "Using VirtualPin"
        @pin = Artoo::Adaptors::IO::VirtalPin.new(pin, 'r')
      end

      check_status
    end

    def open?
      status == :open
    end

    def closed?
      !open?
    end

    def status
      @pin.digital_read == 'high' ? :open : :closed
    end

    def add_webhook(url)
      @hooks << url
    end

    def notify_webhooks(event)
      @hooks.each do |hook|
        begin
          #options = {type: :event, state_changed_to: event, timestamp: Time.now}
          #HTTP.post hook, form: {payload: options.to_json}
          #RestClient.post hook, {'type' => 'heartbeat', 'timestamp' => timestamp}.to_json, :content_type => :json, :accept => :json
          #

          # from doris client
          timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"
          event_hash = {:type => "event", :state_changed_to => event, :timestamp => timestamp}
          json = JSON.generate(event_hash)
          RestClient.post hook, json, :content_type => :json, :accept => :json

          info "|> Door Webhook #{hook} |> #{timestamp}"

        rescue Errno::ECONNREFUSED => e
          warn "|> Door - Could not connect to #{hook}"
        end
      end
    end

    def check_status(last_status=nil)
      new_status = status

      if !last_status.nil? && new_status != last_status
        notify_webhooks(new_status)
      end

      after(@frequency) {
        check_status(new_status)
      }
    end
  end

end

