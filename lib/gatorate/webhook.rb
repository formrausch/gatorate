module Webhook
  def hooks
    @hooks ||= []
  end

  def notify_webhooks(payload=[])
    payload = Array(payload)
    hooks.each do |hook|
      begin
        send_webhook(hook, payload)
        info "|> Connect #{hook} |> #{self.class.name}"
      rescue Errno::EHOSTUNREACH
        warn "!! Could not reach #{hook} |> #{self.class.name}"
      rescue Errno::ECONNREFUSED => e
        warn "!! Could not connect to #{hook} |> #{self.class.name}"
      end
    end
  end

  def add_webhook(url)
    hooks << url
  end
end
