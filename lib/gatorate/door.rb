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
        channel.push(:door, ping_event_info)
      end

      after(@frequency) {
        check_status(new_status)
      }
    end

    def ping_event_info
      timestamp = Time.now.strftime "%Y-%m-%dT%H:%M:%S%z"

      event = payload
      event_hash = {type: event, state_changed_to: event, timestamp: timestamp}

    end

  end
end

