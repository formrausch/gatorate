require 'celluloid/io'
require 'http'
require 'timeout'

module Webhook
  module Pusher
    include Celluloid
    include Celluloid::IO

    def hooks
      @hooks ||= []
    end

    def notify_webhooks(payload="")
      hooks.each do |hook|
        async.on_webhook_notify(hook, payload)
      end
    end

    def add_webhook(url)
      hooks << url
    end

    def post_message(hook_url, payload)
      msg = Message.new
      msg.send(hook_url, payload)
      msg.terminate
    end

    def on_webhook_notify(hook, payload)
      raise "Please override Webhook::on_webhook_notify".red
    end
  end

  class Message
    include Celluloid
    include Celluloid::IO
    include Celluloid::Logger

    def send(hook_url, payload)
      begin
        HTTP.post hook_url, socket_class: Celluloid::IO::TCPSocket, json: JSON.dump(payload)
        info "➤ Webhook::Message |> #{hook_url} |> #{payload}".green
      rescue Errno::EHOSTUNREACH
        warn "✖ Webhook::Message |> Could not reach #{hook_url} |> #{payload}".red
      rescue Errno::ECONNREFUSED => e
        warn "✖ Webhook::Message |> Could not connect to #{hook_url} |> #{payload}".red
      rescue Errno::ETIMEDOUT
        warn "✖ Webhook::Message |> Connection Timeout on #{hook_url} |> #{payload}".yellow
      end
    end

  end
end
