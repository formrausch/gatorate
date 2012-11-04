require 'haml'
require 'sinatra/base'
require 'dcell'
require 'json'

class Web < Sinatra::Base
  include Celluloid
  
  set :public_folder, 'lib/web/public'
  set :views, 'lib/web/views'
  
  get '/?' do    
    @door = DCell::Node.find("door.local").find(:door_actor)
    haml :index
  end
  
  get '/status' do
    content_type :json
    @door = DCell::Node.find("door.local").find(:door_actor)
    
    { :status => @door.status }.to_json
  end
end
