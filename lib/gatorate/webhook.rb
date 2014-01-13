# encoding: utf-8

require 'celluloid/io'
require 'http'
require 'timeout'


module Webhook
  class Repository
    def initialize(actor, namespace='gatorate.webhooks')
      @name = actor.to_s
      @namespace = namespace
    end

    def key
      "#{@namespace}.#{@name}"
    end


    def all
      all = redis.smembers key
      Array(all)
    end

    def redis
      Redis.current
    end

    def add(url)
      redis.sadd key, url
    end

    def remove(url)
      redis.srem key, url
    end

    def each
      all.each
    end
  end

  class Channel
    include Celluloid

    def push(channel_name, payload="")
      hooks(channel_name).each do |hook|
        Message.new.async.send(hook, payload)
      end
    end

    def repository(channel_name)
      Repository.new(channel_name)
    end

    def hooks(channel_name)
      repository(channel_name).all
    end
  end

  class Message
    include Celluloid
    include Celluloid::IO
    include Celluloid::Logger

    def color_for_status(code)
      case code
      when 0..100
        :light_blue
      when 100..299
        :light_green
      when 400..499
        :light_yellow
      else
        :light_red
      end
    end

    def send(hook_url, payload)
      begin
        request = HTTP.post hook_url, socket_class: Celluloid::IO::TCPSocket, form: {payload: payload}

        msg = "➤ #{request.response.status} Webhook::Message |> #{hook_url} |> #{payload}"
        info msg.send(color_for_status(request.response.status))

      rescue Errno::EHOSTUNREACH
        warn "✖ Webhook::Message |> Could not reach #{hook_url} |> #{payload}".red
      rescue Errno::ECONNREFUSED => e
        warn "✖ Webhook::Message |> Could not connect to #{hook_url} |> #{payload}".red
      rescue Errno::ETIMEDOUT
        warn "✖ Webhook::Message |> Connection Timeout on #{hook_url} |> #{payload}".red
      ensure
        self.terminate
      end
    end

  end
end
