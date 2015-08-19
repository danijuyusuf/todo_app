require 'sinatra/base'
require 'data_mapper'


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
  @tasks = Task.all(:order => :created.desc)
  redirect'/new/task' if @tasks.empty?
	erb :dashboard
end

get '/new/task' do
	@title = "Start by adding a todo task"
	erb :new_task
end

post '/signup/form' do
  User.create(:firstname => params[:firstname], :lastname => params[:lastname], :email => params[:email], :password => params[:password], :created => Time.now)
  redirect '/dashboard'
end

post '/new/task' do
	Task.create(:todo => params[:todo], :created => Time.now)
	redirect '/dashboard'
end


  # start the server if ruby file executed directly
  run! if app_file == $0
end