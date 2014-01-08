require 'celluloid/io'
require 'http'
require 'timeout'

module Webhook
  include Celluloid
  include Celluloid::IO

  def hooks
    @hooks ||= []
  end

  def notify_webhooks(payload="")
    hooks.each do |hook|
      begin
        info "<| before hook #{hook}"
        async.on_notify(hook, payload)
        info "|> Connect #{hook} |> #{self.class.name}"
      rescue Errno::EHOSTUNREACH
        warn "!! Could not reach #{hook} |> #{self.class.name}"
      rescue Errno::ECONNREFUSED => e
        warn "!! Could not connect to #{hook} |> #{self.class.name}"
      rescue Errno::ETIMEDOUT
        warn "!! Connection Timeout on #{hook} |> #{self.class.name}"
      end
    end
  end

  def add_webhook(url)
    hooks << url
  end

  def post_message(hook_url, payload)
    begin
      HTTP.post hook_url, socket_class: Celluloid::IO::TCPSocket, json: JSON.dump(payload)
    rescue Errno::ETIMEDOUT
      warn "!! Connection Timeout on #{hook_url} |> #{self.class.name}"
    end
  end

  def on_notify(hook, payload)
    raise "Please override Webhook::send_webhook"
  end
end


