require 'sinatra/base'
require 'data_mapper'


class Server < Sinatra::Base

 get '/' do
  erb :index
end

get '/login/form' do
  erb :login_form
end

get '/signup/form' do
  erb :signup_form
end

post '/signup/form' do
  User.create(:firstname => params[:firstname], :lastname => params[:lastname], :email => params[:email], :password => params[:password], :created => Time.now)
  redirect '/'
end


  # start the server if ruby file executed directly
  run! if app_file == $0
end