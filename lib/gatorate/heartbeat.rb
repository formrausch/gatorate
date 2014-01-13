
module Gatorate
  class Heartbeat < PinActor
    include Celluloid

    def start
      on
    end

    def on
      write_pin HIGH
      channel.push :heartbeat, ping_info
      after(0.08) { off }
    end

    def off
      write_pin LOW
      after(@frequency) { on }
    end

    def ping_info
      timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"
      { type: :heartbeat, timestamp: timestamp }
    end
  end
end

