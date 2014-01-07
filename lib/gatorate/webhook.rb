module Webhook
  def hooks
    @hooks ||= []
  end

  def notify_webhooks
    hooks.each do |hook|
      begin
        send_webhook(hook)
        info "|> Connect #{hook} |> #{self.class.name}"
      rescue Errno::ECONNREFUSED => e
        warn "!! Could not connect to #{hook} |> #{self.class.name}"
      end
    end
  end

  def add_webhook(url)
    hooks << url
  end
end
