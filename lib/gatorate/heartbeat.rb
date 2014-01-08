
module Gatorate
  class Heartbeat < PinActor
    include Celluloid

    def start
      on
    end

    def on
      write_pin HIGH
      notify_webhooks
      after(0.1) { off }
    end

    def off
      write_pin LOW
      after(@frequency) { on }
    end


    def on_webhook_notify(hook_url, payload)
      timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"
      post_message hook_url, type: :heartbeat, timestamp: timestamp
    end

  end
end

