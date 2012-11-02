require 'haml'
require 'sinatra/base'
require 'wiringpi'
require 'dcell'
require 'json'


class Web < Sinatra::Base
  
  get '/?' do    
    @door_closed = DCell::Node.find("door.local").find(:door_actor).closed?
    haml :index
  end
  
  get '/status' do
    { :status => DCell::Node.find("door.local").find(:door_actor).status }.to_json
  end
    
end
