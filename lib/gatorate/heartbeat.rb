
module Gatorate
  class Heartbeat < PinActor
    include Webhook

    def on
      write_pin HIGH
      notify_webhooks
      after(0.1) { off }
    end

    def off
      write_pin LOW
      after(@frequency) { on }
    end

    def send_webhook(hook_url, payload)
      timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"
      async.http_post hook_url, { type: :heartbeat, timestamp: timestamp }
    end
  end
end

