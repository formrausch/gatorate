
module Gatorate
  class Heartbeat < PinActor
    include Webhook

    def on
      write_pin HIGH
      notify_webhooks
      after(0.1) { off }
    end

    def ping
      @ticks ||= 0
      @ticks += 1
      info @ticks
      after(1) { ping }
    end

    def off
      write_pin LOW
      after(@frequency) { on }
    end

    def on_notify(hook_url, payload)
      info '>'
      timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"
      post_message hook_url, type: :heartbeat, timestamp: timestamp
      info '<'
    end
  end
end

