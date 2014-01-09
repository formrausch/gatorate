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

    def door_actor
      @door_node  = DCell::Node.find("observe")
      @door_node.find(:door)
    end

    def heartbeat_actor
      @door_node  = DCell::Node.find("observe")
      @door_node.find(:heartbeat)
    end

    def initialize
      IRB.start_session(binding)
    end
  end
end

