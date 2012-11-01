require 'dcell'

def log(txt='')
  DCell::Logger.info txt
end

module DCell
  class Node
    def handle_heartbeat
      log "*" * 10
      super
    end
  end
end


def stemcell(name, ip, port)
  directory = { :node_id => "registry.tomair.local",
                :addr => "tcp://127.0.0.1:7777" }
  registry  = { :adapter => 'redis',
                :host    => 'tomair.local'
              }

  DCell.start :id   => name,
              :addr => "tcp://#{ip}:#{port}",
              :directory => directory,
              :registry  => registry
end


