require 'haml'
require 'sinatra/base'
require "sinatra/reloader"


class DoorORama < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  get '/?' do
    "HELL YEAH!"
  end

end
