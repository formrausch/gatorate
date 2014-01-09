# encoding: utf-8

require 'celluloid/io'
require 'http'
require 'timeout'

module Webhook
  class Repository
    def initialize(actor)
      @name = actor.to_s
    end

    def all
      all = redis.smembers @name
      Array(all)
    end

    def redis
     Redis.current
    end

    def add(url)
      redis.sadd @name, url
    end

    def remove(url)
      redis.srem @name, url
    end

    def each
      all.each
    end
  end

  module Pusher
    include Celluloid
    include Celluloid::IO

    def repository
      Repository.new(name)
    end

    def hooks
      repository.all
    end

    def name
      self.class.name.split("::").last.downcase.to_sym
    end


    def notify_webhooks(payload="")
      hooks.each do |hook|
        async.on_webhook_notify(hook, payload)
      end
    end

    def post_message(hook_url, payload)
      Message.new.send(hook_url, payload)
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
      ensure
        self.terminate
      end
    end

  end
end
