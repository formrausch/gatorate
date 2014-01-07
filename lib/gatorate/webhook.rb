require 'celluloid/io'
require 'net/http'

module Webhook
  include Celluloid::IO

  def hooks
    @hooks ||= []
  end

  def notify_webhooks(payload="")

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

  def http_post(url, payload)
    HTTP.post url, :json => JSON.dump(payload)
  end
end
