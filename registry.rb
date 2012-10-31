require 'bundler/setup'
require 'dcell'


DCell.start :id => 'registry.tomair.local', :addr => "tcp://127.0.0.1:7777",
            :registry => {
              :adapter => 'redis',
              :host    => 'tom.local',
            }

sleep
