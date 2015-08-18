require 'sinatra/base'
require 'data_mapper'


class Server < Sinatra::Base
 get '/' do
  erb :index
end

  # start the server if ruby file executed directly
  run! if app_file == $0
end