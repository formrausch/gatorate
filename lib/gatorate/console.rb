require 'irb'
require "dcell"

module Gatorate
  class Console

    def nodes
      DCell::Node.all
    end

    def web
      DCell::Node.find("web")
    end

    def observer
      DCell::Node.find("observe")
    end

    def actor(actor_name)
      observer.find(actor_name.to_sym)
    end

    def door_actor
      actor(:door)
    end

    def heartbeat_actor
      actor(:heartbeat)
    end

    def add_webhook(actor_name, url)
      actor(actor_name.to_sym).repository.add(url)
    end

    def remove_webhook(actor_name, url)
      actor(actor_name.to_sym).repository.remove(url)
    end

    def webhooks(actor_name)
      actor = observer.find(actor_name.to_sym)
      actor.hooks
    end

    def initialize
      IRB.start_session(binding)
    end
  end
end

