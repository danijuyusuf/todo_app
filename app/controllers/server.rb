require 'sinatra/base'
require 'data_mapper'
require 'bcrypt'
#require 'sinatra_warden'


class Server < Sinatra::Base

enable :sessions



get '/' do
  erb :index
end

get '/login/form' do
  erb :login_form
end

get '/signup/form' do
  User.all.destroy
  erb :signup_form
end


get '/dashboard' do
  user = User.first(:email => session[:email])
  if user.nil?
    redirect '/'
  end
  @current_user = user
  @tasks = user.tasks
  redirect'/new/task' if @tasks.empty?
	erb :dashboard
end

post '/login/attempt' do
  user = User.first(:email => params[:email])
  p user
  p user.firstname
  p user.password

  if !user.nil?
    p "we'v gotten here"
    if user[:password] == BCrypt::Engine.hash_secret(params[:password], user[:salt])
      p user
      session[:email] = user[:email]
      redirect '/dashboard'
    end
  end

  redirect '/'
end

get '/new/task' do
	@title = "Start by adding a todo task"
	erb :new_task
end



post '/signup/form' do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  User.create(:firstname => params[:firstname], :lastname => params[:lastname],:email => params[:email],:password => password_hash,:salt=>password_salt,:created => Time.now)
  redirect '/dashboard'
end

post '/new/task' do
  user = User.first(:email => session[:email])
  p params[:todo]
	Task.create(:todo => params[:todo],:done => false,:created => Time.now,:user_id => user[:id])
	redirect '/dashboard'
end


  # start the server if ruby file executed directly
  run! if app_file == $0
end