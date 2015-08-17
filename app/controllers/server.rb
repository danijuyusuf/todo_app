require 'sinatra/base'

class Server < Sinatra::Base

  get '/' do
    user = User.new("Brice Nkengsa")
    erb :index, :locals => {:user => user}
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end