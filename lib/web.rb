require 'sinatra/base'
require 'haml'
require 'json'
require 'dcell'

class Web < Sinatra::Base
  get '/?' do
    @nodes = DCell::Node.all
    haml :index
  end

  get '/status' do
    content_type :json
    { :status => DCell::Node.find("door.tomair.local").find(:door_actor).status }.to_json
  end
end


