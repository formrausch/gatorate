require 'irb'
require "dcell"

module Gatorate
  class Console
    def initialize(node_id, ip, port)      
      DCell.start :addr => "tcp://#{ip}:#{port}", :id => "#{node_id}"
      IRB.start_session(binding)
    end
  end
end

