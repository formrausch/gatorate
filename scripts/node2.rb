# node2.rb
require 'dcell'

DCell.start :id => "node2", :addr => "tcp://127.0.0.1:4001", :directory => {:id => "door", :addr => "tcp://127.0.0.1:4000"}
node = DCell::Node["door"]
door = node[:door_actor]

loop {

  puts door.closed?
  sleep 3
}