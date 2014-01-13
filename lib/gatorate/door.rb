module Gatorate
  class Door < PinActor

    def start
      check_status
    end

    def open?
      status == :open
    end

    def closed?
      !open?
    end

    def status
      read_pin == 1 ? :open : :closed
    end

    def check_status(last_status=nil)
      new_status = status

      if !last_status.nil? && new_status != last_status
        info "The Door is now [#{new_status}]"
        notify_webhooks(new_status)
      end

      after(@frequency) {
        check_status(new_status)
      }
    end

    def on_webhook_notify(hook_url, payload)
      timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"

      event = payload
      event_hash = {type: event, state_changed_to: event, timestamp: timestamp}

      post_message hook_url, event_hash
    end

  end
end

