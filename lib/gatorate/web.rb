require "dcell"
require 'haml'
require 'sinatra/base'
require 'json'
require 'timeout'

class Web < Sinatra::Base
  set :public_folder, 'lib/gatorate/web/public'
  set :views, 'lib/gatorate/web/views'
  set :run, false

  before do
    @door_node  = DCell::Node.find("door")
    @door       = @door_node.find(:door)
  end

  get '/?' do
    haml :index
  end

  get '/status' do
    content_type :json
    { :status => @door.status }.to_json
  end
end


