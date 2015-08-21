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
  erb :signup_form
end


get '/dashboard' do
  user = User.first(:email => session[:email])
  if user.nil?
    redirect '/'
  end
  @current_user = user
  @tasks = user.tasks(:order => :priority.desc)
	erb :dashboard
end

post '/login/attempt' do
  user = User.first(:email => params[:email])

  if !user.nil?
    if user[:password] == BCrypt::Engine.hash_secret(params[:password], user[:salt])
      p user
      session[:email] = user[:email]
      redirect '/dashboard'
    end
  end

  redirect '/login/form'
end

get '/new/task' do
	@title = "Kindly add a todo task with priority"
	erb :new_task
end



post '/signup/form' do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  User.create(:firstname => params[:firstname], :lastname => params[:lastname],:email => params[:email],:password => password_hash,:salt=>password_salt,:created => Time.now)
  
  user = User.first(:email => params[:email])

  if !user.nil?
    session[:email] = user[:email]
  redirect '/dashboard'
end
redirect '/signup/form'
end

post '/new/task' do
  user = User.first(:email => session[:email])
  
	Task.create(:todo => params[:todo],:done => false,:priority => params[:priority].to_i,:created => Time.now,:user_id => user[:id])
	redirect '/dashboard'
end



get '/delete/:id' do
  @task = Task.first(:id => params[:id].to_i)
  erb :delete_task
end

delete '/delete/:id' do
  if params.has_key?("ok")
    task = Task.first(:id => params[:id].to_i)
    task.destroy
    redirect '/dashboard'
  else
    redirect '/dashboard'
  end
end
get '/logout' do
  session.delete(:email)
  erb "<div style= \"color: green\">Successfully logged out!</div>"
end



  # start the server if ruby file executed directly
  run! if app_file == $0
end