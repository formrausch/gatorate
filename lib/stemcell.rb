require 'dcell'

def stemcell(name, ip, port)
  DCell.start :id => name,
              :addr => "tcp://#{ip}:#{port}",
              :directory => {
                 :id => "registry.tomair.local",
                 :addr => "tcp://127.0.0.1:7777" },
              :registry => {
                :adapter => 'redis',
                :host    => 'tom.local',
              }
end
