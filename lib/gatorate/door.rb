require 'celluloid'
require_relative 'support/digital_pin'

module Gatorate
  class Door
    include Celluloid

    def self.run
      Gatorate::Door.supervise_as :door_actor
    end

    def initialize(pin=8, frequency=5)
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
        options = {type: :event, state_changed_to: event, timestamp: Time.now}
        HTTP.post hook, form: {payload: options.to_json}
        Celluloid.logger.info "|> #{hook} |> #{options}"
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

