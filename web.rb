require 'sinatra/base'
require 'haml'
require 'json'
require './stemcell'

stemcell "web.tom.local", "127.0.0.1", 9080

class Web < Sinatra::Base
  configure do
  end

  get '/?' do
    @nodes = DCell::Node.all
    haml :index
  end

  get '/status' do
    content_type :json
    { :status => DCell::Node["door.tomair.local"][:door_actor].status }.to_json
  end
end


