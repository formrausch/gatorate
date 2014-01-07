

module Gatorate
  class Door < PinActor
    include Webhook

    def open?
      status == :open
    end

    def closed?
      !open?
    end

    def status
      warn read_pin
      read_pin == 1 ? :open : :closed
    end

    def send_webhook(hook_url, payload)
      timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"

      #todo
      event = 1

      event_hash = {type: event, state_changed_to: event, timestamp: timestamp}
      json = JSON.generate(event_hash)

      RestClient.post hook_url, json, :content_type => :json, :accept => :json
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

