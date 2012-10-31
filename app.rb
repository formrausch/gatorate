require 'haml'
require 'sinatra/base'
require "sinatra/reloader"
require 'wiringpi'
require 'dcell'

DCell.start :id => "app", :addr => "tcp://127.0.0.1:4001", :directory => {:id => "door", :addr => "tcp://10.0.1.164:4000"}
Node = DCell::Node["door"]  

class DoorORama < Sinatra::Base
    
  configure :development do
    register Sinatra::Reloader
  end
  
  before do
    @door = Node[:door_actor]    
  end

  get '/?' do    
    @door_closed = @door.closed? 
    haml :index
  end
  
  get '/on' do
    redirect '/'
  end

  get '/off' do
    redirect '/'
  end
    
end
