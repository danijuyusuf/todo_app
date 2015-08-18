require 'sinatra/base'
require 'data_mapper'


class Server < Sinatra::Base

configure do
  enable :sessions
end

helpers do
  def firstname
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

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